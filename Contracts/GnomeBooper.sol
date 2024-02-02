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

    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

contract GnomeBooperTestV1 is IUniswapV3FlashCallback, PeripheryImmutableState, PeripheryPayments, Ownable {
    using SafeMath for uint256;
    IUniswapV3Pool public pool;
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
    mapping(address gnome => uint256) public boopAmountGnome;
    mapping(address gnome => uint256) public boopAmountETH;
    uint256 multiplier = 2;

    constructor(address _WETH9, address _factory) PeripheryImmutableState(_factory, _WETH9) Ownable(msg.sender) {
        pool = IUniswapV3Pool(0x4762A162bB535b736b83d49a87B3e1AE3267c80c);
    }

    function setPool(address _pool) public onlyOwner {
        pool = IUniswapV3Pool(_pool);
    }

    function boopGnome(address boopToken, uint256 boopAmount) external payable {
        address otherToken = boopToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = boopToken < otherToken ? (boopToken, otherToken) : (otherToken, boopToken);
        uint256 amount0 = boopToken == token0 ? boopAmount : 0;
        uint256 amount1 = boopToken == token1 ? boopAmount : 0;
        if (boopToken == WETH9) {
            require(msg.value >= boopAmount, "Not Enough to boop Gnome");
        }

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

    function swapETH_Gnome() public payable returns (uint amountGnome, uint amountWeth) {
        // Wrap ETH to WETH
        IWETH(WETH9).deposit{value: msg.value}();
        assert(IWETH(WETH9).transfer(address(this), msg.value));

        uint amountToSwap = msg.value / 2;

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);

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

    function getFeeFromBooper(address token, uint256 amount, address fren) internal {
        IGNOME(token).transferFrom(fren, address(this), amount);

        if (token == WETH9) {
            IGNOME(WETH9).approve(address(swapRouter), amount);
            IWETH(WETH9).deposit{value: amount}();
            assert(IWETH(WETH9).transfer(address(this), amount));

            // Set up swap parameters
            ISwapRouter.ExactInputSingleParams memory buyparams = ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: GNOME,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            // Perform the Volume Swap
            uint256 amountGnome = swapRouter.exactInputSingle(buyparams);

            boopAmountETH[fren] = amount;
        } else {
            boopAmountGnome[fren] = amount;
        }
    }

    function changeFlashPoolFee(uint24 poolFee) public onlyOwner {
        flashPoolFee = poolFee;
    }

    function setMultiplier(uint24 _multiplier) public onlyOwner {
        multiplier = _multiplier;
    }

    fallback() external payable {}

    receive() external payable {}
}
