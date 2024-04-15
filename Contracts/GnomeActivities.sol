// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IUniswapV3FlashCallback} from "./interfaces/uniswap/IUniswapV3FlashCallback.sol";
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {PeripheryImmutableState} from "./Utils/PeripheryImmutableState.sol";
import {PoolAddress} from "./Utils/PoolAddress.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
import {TickMath} from "./Utils/TickMath.sol";
import {FullMath, LiquidityAmounts} from "./Utils/LiquidityAmounts.sol";
import "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";

/// @title Flashloan contract implementation
/// @notice contract using the Uniswap V3 flash function
interface IGNOME {
    function balanceOf(address) external view returns (uint256);
    function approve(address spender, uint value) external returns (bool);
    function getID(address gnome) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function increaseHP(uint256 tokenId, uint256 _HP) external;
    function increaseXP(uint256 tokenId, uint256 _XP) external;
    function increaseGnomeActivityAmount(string memory activity, uint256 tokenId, uint256 _amount) external;
    function increaseGnomeBoopAmount(uint256 tokenId, uint256 _boopAmount) external;
    function setBoopTimeStamp(uint256 tokenId, uint256 _lastAtackTimeStamp) external;
    function decreaseHP(uint256 tokenId, uint256 _HP) external;
    function canGetBooped(uint256 tokenId) external returns (bool);
    function useGameRewards(address fren, address to, uint256 itemPrice) external;
    function getTokenUserName(uint256 tokenId) external view returns (string memory);
    function getXP(uint256 tokenId) external view returns (uint256);
    function getHP(uint256 tokenId) external view returns (uint256);
    function currentHP(uint256 tokenId) external view returns (uint256);
    function setMeditateTimeStamp(uint256 tokenId, uint256 _meditateTimeStamp) external;
    function isMeditating(uint256 tokenId) external view returns (bool);
    function decreaseXP(uint256 tokenId, uint256 _XP) external;
    function increaseETHSpentAmount(uint256 tokenId, uint256 _ethAmount) external;
    function increaseGnomeSpentAmount(uint256 tokenId, uint256 _gnomeAmount) external;
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

interface ISwapRouter is IUniswapV3SwapCallback {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract GnomeActions is IUniswapV3FlashCallback, Ownable {
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
    address private GNOME;
    ISwapRouter public constant swapRouter = ISwapRouter(0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E);
    address WETH9 = 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14;
    mapping(address => uint256) public boopAmountGnome;
    mapping(address => uint256) public boopAmountETH;
    mapping(address => uint256) public activityAmountGnome;
    mapping(address => uint256) public activityAmountETH;
    mapping(address => uint256) public lastBoop;
    uint24 multiplier = 1;
    uint256 priceMultiplier = 100;
    uint256 margin = 100;
    uint256 pricePerBoopETH = 0.01 ether;
    uint256 pricePerBoopGNOME = 420 ether;
    uint256 pricePerFlashBoop = 42000 ether;
    uint256 boopOdds = 40;
    uint256 boopWin = 10;
    uint256 boopLoose = 1;
    uint256 boopHP = 3;
    uint256 meditationTime = 1 hours;
    uint256 boopCoolDown = 30 minutes;
    uint256 public mul = 1;
    uint256 public div = 1;
    uint32 _twapInterval = 100;

    mapping(string => uint256) public activityPriceETH;
    mapping(string => uint256) public activityPriceGnome;
    mapping(string => uint256) public activityHP;
    event Boop(address indexed from, string booperName, string boopedName, bool isETH, bool boopResult);
    event MultiBoop(
        address indexed from,
        string booperName,
        string boopedName,
        bool isETH,
        uint256 totalAmount,
        uint256 successfullBoopAmount,
        uint256 volume
    );
    event Activity(address indexed from, string gnomeName, string activity, uint256 newHP);
    event MultiActivity(
        address indexed from,
        string activity,
        string gnomeName,
        bool isETH,
        uint256 totalAmount,
        uint256 newHP,
        uint256 volume
    );

