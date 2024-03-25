// SPDX-License-Identifier: MIT
/*

░██████╗░███╗░░██╗░█████╗░███╗░░░███╗███████╗██╗░░░░░░█████╗░███╗░░██╗██████╗░
██╔════╝░████╗░██║██╔══██╗████╗░████║██╔════╝██║░░░░░██╔══██╗████╗░██║██╔══██╗
██║░░██╗░██╔██╗██║██║░░██║██╔████╔██║█████╗░░██║░░░░░███████║██╔██╗██║██║░░██║
██║░░╚██╗██║╚████║██║░░██║██║╚██╔╝██║██╔══╝░░██║░░░░░██╔══██║██║╚████║██║░░██║
╚██████╔╝██║░╚███║╚█████╔╝██║░╚═╝░██║███████╗███████╗██║░░██║██║░╚███║██████╔╝
░╚═════╝░╚═╝░░╚══╝░╚════╝░╚═╝░░░░░╚═╝╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░

                                   ╓╓╓▄▄▄▓▓█▓▓▓▓▀▀▀▀▀▀▓█
                             ╓▄██▀╙╙░░░░░░░░░░░░░░░░╠╬║█
                        ╓▄▓▀╙░░░░░░░░░░░░░░░░░░░░░░╠╠╠║▌
                     ╓█╩░░░░░░░░░░░░░░░░░░░░░░░░░░╠╠╠╠║▌
                   ▄█▒░░░░░░░░░░░░░▒▄██████▄▄░░░░░╠╠╠╠║▌
                 ╓██▀▀▀╙╙╚▀░░░░░▄██╩░░░░░░░░╙▀█▄▒░╠╠╠╠╬█
              ╓▓▀╙░░░░░░░░░░░░░╚╩░░░░░░░░░░░░░░╙▀█╠╠╠╠╬▓
             ▄╩░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╠╠╠╠╠║▌
            ║██▓▓▓▓▓▄▄▒░░░░░░░░░░░▄▄██▓█▄▄▒░░░░░░░╠╠╠╠╠╬█
           ╔▀         ╙▀▀█▓▄▄▄██▀╙       └╙▀█▄▒░░░╠╠╠╠╠╠║▌
          ║█▀▀╙╙╙▀▀▓▄╖       ▄▄▓▓▓▓╗▄▄╓      ╙╙█▄▒░╠╠╠╠╠╬█
        ╓▀   ╓╓╓╓╓╓   ╙█▄ ▄▀╙          ╙▀▓▄      ╙▀▓▒▒╠╠╠║▌
        ▐██████████╙╙▀█▄ ╙█▄▓████████▀▀╗▄           █▀███╬█
        █║██████▌ ██    ╙██╓███████╙▀█   └▀╗╓       ║▒   ╙╙▓
       ╒▌╫███████╦╫█     ║ ╫███████╓▄█▌     └█╕     ║▌    ▀█▀▀
        █╚██████████    ╓╣ ║██████████▒    ╔▀╙      ║▒     └█
       ┌╣█╣████████╓╓▄▓▓▒▄█▄║████████▌╓╗╗▀╙        ╓█        ╚▄
       │█▄╗▀▀╙      ╙▀╙         ╙▀▀██▒            ▄█          ╙▄
     █▒                               ╙▀▀▀▀╠█▌╓▄▓▀             ║
      ╙█╓           ╓╓                   ╓██╩║▌                ║
       ╓╣███▄▄▄▄▓██╬╬╠╬███▄▄▄▄╓╓╓╓╓▄▄▄▓█╬╬▒░░╠█             ╔ ┌█
      ╓▌  ▀█╬╬▒╠╠╠╠░▒░░░╠╠╠╚╚╚╩╠╠╠╠╬███▀╩░░░▄█        ▓      █▀
     ╒▌   ╘█░╚╚╚╚╚▀▀▀▀▀▀▀▀▀▀▀▀▀▀╚╚╚░░░░░░▄█▀╙         ║      ▐▌
     ╟     └▀█▄▒▒▒░░░░░░░░░░░▒▒▒▒▒▄▄█▓╝▀╙                    ▐▌
     ║░        ╙╙▀▀▀▀▀▀▀▀▀▀▀▀▀▀╙╙                        ╓   █
      █                                                  ▓ ╓█
      ║▌   ╔                                            ╔█▀
       █   ╚▄                              ╓╩          ╔▀
       ╚▌   ╙                             ▓▀         ╓█╙
        ╙▌          ▐                  ╓═    ▄    ╓▄▀╙
          ▀▄        ╙▒                      ▄██▄█▀
            ╙▀▄╓║▄   └                    ▄╩
                ╙▀█                   ╓▄▀▀
                   ▀▓        ▄▄▓▀▀▀▀╙
                     └▀╗▄╓▄▀╙
    

Gnome Factory:
    Mints Gnomes and creates UniV3 concentrated liquidity position for $GNOME/WETH.
https://www.gnomeland.money/
https://twitter.com/Gnome0xLand




 */
