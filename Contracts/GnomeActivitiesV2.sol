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
    function getIsSleeping(uint256 tokenId) external view returns (bool);
    function wakeUpGnome(uint256 tokenId) external;
    function ownerOfGnomeID(uint256 tokenId) external view returns (address);
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

contract GnomeActionsV2 is IUniswapV3FlashCallback, Ownable {
    IUniswapV3Pool public pool;
    IGNOME public gnome;
    struct FlashCallbackData {
        address token;
        uint256 amount;
        address payer;
        uint256 gnomeId;
    }
    struct Call {
        address to;
        bytes data;
    }
    uint24 public flashPoolFee = 1000; //  flash from the 0.05% fee of pool
    address private GNOME;
    address private GNOMESNFT = 0x42072eE045b0B776eA1D8E2Ea8535EA0E8fDB96A;
    ISwapRouter public constant swapRouter = ISwapRouter(0x2626664c2603336E57B271c5C0b26F421741e481);
    address WETH9 = 0x4200000000000000000000000000000000000006;
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

    uint256 boopWin = 10;
    uint256 boopLoose = 1;
    uint256 boopHP = 3;
    uint256 meditationTime = 1 hours;
    uint256 boopCoolDown = 30 minutes;
    uint256 public mul = 1;
    uint256 public div = 1;
    uint32 _twapInterval = 100;
    uint256 loopMultiplier = 10;

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
        activityPriceGnome["wakeup"] = 4200 ether;
        activityPriceGnome["hug"] = 690 ether;
        activityPriceETH["mushroom"] = 0.00069 ether;
        activityPriceETH["rice"] = 0.00069 ether;
        activityPriceETH["pea"] = 0.00069 ether;
        activityPriceETH["banana"] = 0.00042 ether;
        activityPriceETH["dance"] = 0.00069 ether;
        activityPriceETH["meditate"] = 0.00420 ether;
        activityPriceETH["wakeup"] = 0.01 ether;
        activityPriceETH["hug"] = 0.01 ether;
        activityHP["mushroom"] = 10;
        activityHP["rice"] = 20;
        activityHP["pea"] = 30;
        activityHP["hug"] = 50;
        activityHP["banana"] = 1;
        activityHP["dance"] = 15;
        activityHP["meditate"] = 20;
        activityHP["wakeup"] = 0;
        IGNOME(_gnome).approve(address(swapRouter), type(uint256).max);
    }

    function setPool(address _pool) public onlyOwner {
        pool = IUniswapV3Pool(_pool);
    }

    function gnomeAction(uint256 tokenId, string memory activity) external {
        require(msg.sender == gnome.ownerOfGnomeID(tokenId), "You are not the owner of this Gnome");

        if (keccak256(abi.encodePacked(activity)) != keccak256(abi.encodePacked("wakeup")))
            require(!gnome.getIsSleeping(tokenId), "You need to wake up your Gnome First!");
        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );

        require(activityPriceGnome[activity] > 0, "Gnomes can't eat that");

        address feedToken = GNOME;
        uint256 amount = activityPriceGnome[activity] * 100;

        address otherToken = feedToken == WETH9 ? GNOME : WETH9;
        (address token0, address token1) = feedToken < otherToken ? (feedToken, otherToken) : (otherToken, feedToken);
        uint256 amount0 = feedToken == token0 ? amount : 0;
        uint256 amount1 = feedToken == token1 ? amount : 0;

        FlashCallbackData memory callbackData = FlashCallbackData({
            token: feedToken,
            amount: amount,
            payer: tx.origin,
            gnomeId: tokenId
        });
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, abi.encode(callbackData, pool));

        gnome.increaseHP(tokenId, activityHP[activity]);

        gnome.increaseGnomeActivityAmount(activity, tokenId, 1);

        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("meditate")))
            gnome.setMeditateTimeStamp(tokenId, block.timestamp + meditationTime);

        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("wakeup"))) gnome.wakeUpGnome(tokenId);

        emit Activity(msg.sender, gnome.getTokenUserName(tokenId), activity, gnome.currentHP(tokenId));
    }

    function setBoopOdds(uint256 _boopWin, uint256 _boopLoose) public onlyOwner {
        boopWin = _boopWin;
        boopLoose = _boopLoose;
    }

    function setBoopPrice(uint256 _pricePerBoopETH, uint256 _pricePerBoopGNOME) public onlyOwner {
        pricePerBoopETH = _pricePerBoopETH;
        pricePerBoopGNOME = _pricePerBoopGNOME;
        pricePerFlashBoop = _pricePerBoopGNOME * 100;
    }

    function setBoopHP(uint256 _boopHP) public onlyOwner {
        boopHP = _boopHP;
    }

    function setLoopMultiplier(uint256 _loopMultiplier) public onlyOwner {
        loopMultiplier = _loopMultiplier;
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
        uint256 booperGnomeHP = gnome.getHP(booperGnome);
        uint256 boopedGnomeHP = gnome.getHP(boopedGnome);

        uint256 booperGnomeBalance = IGNOME(GNOMESNFT).balanceOf(gnome.ownerOfGnomeID(booperGnome));
        uint256 boopedGnomeBalance = IGNOME(GNOMESNFT).balanceOf(gnome.ownerOfGnomeID(boopedGnome));

        // Ensure we don't divide by zero
        uint256 totalXP = booperGnomeXP + boopedGnomeXP;
        uint256 totalHP = booperGnomeHP + boopedGnomeHP;

        require(totalXP > 0, "Total XP cannot be zero");
        require(totalHP > 0, "Total HP cannot be zero");
        require(boopedGnomeBalance > 0, "Booped gnome balance cannot be zero");

        // Calculate boop odds
        uint256 xpFactor = (booperGnomeXP * 100) / totalXP;
        uint256 hpFactor = (booperGnomeHP * 100) / totalHP;
        uint256 balanceFactor = (booperGnomeBalance * 100) / boopedGnomeBalance;

        uint256 boopOdds = (xpFactor * hpFactor * balanceFactor) / (100 * 100); // normalize the odds to be in 0-100 range

        // Generate a random number using all variables
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    booperGnome,
                    boopedGnome,
                    booperGnomeXP,
                    boopedGnomeXP,
                    booperGnomeHP,
                    boopedGnomeHP,
                    booperGnomeBalance,
                    boopedGnomeBalance,
                    block.number // adding an additional variable to ensure randomness
                )
            )
        );

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

    function boopGnome(uint256 booperTokenId, uint256 boopedTokenId) public {
        uint256 booperGnomeXP = gnome.getXP(booperTokenId);
        uint256 boopedGnomeXP = gnome.getXP(boopedTokenId);
        require(msg.sender == gnome.ownerOfGnomeID(booperTokenId), "You are not the owner of this Gnome");

        require(booperTokenId != boopedTokenId, "you can't Boop yourself");
        require(boopedGnomeXP >= booperGnomeXP, "You Can only Boop players with moreXP than you");
        require(
            !gnome.isMeditating(booperTokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );

        require(!gnome.getIsSleeping(booperTokenId), "You need to wake up your Gnome First!");
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
            payer: tx.origin,
            gnomeId: booperTokenId
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
        uint256 tokenID = callback.gnomeId;
        uint256 fee = fee0 > 0 ? fee0 : fee1;
        // start trade
        uint256 amountOwed = amount + fee;
        getFeeFromGnome(feedToken, tokenID, multiplier * fee, callback.payer);

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

    function multiActionWeth(
        uint256 tokenId,
        string memory activity
    ) public payable returns (uint amountGnome, uint amountWeth) {
        require(activityPriceETH[activity] > 0, "Gnomes can't do that yet");
        require(msg.sender == gnome.ownerOfGnomeID(tokenId), "You are not the owner of this Gnome");

        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        if (keccak256(abi.encodePacked(activity)) != keccak256(abi.encodePacked("wakeup"))) {
            require(!gnome.getIsSleeping(tokenId), "You need to wake up your Gnome First!");
        }
        require(msg.value >= activityPriceETH[activity], "You Need to send more ETH");
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
        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("wakeup"))) {
            gnome.wakeUpGnome(tokenId);
        }
        // Set up swap parameters
        for (uint256 i = 0; i < amount; i++) {
            // Buy
            for (uint256 j = 0; j < loopMultiplier; j++) {
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

    function multiActionGnome(
        uint256 tokenId,
        string memory activity,
        uint amount
    ) public returns (uint amountGnome, uint amountWeth) {
        require(activityPriceGnome[activity] > 0, "Gnomes can't do that yet");
        require(msg.sender == gnome.ownerOfGnomeID(tokenId), "You are not the owner of this Gnome");
        require(
            !gnome.isMeditating(tokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        if (keccak256(abi.encodePacked(activity)) != keccak256(abi.encodePacked("wakeup")))
            require(!gnome.getIsSleeping(tokenId), "You need to wake up your Gnome First!");
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

        if (keccak256(abi.encodePacked(activity)) == keccak256(abi.encodePacked("wakeup"))) gnome.wakeUpGnome(tokenId);
        // Set up swap parameters
        for (uint256 i = 0; i < amount; i++) {
            for (uint256 j = 0; j < loopMultiplier; j++) {
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

    function multiBoopWeth(
        uint256 booperTokenId,
        uint256 boopedTokenId
    ) public payable returns (uint amountGnome, uint amountWeth) {
        uint256 booperGnomeXP = gnome.getXP(booperTokenId);
        uint256 boopedGnomeXP = gnome.getXP(boopedTokenId);
        require(msg.sender == gnome.ownerOfGnomeID(booperTokenId), "You are not the owner of this Gnome");
        require(booperTokenId != boopedTokenId, "you can't Boop yourself");
        require(boopedGnomeXP > booperGnomeXP, "You Can only Boop players with moreXP than you");
        require(!gnome.getIsSleeping(booperTokenId), "You need to wake up your Gnome First!");
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
        amountWeth = msg.value;
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
            for (uint256 j = 0; j < loopMultiplier; j++) {
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
        uint256 booperTokenId,
        uint256 boopedTokenId,
        uint256 _gnomeAmount
    ) public returns (uint amountGnome, uint amountWeth) {
        IGNOME(GNOME).transferFrom(msg.sender, address(this), _gnomeAmount);
        uint256 booperGnomeXP = gnome.getXP(booperTokenId);
        uint256 boopedGnomeXP = gnome.getXP(boopedTokenId);
        require(msg.sender == gnome.ownerOfGnomeID(booperTokenId), "You are not the owner of this Gnome");
        require(
            !gnome.isMeditating(booperTokenId),
            "Meditating Gnomes must focus on the astral mission they can't indulge in such activities"
        );
        require(boopedGnomeXP > booperGnomeXP, "You Can only Boop players with moreXP than you");
        require(!gnome.getIsSleeping(booperTokenId), "You need to wake up your Gnome First!");
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
            for (uint256 j = 0; j < loopMultiplier; j++) {
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

    function getFeeFromGnome(address token, uint256 tokenID, uint256 amount, address fren) internal {
        IGNOME(token).transferFrom(fren, address(this), amount);
        activityAmountGnome[fren] += amount;

        gnome.increaseGnomeSpentAmount(tokenID, amount);
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
