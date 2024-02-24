// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
pragma abicoder v2;

import {IUniswapV3FlashCallback} from "./interfaces/uniswap/IUniswapV3FlashCallback.sol";
import {IUniswapV3Pool} from "./interfaces/uniswap/IUniswapV3Pool.sol";
import {PeripheryPayments, IERC20} from "./Utils/PeripheryPayments.sol";
import {PeripheryImmutableState} from "./Utils/PeripheryImmutableState.sol";
import {PoolAddress} from "./Utils/PoolAddress.sol";
import {SafeMath} from "./Utils/SafeMath.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

/// @title Flashloan contract implementation
/// @notice contract using the Uniswap V3 flash function
interface IGNOME {
    function balanceOf(address) external view returns (uint256);
    function approve(address spender, uint value) external returns (bool);
    function decreaseHP(uint256 tokenId, uint256 _HP) external;
    function increaseXP(uint256 tokenId, uint256 _XP) external;
    function increaseGnomeBoopAmount(uint256 tokenId, uint256 _boopAmount) external;
    function setGnomeBoopTimeStamp(uint256 tokenId, uint256 _lastAtackTimeStamp) external;
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function canGetBooped(uint256 tokenId) external returns (bool);
    function getID(address gnome) external view returns (uint256);
    function getXP(uint256 tokenId) external view returns (uint256);
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

contract GnomeBooperTestV2 is IUniswapV3FlashCallback, PeripheryImmutableState, PeripheryPayments, Ownable {
    using SafeMath for uint256;
    IUniswapV3Pool public pool;
    IGNOME public gnome;
    struct FlashCallbackData {
        address token;
        uint256 amount;
        address payer;
    }
    struct Call {
        address to;
        bytes data;
    }
    uint24 public flashPoolFee = 1000; //  flash from the 1% fee of pool
    address private constant GNOME = 0x42069d11A2CC72388a2e06210921E839Cfbd3280;
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    mapping(address => uint256) public boopAmountGnome;
    mapping(address => uint256) public boopAmountETH;
    uint256 multiplier = 1;
    uint256 margin = 100;
    uint256 pricePerBoopETH = 0.001 ether;
    uint256 pricePerBoopGNOME = 420 ether;
    uint256 pricePerFlashBoop = 42000 ether;
    uint256 boopOdds = 40;
    uint256 boopWin = 10;
    uint256 boopHP = 3;

    constructor(
        address _WETH9,
        address _factory,
        address _gnomePlayer
    ) PeripheryImmutableState(_factory, _WETH9) Ownable(msg.sender) {
        pool = IUniswapV3Pool(0x4762A162bB535b736b83d49a87B3e1AE3267c80c);
        gnome = IGNOME(_gnomePlayer);
    }

    function setPool(address _pool) public onlyOwner {
        pool = IUniswapV3Pool(_pool);
    }

    function setBoopOdds(uint256 _odds) public onlyOwner {
        boopOdds = _odds;
    }

    function setBoopHP(uint256 _boopHP) public onlyOwner {
        boopHP = _boopHP;
    }

    function boopResult(uint256 booperGnome, uint256 boopedGnome) internal returns (bool) {
        uint256 booperGnomeXP = gnome.getXP(booperGnome);
        uint256 boopedGnomeXP = gnome.getXP(boopedGnome);
        // Generate a random number using block.timestamp
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, booperGnome, boopedGnome)));

        // Convert the random number into a boolean
        bool result = (randomNumber % 100) < boopOdds;
        if (result) {
            gnome.increaseXP(booperGnomeXP, (boopedGnomeXP * boopWin) / 100);
            gnome.decreaseHP(boopedGnomeXP, boopHP);
            gnome.setGnomeBoopTimeStamp(boopedGnome, block.timestamp);
        }

        return result;
    }

    function boopGnome(uint256 boopedTokenId) public {
        uint256 booperTokenId = gnome.getID(msg.sender);
        require(booperTokenId > 0, "User Not SignedUp");
        require(gnome.canGetBooped(boopedTokenId), "Gnome has been booped rencently or has a shield try again later");

        uint256 boopAmount = pricePerFlashBoop;
        address boopToken = GNOME;
        address otherToken = boopToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = boopToken < otherToken ? (boopToken, otherToken) : (otherToken, boopToken);
        uint256 amount0 = boopToken == token0 ? boopAmount : 0;
        uint256 amount1 = boopToken == token1 ? boopAmount : 0;
        boopResult(booperTokenId, boopedTokenId);
        FlashCallbackData memory callbackData = FlashCallbackData({
            token: boopToken,
            amount: boopAmount,
            payer: tx.origin
        });
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, abi.encode(callbackData, pool));
    }

    function uniswapV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata data) external override {
        (FlashCallbackData memory callback, address flashPool) = abi.decode(data, (FlashCallbackData, address));
        require(msg.sender == flashPool, "Only Pool can call!");

        address boopToken = callback.token;
        uint256 boopAmount = callback.amount;
        uint256 fee = fee0 > 0 ? fee0 : fee1;
        // start trade
        uint256 amountOwed = boopAmount.add(fee);
        getFeeFromBooper(boopToken, multiplier * fee, callback.payer);

        pay(boopToken, address(this), flashPool, amountOwed);
    }

    function swapETH_Gnome(uint value, bool isWETH) public payable returns (uint amountGnome, uint amountWeth) {
        if (!isWETH) {
            // Wrap ETH to WETH
            IWETH(WETH9).deposit{value: value}();
            assert(IWETH(WETH9).transfer(address(this), value));
        }

        uint amountToSwap = value;

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: GNOME,
            fee: 10000, // Assuming a 0.1% pool fee
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountToSwap,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountGnome = swapRouter.exactInputSingle(params);
    }

    function swapGnome_ETH(uint value) public payable returns (uint amountGnome, uint amountWeth) {
        uint amountToSwap = value;

        // Approve the router to spend WETH
        IWETH(GNOME).approve(address(swapRouter), value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: GNOME,
            tokenOut: WETH9,
            fee: 10000, // Assuming a 0.1% pool fee
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountToSwap,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountGnome = swapRouter.exactInputSingle(params);
    }

    function multiBoopWeth() public payable returns (uint amountGnome, uint amountWeth) {
        IWETH(WETH9).deposit{value: msg.value}();
        assert(IWETH(WETH9).transfer(address(this), msg.value));

        uint amountWeth = msg.value;
        uint boopAmount = amountWeth / pricePerBoopETH;

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);
        boopAmountETH[msg.sender] = msg.value;

        // Set up swap parameters
        for (uint256 i = 0; i < boopAmount; i++) {
            // Buy
            IWETH(WETH9).approve(address(swapRouter), msg.value);
            boopAmountETH[msg.sender] = msg.value;

            ISwapRouter.ExactInputSingleParams memory paramsBuy = ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: GNOME,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountWeth,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountGnome = swapRouter.exactInputSingle(paramsBuy);

            // Sell
            IWETH(GNOME).approve(address(swapRouter), amountGnome);

            ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                tokenIn: GNOME,
                tokenOut: WETH9,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: (amountGnome * margin) / 100,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountWeth = swapRouter.exactInputSingle(paramsSell);
        }
    }

    function multiBoopGnome(uint256 _gnomeAmount) public payable returns (uint amountGnome, uint amountWeth) {
        IGNOME(GNOME).transferFrom(msg.sender, address(this), _gnomeAmount);

        uint boopAmount = _gnomeAmount / pricePerBoopGNOME;

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);
        boopAmountGnome[msg.sender] = _gnomeAmount;
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        // Set up swap parameters
        for (uint256 i = 0; i < boopAmount; i++) {
            ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                tokenIn: GNOME,
                tokenOut: WETH9,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: (_gnomeAmount * margin) / 100,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountWeth = swapRouter.exactInputSingle(paramsSell);

            ISwapRouter.ExactInputSingleParams memory paramsBuy = ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: GNOME,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountWeth,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            _gnomeAmount = swapRouter.exactInputSingle(paramsBuy);
        }
    }

    function getFeeFromBooper(address token, uint256 amount, address fren) internal {
        IGNOME(token).transferFrom(fren, address(this), amount);
        boopAmountGnome[fren] = amount;
    }

    function changeFlashPoolFee(uint24 poolFee) public onlyOwner {
        flashPoolFee = poolFee;
    }

    function setMultiplier(uint24 _multiplier) public onlyOwner {
        multiplier = _multiplier;
    }

    function setMargin(uint24 _margin) public onlyOwner {
        margin = _margin;
    }

    function setBoopPrice(
        uint256 _pricePerBoopETH,
        uint256 _pricePerBoopGNOME,
        uint256 _pricePerFlashBoop
    ) public onlyOwner {
        pricePerBoopETH = _pricePerBoopETH;
        pricePerBoopGNOME = _pricePerBoopGNOME;
        pricePerFlashBoop = _pricePerFlashBoop;
    }

    function frensFundus() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function somethingAboutTokens(address token) external onlyOwner {
        uint256 balance = IGNOME(token).balanceOf(address(this));
        IGNOME(token).transfer(msg.sender, balance);
    }

    fallback() external payable {}

    receive() external payable {}
}