pragma solidity ^0.8.20;
import {TickMath} from "./Utils/TickMath.sol";
import {FullMath, LiquidityAmounts} from "./Utils/LiquidityAmounts.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
pragma abicoder v2;
import "@uniswap/v3-core/contracts/libraries/FixedPoint96.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
//import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";

interface IUniswapV3Factory {
    function owner() external view returns (address);

    function feeAmountTickSpacing(uint24 fee) external view returns (int24);

    function getPool(address tokenA, address tokenB, uint24 fee) external view returns (address pool);

    function createPool(address tokenA, address tokenB, uint24 fee) external returns (address pool);
    function setOwner(address _owner) external;
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function withdraw(uint256) external;
}

interface IFACTORY {
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external returns (bool);
    function createPool(address tokenA, address tokenB, uint24 fee) external returns (address pool);
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

interface IMinimalNonfungiblePositionManager {
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable returns (address pool);
    function positions(
        uint256 tokenId
    )
        external
        view
        returns (
            uint96 nonce,
            address operator,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        );
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    struct DecreaseLiquidityParams {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }
    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }
    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }
    struct IncreaseLiquidityParams {
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    function increaseLiquidity(
        IncreaseLiquidityParams calldata params
    ) external payable returns (uint128 liquidity, uint256 amount0, uint256 amount1);
    function decreaseLiquidity(
        DecreaseLiquidityParams calldata params
    ) external payable returns (uint256 amount0, uint256 amount1);

    function mint(
        MintParams calldata params
    ) external returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
    function burn(uint256 tokenId) external;

    /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
    /// @param params tokenId The ID of the NFT for which tokens are being collected,
    /// recipient The account that should receive the tokens,
    /// amount0Max The maximum amount of token0 to collect,
    /// amount1Max The maximum amount of token1 to collect
    /// @return amount0 The amount of fees collected in token0
    /// @return amount1 The amount of fees collected in token1
    function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
}

interface IGNOME {
    function balanceOf(address) external view returns (uint256);
    function approve(address spender, uint value) external returns (bool);
    function enableTrading() external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function initialize(uint160 sqrtPriceX96) external;
    function getTokenId() external view returns (uint256);
    function factoryMint(address fren) external returns (uint256);
    function signUpReferral(string memory code, address sender, uint gnomeAmount) external;
    function signUp(uint256 _id, string memory _Xusr, uint256 baseEmotion) external;
    function setTreasuryMintTimeStamp(address gnome, uint256 timeStamp) external;
    function setGnomeEmotion(uint256 tokenId, uint256 _gnomeEmotion) external;
}

