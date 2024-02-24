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
    function getID(address gnome) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function increaseHP(uint256 tokenId, uint256 _HP) external;
    function increaseGnomeFeedAmount(uint256 tokenId, uint256 _feedAmount) external;
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

contract GnomeFeeder is IUniswapV3FlashCallback, PeripheryImmutableState, PeripheryPayments, Ownable {
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
    uint24 public flashPoolFee = 1000; //  flash from the 0.05% fee of pool
    address private constant GNOME = 0x42069d11A2CC72388a2e06210921E839Cfbd3280;
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    mapping(address gnome => uint256) public feedAmountGnome;
    mapping(address gnome => uint256) public feedAmountETH;
    uint256 multiplier = 2;
    uint256 margin = 100;

    mapping(string => uint256) public foodPriceETH;
    mapping(string => uint256) public foodPriceGnome;
    mapping(string => uint256) public foodHP;


    constructor(
        address _WETH9,
        address _factory,
        address _gnomePlayer
    ) PeripheryImmutableState(_factory, _WETH9) Ownable(msg.sender) {
        pool = IUniswapV3Pool(0x4762A162bB535b736b83d49a87B3e1AE3267c80c);
        gnome = IGNOME(_gnomePlayer);
        foodPriceGnome["mushroom"] = 420 ether;
        foodPriceGnome["banana"] = 420 ether;
        foodPriceETH["mushroom"] = 0.00069 ether;
        foodPriceGnome["banana"] = 0.00069 ether;
        foodHP["mushroom"] = 10;
        foodHP["banana"] = 10;
    }

    function setPool(address _pool) public onlyOwner {
        pool = IUniswapV3Pool(_pool);
    }

    function feedGnome(string memory food) external payable {
        uint256 tokenId = gnome.getID(msg.sender);
        require(tokenId > 0, "User Not SignedUp");
        require(foodPriceGnome[food] > 0, "Gnomes can't eat that");
        

        address feedToken = GNOME;
        uint256 feedAmount = foodPriceGnome[food];

        address otherToken = feedToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = feedToken < otherToken ? (feedToken, otherToken) : (otherToken, feedToken);
        uint256 amount0 = feedToken == token0 ? feedAmount : 0;
        uint256 amount1 = feedToken == token1 ? feedAmount : 0;

        FlashCallbackData memory callbackData = FlashCallbackData({
            token: feedToken,
            amount: feedAmount,
            payer: tx.origin
        });
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, abi.encode(callbackData, pool));

        gnome.increaseHP(tokenId, foodHP[food]);
        gnome.increaseGnomeFeedAmount(tokenId, 1);
        
    }

    function uniswapV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata data) external override {
        (FlashCallbackData memory callback, address flashPool) = abi.decode(data, (FlashCallbackData, address));
        require(msg.sender == flashPool, "Only Pool can call!");

        address feedToken = callback.token;
        uint256 feedAmount = callback.amount;
        uint256 fee = fee0 > 0 ? fee0 : fee1;
        // start trade
        uint256 amountOwed = feedAmount.add(fee);
        getFeeFromBooper(feedToken, multiplier * fee, callback.payer);

        pay(feedToken, address(this), flashPool, amountOwed);
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

    function multiFeedWeth(string memory food) public payable returns (uint amountGnome, uint amountWeth) {
        require(foodPriceETH[food] > 0, "Gnomes can't eat that");
        uint256 tokenId = gnome.getID(msg.sender);
        IWETH(WETH9).deposit{value: msg.value}();
        assert(IWETH(WETH9).transfer(address(this), msg.value));

        uint amountWeth = msg.value;
        uint feedAmount = amountWeth / foodPriceETH[food];
        gnome.increaseHP(tokenId, feedAmount * foodHP[food]);
        gnome.increaseGnomeFeedAmount(tokenId, feedAmount);

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);
        feedAmountETH[msg.sender] = msg.value;

        // Set up swap parameters
        for (uint256 i = 0; i < feedAmount; i++) {
            // Buy
            IWETH(WETH9).approve(address(swapRouter), msg.value);
            feedAmountETH[msg.sender] = msg.value;

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

    function multiFeedGnome(
        string memory food,
        uint feedAmount
    ) public payable returns (uint amountGnome, uint amountWeth) {
        require(foodPriceGnome[food] > 0, "Gnomes can't eat that");
        uint256 tokenId = gnome.getID(msg.sender);
        uint256 _gnomeAmount = foodPriceGnome[food] * feedAmount;

        IGNOME(GNOME).transferFrom(msg.sender, address(this), _gnomeAmount);
        gnome.increaseHP(tokenId, feedAmount * foodHP[food]);
        gnome.increaseGnomeFeedAmount(tokenId, feedAmount);

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);
        feedAmountGnome[msg.sender] = foodPriceGnome[food] * feedAmount;
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        // Set up swap parameters
        for (uint256 i = 0; i < feedAmount; i++) {
            ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                tokenIn: GNOME,
                tokenOut: WETH9,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: (foodPriceGnome[food] * feedAmount * margin) / 100,
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
        feedAmountGnome[fren] = amount;
    }

    function changeFlashPoolFee(uint24 poolFee) public onlyOwner {
        flashPoolFee = poolFee;
    }

    function setGameContract(address _gameAddress) public onlyOwner {
        gnome = IGNOME(_gameAddress);
    }

    function setMultiplier(uint24 _multiplier) public onlyOwner {
        multiplier = _multiplier;
    }

    function setMargin(uint24 _margin) public onlyOwner {
        margin = _margin;
    }

    function setFeedPrice(string memory food, uint256 _priceETH, uint256 _priceGnome) public onlyOwner {
        foodPriceGnome[food] = _priceGnome;
        foodPriceETH[food] = _priceETH;
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