    constructor(address _gnome, address _gnomePlayer) Ownable(msg.sender) {
        //pool = IUniswapV3Pool(0x4762A162bB535b736b83d49a87B3e1AE3267c80c);
        gnome = IGNOME(_gnomePlayer);
        GNOME = _gnome;
        activityPriceGnome["mushroom"] = 420 ether;
        activityPriceGnome["rice"] = 420 ether;
        activityPriceGnome["pea"] = 420 ether;
        activityPriceGnome["banana"] = 69 ether;
        activityPriceGnome["dance"] = 420 ether;
        activityPriceGnome["meditate"] = 420 ether;
        activityPriceETH["mushroom"] = 0.00069 ether;
        activityPriceETH["rice"] = 0.00069 ether;
        activityPriceETH["pea"] = 0.00069 ether;
        activityPriceETH["banana"] = 0.00042 ether;
        activityPriceETH["dance"] = 0.00069 ether;
        activityPriceETH["meditate"] = 0.00420 ether;
        activityHP["mushroom"] = 10;
        activityHP["rice"] = 20;
        activityHP["pea"] = 30;
        activityHP["banana"] = 1;
        activityHP["dance"] = 15;
        activityHP["meditate"] = 20;
        IGNOME(_gnome).approve(address(swapRouter), type(uint256).max);
    }

    function setPool(address _pool) public onlyOwner {
        pool = IUniswapV3Pool(_pool);
    }

    function gnomeAction(string memory activity) external {
        uint256 tokenId = gnome.getID(msg.sender);
        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        require(tokenId > 0, "User Not SignedUp");
        require(activityPriceGnome[activity] > 0, "Gnomes can't eat that");

        address feedToken = GNOME;
        uint256 amount = activityPriceGnome[activity];

        address otherToken = feedToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = feedToken < otherToken ? (feedToken, otherToken) : (otherToken, feedToken);
        uint256 amount0 = feedToken == token0 ? amount : 0;
        uint256 amount1 = feedToken == token1 ? amount : 0;

        FlashCallbackData memory callbackData = FlashCallbackData({token: feedToken, amount: amount, payer: tx.origin});
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, abi.encode(callbackData, pool));

        gnome.increaseHP(tokenId, activityHP[activity]);
        gnome.increaseGnomeActivityAmount(activity, tokenId, 1);
        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("meditate")))
            gnome.setMeditateTimeStamp(tokenId, block.timestamp + meditationTime);