contract GnomesFactoryV2 is ReentrancyGuard {
    IMinimalNonfungiblePositionManager private positionManager;

    struct StakedPosition {
        uint256 tokenId;
        uint128 liquidity;
        uint256 stakedAt;
        uint256 lastRewardTime;
    }

    IUniswapV3Pool private pool;
    ISwapRouter private constant swapRouter = ISwapRouter(0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E);
    address private constant WETH_ADDRESS = 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14;
    address private POSITION_MANAGER_ADDRESS = 0x1238536071E1c677A632429e3655c799b22cDA52;
    mapping(address => bool) public isAuth;

    mapping(address => uint256) public gnomeReward;
    mapping(address => uint256) public gameReward;

    mapping(address => StakedPosition) public stakedPositions;
    address public GNOME_ADDRESS;
    address public GNOME_REFERRAL;
    address public GNOME_NFT_ADDRESS;
    address public GNOME_GAME_ADDRESS;
    address public GNOME_NFT_POOL;
    address public GNOME_POOL;
    int24 public tickSpacing = 200; // spacing of the gnome/ETH pool

    uint256 private SQRT_0005_PERCENT = 223606797784075547; //
    uint256 private SQRT_2000_PERCENT = 4472135955099137979; //
    uint256 private positionIndex = 0; //
    mapping(uint256 => uint256) public positionByIndex;
    uint160 private sqrtPriceLimitX96 = type(uint160).max;
    uint256 public treasuryDiscount = 86;
    uint256 public referralDiscount = 66;
    bool private printerBrrr = false;
    bool private mintOpened = false;
    bool private mintReferral = false;
    bool private communityOwned = false;
    uint256[] public stakedTokenIds;
    address public owner;
    uint32 _twapInterval = 0;
    bool canWithdraw = false;
    bool nftPoolWeth = true;
    int24 MinTick = -887200; // Replace with actual min tick for the pool
    int24 MaxTick = 887200; // Replace with actual max tick for the pool
    uint128 public totalStakedLiquidity;
    uint256 public dailyRewardAmount = 1 * 10 ** 18; // Daily reward amount in gnome tokens
    uint256 private initRewardTime;
    uint256 private mul = 1;
    uint256 private div = 100000;
    uint256 private treasuryDelay = 5 minutes; //CHANGE THIS
    event GnomeMinted(address indexed from, string gnomeName, uint256 tokenId, uint256 gomePrice);

    constructor(address gnomeNFT, address gnome, address gnomeReferral, address gnomeGame) {
        owner = msg.sender;
        isAuth[owner] = true;
        isAuth[address(this)] = true;
        GNOME_ADDRESS = gnome;
        GNOME_NFT_ADDRESS = gnomeNFT;
        GNOME_REFERRAL = gnomeReferral;
        GNOME_GAME_ADDRESS = gnomeGame;

        positionManager = IMinimalNonfungiblePositionManager(POSITION_MANAGER_ADDRESS); //
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the authorized");
        _;
    }
    // Modifier to restrict access to owner only
    modifier onlyAuth() {
        require(msg.sender == owner || isAuth[msg.sender], "Caller is not the authorized");
        _;
    }

    function setSqrtPriceLimitX96(uint160 _sqrtPriceLimitX96) external onlyAuth {
        sqrtPriceLimitX96 = _sqrtPriceLimitX96;
    }

    function setMulDiv(uint256 _mul, uint256 _div, bool _nftPoolWeth) external onlyAuth {
        mul = _mul;
        div = _div;
        nftPoolWeth = _nftPoolWeth;
    }

    function setIsCommunityOwned(bool _communityOwned) external onlyAuth {
        communityOwned = _communityOwned;
    }

    function openMint(bool _mintOpened) external onlyAuth {
        mintOpened = _mintOpened;
    }

    function openReferral(bool _mintOpened) external onlyAuth {
        mintReferral = _mintOpened;
    }

    function setIsCommunityWithdraw(bool _canWithdraw) external onlyAuth {
        canWithdraw = _canWithdraw;
    }

    function setIsAuth(address fren, bool isAuthorized) external onlyAuth {
        isAuth[fren] = isAuthorized;
    }

    function setPool741(address _gnomePool404) external onlyAuth {
        require(_gnomePool404 != address(0), "Invalid Pool address");

        GNOME_NFT_POOL = _gnomePool404;
    }

    function setMiContracts(
        address _gnome,
        address _gnomeNFT,
        address _gnomeReferral,
        address _gnomeGame
    ) external onlyAuth {
        require(_gnome != address(0), "Invalid GNOME address");
        require(_gnomeNFT != address(0), "Invalid GNOME NFT address");
        require(_gnomeReferral != address(0), "Invalid GNOME Referral address");
        require(_gnomeGame != address(0), "Invalid GNOME Game address");
        GNOME_ADDRESS = _gnome;
        GNOME_NFT_ADDRESS = _gnomeNFT;
        GNOME_REFERRAL = _gnomeReferral;
        GNOME_GAME_ADDRESS = _gnomeGame;
    }

    function setPool(address _pool) public onlyAuth {
        GNOME_POOL = _pool;
        pool = IUniswapV3Pool(_pool);
    }

    function initRewards() public onlyAuth {
        initRewardTime = block.timestamp;
        printerBrrr = true;
    }

    function getPositionValue(
        uint256 tokenId
    ) public view returns (uint128 liquidity, address token0, address token1, int24 tickLower, int24 tickUpper) {
        (
            ,
            ,
            // nonce
            // operator
            address _token0, // token0
            address _token1, // token1 // fee
            ,
            int24 _tickLower, // tickLower
            int24 _tickUpper, // tickUpper
            uint128 _liquidity, // liquidity // feeGrowthInside0LastX128 // feeGrowthInside1LastX128 // tokensOwed0 // tokensOwed1
            ,
            ,
            ,

        ) = positionManager.positions(tokenId);

        return (_liquidity, _token0, _token1, _tickLower, _tickUpper);
    }

    function setDailyRewardAmount(uint256 _amount) external onlyOwner {
        dailyRewardAmount = _amount;
    }

    function pendingInflactionaryRewards(address user) public view returns (uint256 rewards) {
        StakedPosition memory position = stakedPositions[user];

        if (position.liquidity == 0 || calculateSumOfLiquidity() == 0 || !printerBrrr) {
            return 0;
        }
        uint128 userLiq = position.liquidity;
        uint128 totalLiq = calculateSumOfLiquidity();
        uint256 _timeElapsed;
        if (position.lastRewardTime < initRewardTime) {
            _timeElapsed = block.timestamp - initRewardTime;
        } else {
            _timeElapsed = block.timestamp - position.lastRewardTime;
        }

        uint128 userShare = div64x64(userLiq, totalLiq);

        rewards = gameReward[user] + (dailyRewardAmount * _timeElapsed * userShare) / 1e18;
    }

    function pendingRewards(address user) public view returns (uint256 rewards) {
        rewards = gnomeReward[user];
    }

    function div64x64(uint128 x, uint128 y) internal pure returns (uint128) {
        unchecked {
            require(y != 0);

            uint256 answer = (uint256(x) << 64) / y;

            require(answer <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
            return uint128(answer);
        }
    }

    function claimRewards() public nonReentrant {
        StakedPosition storage position = stakedPositions[msg.sender];
        // require(isGnomeInRange(msg.sender, false), "Rebalance your Gnome");
        require(communityOwned, "Gnomes not ready yet");

        // Add pending inflationary rewards to rewards
        uint256 rewards = gnomeReward[msg.sender];

        require(rewards > 0, "No rewards available");

        // Set gnomeReward[msg.sender] to zero
        gnomeReward[msg.sender] = 0;

        position.lastRewardTime = block.timestamp; // Update the last reward time

        // Transfer gnome tokens to the user
        // Ensure that the contract has enough gnome tokens and is authorized to distribute them
        require(IGNOME(GNOME_ADDRESS).balanceOf(address(this)) >= rewards, "No more $gnome to give");

        IGNOME(GNOME_ADDRESS).transfer(msg.sender, rewards);

        // Emit an event if necessary
        // emit RewardsClaimed(msg.sender, rewards);
    }

    function useGameRewards(address fren, address to, uint256 itemPrice) public onlyAuth nonReentrant {
        StakedPosition storage position = stakedPositions[fren];

        // Add pending inflationary rewards to rewards
        require(itemPrice < pendingInflactionaryRewards(fren), "You dont have enough rewards for this item");
        uint256 rewards = pendingInflactionaryRewards(fren) - itemPrice;
        gameReward[fren] = rewards;

        require(rewards > 0, "No rewards available");

        // Set gnomeReward[msg.sender] to zero

        position.lastRewardTime = block.timestamp; // Update the last reward time

        // Transfer gnome tokens to the user
        // Ensure that the contract has enough gnome tokens and is authorized to distribute them
        require(IGNOME(GNOME_ADDRESS).balanceOf(address(this)) >= rewards, "No more $gnome to give");

        IGNOME(GNOME_ADDRESS).transfer(to, rewards);

        // Emit an event if necessary
        // emit RewardsClaimed(msg.sender, rewards);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function collectAllFees() external returns (uint256 totalAmount0, uint256 totalAmount1) {
        uint256 amount0;
        uint256 amount1;

        for (uint i = 0; i < stakedTokenIds.length; i++) {
            IMinimalNonfungiblePositionManager.CollectParams memory params = IMinimalNonfungiblePositionManager
                .CollectParams({
                    tokenId: stakedTokenIds[i],
                    recipient: address(this),
                    amount0Max: type(uint128).max,
                    amount1Max: type(uint128).max
                });

            (amount0, amount1) = positionManager.collect(params);
            totalAmount0 += amount0;
            totalAmount1 += amount1;
        }
    }

    function frensFundus() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function setDiscounts(uint256 _treasuryDiscount, uint256 _referralDiscount) external onlyAuth {
        treasuryDiscount = _treasuryDiscount;
        referralDiscount = _referralDiscount;
    }

    function somethingAboutTokens(address token) external onlyOwner {
        uint256 balance = IGNOME(token).balanceOf(address(this));
        IGNOME(token).transfer(msg.sender, balance);
    }

    function swapWETH(uint value) public payable returns (uint amountOut) {
        // Approve the router to spend WETH
        IWETH(WETH_ADDRESS).approve(address(swapRouter), value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH_ADDRESS,
            tokenOut: GNOME_ADDRESS,
            fee: 10000, // Assuming a 0.1% pool fee
            recipient: address(this),
            amountIn: value,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapETH_Half(uint value, bool isWETH) public payable returns (uint amountGnome, uint amountWeth) {
        if (!isWETH) {
            // Wrap ETH to WETH
            IWETH(WETH_ADDRESS).deposit{value: msg.value}();
            assert(IWETH(WETH_ADDRESS).transfer(address(this), value));
        }

        uint amountToSwap = msg.value / 2;

        // Approve the router to spend WETH
        IWETH(WETH_ADDRESS).approve(address(swapRouter), msg.value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH_ADDRESS,
            tokenOut: GNOME_ADDRESS,
            fee: 10000, // Assuming a 0.1% pool fee
            recipient: address(this),
            amountIn: amountToSwap,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountGnome = swapRouter.exactInputSingle(params);
    }

    function mintGnome(
        string memory userX,
        uint256 baseEmotion
    )
        public
        payable
        returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1)
    {
        uint256 gnomePrice = getGnomeNFTPrice();
        require(msg.value >= gnomePrice, "Not Enough to mint Gnome");
        if (!isAuth[msg.sender]) {
            require(mintOpened, "Minting Not Opened to Public");
        }
        uint256 excessAmount = msg.value - gnomePrice;

        // uint numberOfGnomes = msg.value / (getGnomeNFTPrice()); // 1 Gnome costs 0.0333 ETH
        uint amountWETHBefore = IWETH(WETH_ADDRESS).balanceOf(address(this));
        (uint amountGnome, uint amountWeth) = swapETH_Half(msg.value, false);
        uint amountWETHAfter = IWETH(WETH_ADDRESS).balanceOf(address(this));
        uint amountWETH = amountWETHAfter - amountWETHBefore;

        // For this example, we will provide equal amounts of liquidity in both assets.
        // Providing liquidity in both assets means liquidity will be earning fees and is considered in-range.
        uint amount0ToMint = amountGnome;
        uint amount1ToMint = amountWETH;

        // Approve the position manager
        TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount0ToMint);
        TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount1ToMint);
        //  for (uint i = 0; i < numberOfGnomes; i++) {
        uint256 id = IGNOME(GNOME_NFT_ADDRESS).factoryMint(msg.sender);
        IGNOME(GNOME_GAME_ADDRESS).signUp(id, userX, baseEmotion);

        // }
        IGNOME(GNOME_NFT_ADDRESS).setTreasuryMintTimeStamp(msg.sender, block.timestamp + treasuryDelay);
        emit GnomeMinted(msg.sender, userX, id, gnomePrice);
        if (isGnomeInRange(msg.sender, true)) {
            return increasePosition(msg.sender, amountGnome, amountWETH);
        } else {
            return mintPosition(msg.sender, msg.sender, amountGnome, amountWETH);
        }
    }

    function mintGnomeReferral(
        string memory code,
        string memory userX,
        uint256 baseEmotion
    )
        public
        payable
        returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1)
    {
        uint256 gnomePrice = getGnomeNFTPriceReferral();
        if (!isAuth[msg.sender]) {
            require(mintOpened, "Minting Not Opened to Public");
        }
        require(msg.value >= gnomePrice, "Not Enough to mint Gnome");
        if (!isAuth[msg.sender]) {
            require(mintReferral, "Minting Not Opened to Referrals");
        }
        // uint numberOfGnomes = msg.value / getGnomeNFTPriceReferral(); // 1 Gnome costs 0.0111 ETH

        IGNOME(GNOME_REFERRAL).signUpReferral(code, msg.sender, baseEmotion);
        uint amountWETHBefore = IWETH(WETH_ADDRESS).balanceOf(address(this));
        (uint amountGnome, uint amountWeth) = swapETH_Half(msg.value, false);
        uint amountWETHAfter = IWETH(WETH_ADDRESS).balanceOf(address(this));
        uint amountWETH = amountWETHAfter - amountWETHBefore;

        // For this example, we will provide equal amounts of liquidity in both assets.
        // Providing liquidity in both assets means liquidity will be earning fees and is considered in-range.
        uint amount0ToMint = amountGnome;
        uint amount1ToMint = amountWETH;

        // Approve the position manager
        TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount0ToMint);
        TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount1ToMint);
        // for (uint i = 0; i < numberOfGnomes; i++) {
        uint256 id = IGNOME(GNOME_NFT_ADDRESS).factoryMint(msg.sender);
        IGNOME(GNOME_GAME_ADDRESS).signUp(id, userX, baseEmotion);

        //  }
        IGNOME(GNOME_NFT_ADDRESS).setTreasuryMintTimeStamp(msg.sender, block.timestamp + treasuryDelay);
        emit GnomeMinted(msg.sender, userX, id, gnomePrice);
        if (isGnomeInRange(msg.sender, true)) {
            return increasePosition(msg.sender, amountGnome, amountWETH);
        } else {
            return mintPosition(msg.sender, msg.sender, amountGnome, amountWETH);
        }
    }

    function withdrawOutOfRangePositionAuth(uint256 tokenId) public nonReentrant onlyAuth {
        (uint128 liquidity, , , , ) = getPositionValue(tokenId);
        // Transfer the NFT back to the user
        positionManager.safeTransferFrom(address(this), msg.sender, tokenId, "");

        totalStakedLiquidity -= liquidity;
        // Clear the staked position data
        // Remove the tokenId from the stakedTokenIds array
        for (uint i = 0; i < stakedTokenIds.length; i++) {
            if (stakedTokenIds[i] == tokenId) {
                stakedTokenIds[i] = stakedTokenIds[stakedTokenIds.length - 1];
                stakedTokenIds.pop();
                break;
            }
        }

        removeTokenIdFromArray(tokenId);
    }

    function getTwapX96(address uniswapV3Pool, uint32 twapInterval, bool _isNFT) public view returns (uint256 price) {
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
            price = (_isNFT) ? (amount1 * mul) / (amount0 * div) : (amount1 * 10 ** 18) / (amount0 * div);
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

            price = (_isNFT) ? (amount1 * mul) / (amount0 * div) : (amount1 * 10 ** 18) / (amount0 * div);
        }
    }

    function getGnomeNFTPrice() public view returns (uint256 priceGnome) {
        if (nftPoolWeth) {
            priceGnome = (getTwapX96(GNOME_NFT_POOL, _twapInterval, true) * treasuryDiscount) / 100;
        } else {
            priceGnome =
                (getTwapX96(GNOME_POOL, _twapInterval, false) *
                    getTwapX96(GNOME_NFT_POOL, _twapInterval, true) *
                    treasuryDiscount) /
                100;
        }

        return priceGnome;
    }

    function getGnomeNFTPriceReferral() public view returns (uint256 priceGnome) {
        if (nftPoolWeth) {
            priceGnome = (getTwapX96(GNOME_NFT_POOL, _twapInterval, true) * referralDiscount) / 100;
        } else {
            priceGnome =
                (getTwapX96(GNOME_POOL, _twapInterval, false) *
                    getTwapX96(GNOME_NFT_POOL, _twapInterval, true) *
                    referralDiscount) /
                100;
        }

        return priceGnome;
    }

    function isGnomeInRange(address fren, bool isFactory) public view returns (bool) {
        int24 tick = getCurrentTick();

        StakedPosition memory frenposition = stakedPositions[fren];
        uint256 position;
        if (isFactory) {
            position = positionByIndex[positionIndex];
            if (position == 0) return false;
        } else {
            position = frenposition.tokenId;
        }
        (, , , int24 minTick, int24 maxTick) = getPositionValue(position);

        if (minTick < tick && tick < maxTick) {
            return true;
        } else {
            return false;
        }
    }

    function getCurrentTick() public view returns (int24) {
        (, int24 tick, , , , , ) = pool.slot0();
        return tick;
    }

    function swapGnome_Half(uint value) public payable returns (uint amountGnome, uint amountWeth) {
        uint amountToSwap = value / 2;

        // Approve the router to spend Gnome
        IGNOME(GNOME_ADDRESS).approve(address(swapRouter), value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: GNOME_ADDRESS,
            tokenOut: WETH_ADDRESS,
            fee: 10000, // Assuming a 0.3% pool fee
            recipient: address(this),
            amountIn: amountToSwap,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Perform the swap
        amountWeth = swapRouter.exactInputSingle(params);
    }

    function mintPosition(
        address fren,
        address rafundAddress,
        uint _amountGnome,
        uint _amountWETH
    ) internal returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund1, uint refund0) {
        uint256 _deadline = block.timestamp + 3360;
        (int24 lowerTick, int24 upperTick) = _getSpreadTicks();
        IMinimalNonfungiblePositionManager.MintParams memory params = IMinimalNonfungiblePositionManager.MintParams({
            token0: GNOME_ADDRESS,
            token1: WETH_ADDRESS,
            fee: 10000,
            // By using TickMath.MIN_TICK and TickMath.MAX_TICK,
            // we are providing liquidity across the whole range of the pool.
            // Not recommended in production.
            tickLower: lowerTick,
            tickUpper: upperTick,
            amount0Desired: _amountGnome,
            amount1Desired: _amountWETH,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: _deadline
        });

        // Note that the pool defined by gnome/WETH and fee tier 0.1% must
        // already be created and initialized in order to mint
        (_tokenId, liquidity, amount0, amount1) = positionManager.mint(params);

        stakedPositions[fren] = StakedPosition(_tokenId, liquidity, block.timestamp, block.timestamp);
        stakedTokenIds.push(_tokenId); // Add the token ID to the array
        positionIndex++;
        positionByIndex[positionIndex] = _tokenId;
        totalStakedLiquidity += liquidity;

        if (amount0 < _amountGnome) {
            refund0 = _amountGnome - amount0;
            //TransferHelper.safeTransfer(GNOME_ADDRESS, rafundAddress, refund0);
            gnomeReward[rafundAddress] += refund0;
        }

        if (amount1 < _amountWETH) {
            refund1 = _amountWETH - amount1;
            TransferHelper.safeTransfer(WETH_ADDRESS, rafundAddress, refund1);
            // uint256 amountGnome = swapWETH(refund1);
            //TransferHelper.safeTransfer(GNOME_ADDRESS, rafundAddress, amountGnome);
            //gnomeReward[rafundAddress] += amountGnome;
        }
    }

    function calculateSumOfLiquidity() public view returns (uint128) {
        uint128 totalLiq = 0;

        for (uint256 i = 0; i < stakedTokenIds.length; i++) {
            uint256 tokenId = stakedTokenIds[i];

            (uint128 liquidity, , , , ) = getPositionValue(tokenId);

            // Add up the liquidity
            totalLiq += liquidity;
        }

        return totalLiq;
    }

    function increasePosition(
        address fren,
        uint _amountGnome,
        uint _amountWETH
    ) internal returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1) {
        tokenId = positionByIndex[positionIndex];

        uint256 _deadline = block.timestamp + 100;
        IMinimalNonfungiblePositionManager.IncreaseLiquidityParams memory params = IMinimalNonfungiblePositionManager
            .IncreaseLiquidityParams({
                tokenId: tokenId,
                amount0Desired: _amountGnome,
                amount1Desired: _amountWETH,
                amount0Min: 0,
                amount1Min: 0,
                deadline: _deadline
            });

        (liquidity, amount0, amount1) = positionManager.increaseLiquidity(params);
        uint128 curr_liquidity = stakedPositions[fren].liquidity + liquidity;

        stakedPositions[fren] = StakedPosition(tokenId, curr_liquidity, block.timestamp, block.timestamp);

        totalStakedLiquidity += liquidity;

        if (amount0 < _amountGnome) {
            refund0 = _amountGnome - amount0;
            // TransferHelper.safeTransfer(GNOME_ADDRESS, fren, refund0);
            gnomeReward[fren] += refund0;
        }

        if (amount1 < _amountWETH) {
            refund1 = _amountWETH - amount1;
            TransferHelper.safeTransfer(WETH_ADDRESS, fren, refund1);
        }
    }

    function removeTokenIdFromArray(uint256 tokenId) internal {
        uint256 length = stakedTokenIds.length;
        for (uint256 i = 0; i < length; i++) {
            if (stakedTokenIds[i] == tokenId) {
                // Swap with the last element
                stakedTokenIds[i] = stakedTokenIds[length - 1];
                // Remove the last element
                stakedTokenIds.pop();
                break;
            }
        }
    }

    function _getStakedPositionID(address fren) public view returns (uint256 tokenId) {
        StakedPosition memory position = stakedPositions[fren];
        return position.tokenId;
    }

    function _getSpreadTicks() public view returns (int24 _lowerTick, int24 _upperTick) {
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        (uint160 sqrtRatioAX96, uint160 sqrtRatioBX96) = (
            uint160(FullMath.mulDiv(sqrtPriceX96, SQRT_0005_PERCENT, 1e18)),
            uint160(FullMath.mulDiv(sqrtPriceX96, SQRT_2000_PERCENT, 1e18))
        );

        _lowerTick = TickMath.getTickAtSqrtRatio(sqrtRatioAX96);
        _upperTick = TickMath.getTickAtSqrtRatio(sqrtRatioBX96);

        _lowerTick = _lowerTick % tickSpacing == 0
            ? _lowerTick // accept valid tickSpacing
            : _lowerTick > 0 // else, round up to closest valid tickSpacing
            ? (_lowerTick / tickSpacing + 1) * tickSpacing
            : (_lowerTick / tickSpacing) * tickSpacing;
        _upperTick = _upperTick % tickSpacing == 0
            ? _upperTick // accept valid tickSpacing
            : _upperTick > 0 // else, round down to closest valid tickSpacing
            ? (_upperTick / tickSpacing) * tickSpacing
            : (_upperTick / tickSpacing - 1) * tickSpacing;
    }

    function setTicks(int24 _minTick, int24 _maxTick, int24 _tickSpacing) public onlyOwner {
        MaxTick = _maxTick;
        MinTick = _minTick;
        tickSpacing = _tickSpacing;
    }

    function setTwap(uint32 twapInterval) public onlyOwner {
        _twapInterval = twapInterval;
    }

    function setDelay(uint256 _delay) public onlyOwner {
        treasuryDelay = _delay;
    }
}