        emit Activity(msg.sender, gnome.getTokenUserName(tokenId), activity, gnome.currentHP(tokenId));
    }

    function setBoopOdds(uint256 _odds, uint256 _boopWin, uint256 _boopLoose) public onlyOwner {
        boopOdds = _odds;
        boopWin = _boopWin;
        boopLoose = _boopLoose;
    }

    function setBoopPrice(uint256 _boopOdds, uint256 _pricePerBoopETH, uint256 _pricePerBoopGNOME) public onlyOwner {
        boopOdds = _boopOdds;
        pricePerBoopETH = _pricePerBoopETH;
        pricePerBoopGNOME = _pricePerBoopGNOME;
    }

    function setBoopHP(uint256 _boopHP) public onlyOwner {
        boopHP = _boopHP;
    }

    function currentBoopPrice(bool isFlash, bool isETH) public view returns (uint256) {
        uint256 timeSinceLastBoop = block.timestamp - lastBoop[msg.sender];
        uint256 basePrice = isFlash ? pricePerFlashBoop : isETH ? pricePerBoopETH : pricePerBoopGNOME;
        uint256 startPrice = basePrice * priceMultiplier;

        // Check if it's within the cooldown period to adjust the price
        if (timeSinceLastBoop < boopCoolDown) {
            uint256 priceDecreasePerSecond = (startPrice - basePrice) / boopCoolDown;
            uint256 priceDecrease = timeSinceLastBoop * priceDecreasePerSecond;
            uint256 currentPrice = startPrice - priceDecrease;
            return currentPrice;
        } else {
            return basePrice; // After cooldown, return to base price
        }
    }

    function boopResult(uint256 booperGnome, uint256 boopedGnome, uint256 i) internal returns (bool) {
        uint256 booperGnomeXP = gnome.getXP(booperGnome);
        uint256 boopedGnomeXP = gnome.getXP(boopedGnome);
        // Generate a random number using block.timestamp
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp * i, booperGnome, boopedGnome)));

        // Convert the random number into a boolean
        bool result = (randomNumber % 100) < boopOdds;
        if (result) {
            gnome.increaseXP(booperGnome, (boopedGnomeXP * boopWin) / 100);
            gnome.decreaseHP(boopedGnome, boopHP);

            gnome.setBoopTimeStamp(boopedGnome, block.timestamp);
            if (boopedGnomeXP > 10000) {
                uint256 amount = (booperGnomeXP * boopWin) / 100;
                gnome.decreaseXP(boopedGnome, amount > boopedGnomeXP ? boopedGnomeXP : amount);
            }
        } else {
            if (booperGnomeXP > 10000) {
                uint256 amount = (booperGnomeXP * boopLoose) / 100;
                gnome.decreaseXP(booperGnome, amount > booperGnomeXP ? booperGnomeXP : amount);
            }
        }

        return result;
    }

    function boopGnome(uint256 boopedTokenId) public {
        uint256 booperTokenId = gnome.getID(msg.sender);
        uint256 booperGnomeXP = gnome.getXP(booperTokenId);
        uint256 boopedGnomeXP = gnome.getXP(boopedTokenId);
        require(booperTokenId > 0, "User Not SignedUp");
        require(booperTokenId != boopedGnomeXP, "you can't Boop yourself");
        require(boopedGnomeXP >= booperGnomeXP, "You Can only Boop players with moreXP than you");
        require(
            !gnome.isMeditating(booperTokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        require(gnome.canGetBooped(boopedTokenId), "Gnome has been booped rencently or has a shield try again later");

        uint256 boopAmount = currentBoopPrice(true, false);
        address boopToken = GNOME;
        address otherToken = boopToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = boopToken < otherToken ? (boopToken, otherToken) : (otherToken, boopToken);
        uint256 amount0 = boopToken == token0 ? boopAmount : 0;
        uint256 amount1 = boopToken == token1 ? boopAmount : 0;
        bool result = boopResult(booperTokenId, boopedTokenId, 1);
        FlashCallbackData memory callbackData = FlashCallbackData({
            token: boopToken,
            amount: boopAmount,
            payer: tx.origin
        });
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, abi.encode(callbackData, pool));
        emit Boop(
            msg.sender,
            gnome.getTokenUserName(booperTokenId),
            gnome.getTokenUserName(boopedTokenId),
            false,
            result
        );
        lastBoop[msg.sender] = block.timestamp;
    }

    function uniswapV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata data) external override {
        (FlashCallbackData memory callback, address flashPool) = abi.decode(data, (FlashCallbackData, address));
        require(msg.sender == address(pool), "Only Pool can call!");

        address feedToken = callback.token;
        uint256 amount = callback.amount;
        uint256 fee = fee0 > 0 ? fee0 : fee1;
        // start trade
        uint256 amountOwed = amount + fee;
        getFeeFromGnome(feedToken, multiplier * fee, callback.payer);

        IWETH(feedToken).transfer(flashPool, amountOwed);
    }

    function setMulDiv(uint256 _mul, uint256 _div) external onlyOwner {
        mul = _mul;
        div = _div;
    }

    function buyGnome(
        uint256 slip,
        bool isWETH,
        bool slipOn
    ) public payable returns (uint amountGnome, uint amountWeth) {
        if (!isWETH) {
            // Wrap ETH to WETH
            IWETH(WETH9).deposit{value: msg.value}();
            assert(IWETH(WETH9).transfer(address(this), msg.value));
        }

        uint amountToSwap = msg.value;
        uint amountOutMinimum;
        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), msg.value);
        if (slipOn) {
            // Estimate the amount of GNOME to be received
            uint expectedAmountGnome = getExpectedAmountGnome(amountToSwap);

            // Calculate the minimum amount after slippage
            amountOutMinimum = (expectedAmountGnome * (10000 - slip)) / 10000;
        }
        // Set up swap parameters with amountOutMinimum based on slippage tolerance
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: GNOME,
            fee: 10000, // Assuming a 0.1% pool fee
            recipient: msg.sender,
            amountIn: amountToSwap,
            amountOutMinimum: slipOn ? amountOutMinimum : 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountGnome = swapRouter.exactInputSingle(params);
    }

    function getExpectedAmountGnome(uint amountWeth) public view returns (uint expectedAmountGnome) {
        uint price = gnomePrice(address(pool), _twapInterval); // Get the current price of GNOME in terms of WETH
        // Assuming the price is the amount of WETH needed to buy 1 GNOME,
        // and both tokens have the same decimals (e.g., 18),
        // you can calculate the expected amount of GNOME as follows:
        expectedAmountGnome = (amountWeth * (10 ** 18)) / price;
        return expectedAmountGnome;
    }

    function multiActionWeth(string memory activity) public payable returns (uint amountGnome, uint amountWeth) {
        require(activityPriceETH[activity] > 0, "Gnomes can't do that yet");

        uint256 tokenId = gnome.getID(msg.sender);
        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        IWETH(WETH9).deposit{value: msg.value}();
        assert(IWETH(WETH9).transfer(address(this), msg.value));

        amountWeth = msg.value;
        gnome.increaseETHSpentAmount(tokenId, amountWeth);
        uint amount = amountWeth / activityPriceETH[activity];
        gnome.increaseHP(tokenId, amount * activityHP[activity]);
        gnome.increaseGnomeActivityAmount(activity, tokenId, amount);
        uint256 volGenerated;
        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        activityAmountETH[msg.sender] += msg.value;
        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("meditate")))
            gnome.setMeditateTimeStamp(tokenId, block.timestamp + amount * meditationTime);
        // Set up swap parameters
        for (uint256 i = 0; i < amount; i++) {
            // Buy

            volGenerated += amountWeth;
            ISwapRouter.ExactInputSingleParams memory paramsBuy = ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: GNOME,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                amountIn: amountWeth,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountGnome = swapRouter.exactInputSingle(paramsBuy);

            // Sell

            ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                tokenIn: GNOME,
                tokenOut: WETH9,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                amountIn: (amountGnome * margin) / 100,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountWeth = swapRouter.exactInputSingle(paramsSell);
        }

        emit MultiActivity(
            msg.sender,
            activity,
            gnome.getTokenUserName(tokenId),
            true,
            amount,
            gnome.currentHP(tokenId),
            volGenerated
        );
    }

    function multiActionGnome(string memory activity, uint amount) public returns (uint amountGnome, uint amountWeth) {
        require(activityPriceGnome[activity] > 0, "Gnomes can't do that yet");
        uint256 tokenId = gnome.getID(msg.sender);
        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        uint256 _gnomeAmount = activityPriceGnome[activity] * amount;

        IGNOME(GNOME).transferFrom(msg.sender, address(this), _gnomeAmount);
        gnome.increaseHP(tokenId, amount * activityHP[activity]);
        gnome.increaseGnomeActivityAmount(activity, tokenId, amount);
        gnome.increaseGnomeSpentAmount(tokenId, _gnomeAmount);
        uint256 volGenerated;
        // Approve the router to spend WETH

        activityAmountGnome[msg.sender] += activityPriceGnome[activity] * amount;
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("meditate")))
            gnome.setMeditateTimeStamp(tokenId, block.timestamp + amount * meditationTime);
        // Set up swap parameters
        for (uint256 i = 0; i < amount; i++) {
            volGenerated += (_gnomeAmount * margin) / 100;
            ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                tokenIn: GNOME,
                tokenOut: WETH9,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                amountIn: (activityPriceGnome[activity] * amount * margin) / 100,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountWeth = swapRouter.exactInputSingle(paramsSell);

            ISwapRouter.ExactInputSingleParams memory paramsBuy = ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: GNOME,
                fee: 10000, // Assuming a 0.1% pool fee
                recipient: address(this),
                amountIn: amountWeth,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            _gnomeAmount = swapRouter.exactInputSingle(paramsBuy);
        }
        emit MultiActivity(
            msg.sender,
            activity,
            gnome.getTokenUserName(tokenId),
            false,
            amount,
            gnome.currentHP(tokenId),
            volGenerated
        );
    }

    function multiBoopWeth(uint256 boopedTokenId) public payable returns (uint amountGnome, uint amountWeth) {
        uint256 booperTokenId = gnome.getID(msg.sender);
        uint256 booperGnomeXP = gnome.getXP(booperTokenId);
        uint256 boopedGnomeXP = gnome.getXP(boopedTokenId);
        require(booperTokenId > 0, "User Not SignedUp");
        require(booperTokenId != boopedGnomeXP, "you can't Boop yourself");
        require(boopedGnomeXP > booperGnomeXP, "You Can only Boop players with moreXP than you");
        require(msg.value >= currentBoopPrice(false, true), "You Need to send more ETH");
        require(
            !gnome.isMeditating(booperTokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        require(
            gnome.canGetBooped(boopedTokenId),
            "Gnome has been booped rencently, has a shield or its Meditating try again later"
        );

        IWETH(WETH9).deposit{value: msg.value}();
        assert(IWETH(WETH9).transfer(address(this), msg.value));
        gnome.increaseETHSpentAmount(booperTokenId, msg.value);
        uint amountWeth = msg.value;
        activityAmountETH[msg.sender] += msg.value;
        uint boopAmount = amountWeth / currentBoopPrice(false, true);
        uint256 boopedAmount;
        uint256 volGenerated;

        // Approve the router to spend WETH
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        boopAmountETH[msg.sender] = msg.value;

        // Set up swap parameters
        for (uint256 i = 0; i < boopAmount; i++) {
            // Buy
            for (uint256 j = 0; j < 10; j++) {
                volGenerated += amountWeth;
                ISwapRouter.ExactInputSingleParams memory paramsBuy = ISwapRouter.ExactInputSingleParams({
                    tokenIn: WETH9,
                    tokenOut: GNOME,
                    fee: 10000, // Assuming a 0.1% pool fee
                    recipient: address(this),
                    amountIn: amountWeth,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });

                amountGnome = swapRouter.exactInputSingle(paramsBuy);

                // Sell

                ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                    tokenIn: GNOME,
                    tokenOut: WETH9,
                    fee: 10000, // Assuming a 0.1% pool fee
                    recipient: address(this),
                    amountIn: (amountGnome * margin) / 100,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });

                amountWeth = swapRouter.exactInputSingle(paramsSell);
            }

            bool result = boopResult(booperTokenId, boopedTokenId, i);
            if (result) {
                boopedAmount++;
            }
        }
        emit MultiBoop(
            msg.sender,
            gnome.getTokenUserName(booperTokenId),
            gnome.getTokenUserName(boopedTokenId),
            true,
            boopAmount,
            boopedAmount,
            volGenerated
        );
    }

    function multiBoopGnome(
        uint256 boopedTokenId,
        uint256 _gnomeAmount
    ) public returns (uint amountGnome, uint amountWeth) {
        uint256 booperTokenId = gnome.getID(msg.sender);
        IGNOME(GNOME).transferFrom(msg.sender, address(this), _gnomeAmount);
        require(booperTokenId > 0, "User Not SignedUp");
        require(
            !gnome.isMeditating(booperTokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        require(gnome.canGetBooped(boopedTokenId), "Gnome has been booped rencently or has a shield try again later");
        gnome.increaseGnomeSpentAmount(booperTokenId, _gnomeAmount);
        uint boopAmount = _gnomeAmount / currentBoopPrice(false, false);
        uint256 boopedAmount;
        uint256 volume;
        activityAmountGnome[msg.sender] += _gnomeAmount;
        // Approve the router to spend WETH

        boopAmountGnome[msg.sender] = _gnomeAmount;
        IWETH(GNOME).approve(address(swapRouter), type(uint256).max);
        IWETH(WETH9).approve(address(swapRouter), type(uint256).max);
        // Set up swap parameters
        for (uint256 i = 0; i < boopAmount; i++) {
            for (uint256 j = 0; j < 10; j++) {
                volume += (_gnomeAmount * margin) / 100;
                ISwapRouter.ExactInputSingleParams memory paramsSell = ISwapRouter.ExactInputSingleParams({
                    tokenIn: GNOME,
                    tokenOut: WETH9,
                    fee: 10000, // Assuming a 0.1% pool fee
                    recipient: address(this),
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
                    amountIn: amountWeth,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });

                _gnomeAmount = swapRouter.exactInputSingle(paramsBuy);
            }
            bool result = boopResult(booperTokenId, boopedTokenId, 1);
            if (result) {
                boopedAmount++;
            }
        }
        emit MultiBoop(
            msg.sender,
            gnome.getTokenUserName(booperTokenId),
            gnome.getTokenUserName(boopedTokenId),
            false,
            boopAmount,
            boopedAmount,
            volume
        );
    }

    function getFeeFromGnome(address token, uint256 amount, address fren) internal {
        IGNOME(token).transferFrom(fren, address(this), amount);
        activityAmountGnome[fren] += amount;
        uint256 booperTokenId = gnome.getID(fren);
        gnome.increaseGnomeSpentAmount(booperTokenId, amount);
    }

    function changeFlashPoolFee(uint24 poolFee) public onlyOwner {
        flashPoolFee = poolFee;
    }

    function setGameContract(address _gameAddress) public onlyOwner {
        gnome = IGNOME(_gameAddress);
    }

    function setMultiplier(uint24 _multiplier, uint256 _priceMultiplier) public onlyOwner {
        multiplier = _multiplier;
        priceMultiplier = _priceMultiplier;
    }

    function setMargin(uint24 _margin) public onlyOwner {
        margin = _margin;
    }

    function setActionPrice(string memory action, uint256 _priceETH, uint256 _priceGnome) public onlyOwner {
        activityPriceGnome[action] = _priceGnome;
        activityPriceETH[action] = _priceETH;
    }

    function frensFundus() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function somethingAboutTokens(address token) external onlyOwner {
        uint256 balance = IGNOME(token).balanceOf(address(this));
        IGNOME(token).transfer(msg.sender, balance);
    }

    function gnomePrice(address uniswapV3Pool, uint32 twapInterval) public view returns (uint256 price) {
        if (twapInterval == 0) {
            // return the current price if twapInterval == 0
            (uint160 sqrtPriceX96, , , , , , ) = IUniswapV3Pool(uniswapV3Pool).slot0();

            uint256 amount0 = FullMath.mulDiv(
                IUniswapV3Pool(uniswapV3Pool).liquidity(),
                FixedPoint96.Q96,
                sqrtPriceX96
            );

            uint256 amount1 = FullMath.mulDiv(
                IUniswapV3Pool(uniswapV3Pool).liquidity(),
                sqrtPriceX96,
                FixedPoint96.Q96
            );
            price = (amount1 * mul) / (amount0 * div);
        } else {
            uint32[] memory secondsAgos = new uint32[](2);
            secondsAgos[0] = twapInterval; // from (before)
            secondsAgos[1] = 0; // to (now)

            (int56[] memory tickCumulatives, ) = IUniswapV3Pool(uniswapV3Pool).observe(secondsAgos);

            // tick(imprecise as it's an integer) to price
            uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(
                int24((tickCumulatives[1] - tickCumulatives[0]) / int56(int32(twapInterval)))
            );

            uint256 amount0 = FullMath.mulDiv(
                IUniswapV3Pool(uniswapV3Pool).liquidity(),
                FixedPoint96.Q96,
                sqrtPriceX96
            );

            uint256 amount1 = FullMath.mulDiv(
                IUniswapV3Pool(uniswapV3Pool).liquidity(),
                sqrtPriceX96,
                FixedPoint96.Q96
            );

            price = (amount1 * mul) / (amount0 * div);
        }
    }

    function setTwap(uint32 twapInterval) public onlyOwner {
        _twapInterval = twapInterval;
    }

    fallback() external payable {}

    receive() external payable {}
}
