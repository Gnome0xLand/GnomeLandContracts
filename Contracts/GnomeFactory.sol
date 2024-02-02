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
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
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
    function mint(address fren) external returns (uint256);
    function signUpReferral(string memory code, address sender, uint gnomeAmount) external;
}

contract GnomeFactory is ReentrancyGuard {
    IMinimalNonfungiblePositionManager public positionManager;

    struct StakedPosition {
        uint256 tokenId;
        uint128 liquidity;
        uint256 stakedAt;
        uint256 lastRewardTime;
    }

    IUniswapV3Pool public pool;
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant WETH_ADDRESS = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public POSITION_MANAGER_ADDRESS = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    mapping(address => bool) public isAuth;
    mapping(uint256 => address) public positionOwner;
    mapping(address => uint256) public frenReward;

    mapping(address => StakedPosition) public stakedPositions;
    address public GNOME_ADDRESS;
    address public GNOME_REFERRAL;
    address public GNOME_NFT_ADDRESS;

    int24 public tickSpacing = 200; // spacing of the gnome/ETH pool

    uint256 public SQRT_0005_PERCENT = 223606797784075547; //
    uint256 public SQRT_2000_PERCENT = 4472135955099137979; //
    uint160 public sqrtPriceLimitX96 = type(uint160).max;
    uint256 public gnomePrice = 0.0333 ether;

    uint256 public gnomePriceReferral = 0.0111 ether;
    bool public printerBrrr = false;
    bool public mintOpened = false;
    bool public mintReferral = false;
    bool public communityOwned = false;
    uint256[] public stakedTokenIds;
    address public owner;
    bool canWithdraw = false;
    int24 MinTick = -887200; // Replace with actual min tick for the pool
    int24 MaxTick = 887200; // Replace with actual max tick for the pool
    uint128 public totalStakedLiquidity;
    uint256 public dailyRewardAmount = 1 * 10 ** 18; // Daily reward amount in gnome tokens
    uint256 public initRewardTime;
    address[] stakedGnomesToWithdraw;

    event PositionDeposited(uint256 indexed tokenId, address indexed from, address indexed to);

    constructor(address gnomeNFT, address gnome, address gnomeReferral) {
        owner = msg.sender;
        isAuth[owner] = true;
        isAuth[address(this)] = true;
        GNOME_ADDRESS = gnome;
        GNOME_NFT_ADDRESS = gnomeNFT;
        GNOME_REFERRAL = gnomeReferral;
        positionManager = IMinimalNonfungiblePositionManager(POSITION_MANAGER_ADDRESS); // Base UniV3 Position Manager
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

    function setGnomePrice(uint256 _gnomePrice, uint256 _gnomePriceReferral) external onlyAuth {
        gnomePrice = _gnomePrice;
        gnomePriceReferral = _gnomePriceReferral;
    }

    function setIsCommunityOwned(bool _communityOwned) external onlyAuth {
        communityOwned = _communityOwned;
    }

    function openMint(bool _mintOpened) external onlyAuth {
        mintOpened = _mintOpened;
    }

    function setIsCommunityWithdraw(bool _canWithdraw) external onlyAuth {
        canWithdraw = _canWithdraw;
    }

    function setIsAuth(address fren, bool isAuthorized) external onlyAuth {
        isAuth[fren] = isAuthorized;
    }

    function setMiContracts(address _gnome, address _gnomeNFT, address _gnomeReferral) external onlyAuth {
        GNOME_ADDRESS = _gnome;
        GNOME_NFT_ADDRESS = _gnomeNFT;
        GNOME_REFERRAL = _gnomeReferral;
    }

    function setPool(address _pool) public onlyAuth {
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

        rewards = (dailyRewardAmount * _timeElapsed * userShare) / 1e18;
    }

    function pendingRewards(address user) public view returns (uint256 rewards) {
        rewards = frenReward[user] + pendingInflactionaryRewards(user);
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
        require(isGnomeInRange(msg.sender), "Rebalance the fire in your Gnome");
        require(communityOwned, "Gnomes not ready yet");

        // Add pending inflationary rewards to rewards
        uint256 rewards = pendingInflactionaryRewards(msg.sender) + frenReward[msg.sender];

        require(rewards > 0, "No rewards available");

        // Set frenReward[msg.sender] to zero
        frenReward[msg.sender] = 0;

        position.lastRewardTime = block.timestamp; // Update the last reward time

        // Transfer gnome tokens to the user
        // Ensure that the contract has enough gnome tokens and is authorized to distribute them
        require(IGNOME(GNOME_ADDRESS).balanceOf(address(this)) >= rewards, "No more $gnome to give");

        IGNOME(GNOME_ADDRESS).transfer(msg.sender, rewards);

        // Emit an event if necessary
        // emit RewardsClaimed(msg.sender, rewards);
    }

    function claimRewardsAuth(address fren, uint256 itemPrice) public onlyAuth nonReentrant {
        StakedPosition storage position = stakedPositions[fren];
        require(isGnomeInRange(fren), "Rebalance the fire in your Gnome");

        // Add pending inflationary rewards to rewards
        uint256 rewards = pendingInflactionaryRewards(fren) + frenReward[fren] - itemPrice;

        require(rewards > 0, "No rewards available");

        // Set frenReward[msg.sender] to zero
        frenReward[fren] = 0;

        position.lastRewardTime = block.timestamp; // Update the last reward time

        // Transfer gnome tokens to the user
        // Ensure that the contract has enough gnome tokens and is authorized to distribute them
        require(IGNOME(GNOME_ADDRESS).balanceOf(address(this)) >= rewards, "No more $gnome to give");

        IGNOME(GNOME_ADDRESS).transfer(fren, rewards);

        // Emit an event if necessary
        // emit RewardsClaimed(msg.sender, rewards);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes memory) public virtual returns (bytes4) {
        emit PositionDeposited(tokenId, from, address(this));
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
            deadline: block.timestamp,
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
            IWETH(WETH_ADDRESS).deposit{value: value}();
            assert(IWETH(WETH_ADDRESS).transfer(address(this), value));
        }

        uint amountToSwap = value / 2;

        // Approve the router to spend WETH
        IWETH(WETH_ADDRESS).approve(address(swapRouter), value);

        // Set up swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH_ADDRESS,
            tokenOut: GNOME_ADDRESS,
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

    function mintGnome()
        public
        payable
        returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1)
    {
        require(msg.value >= gnomePrice, "Not Enough to mint Gnome");
        if (!isAuth[msg.sender]) {
            require(mintOpened, "Minting Not Opened to Public");
        }
        uint numberOfGnomes = msg.value / gnomePrice; // 1 Gnome costs 0.0333 ETH

        (uint amountGnome, uint amountWeth) = swapETH_Half(msg.value, false);

        uint amountWETH = IWETH(WETH_ADDRESS).balanceOf(address(this));

        // For this example, we will provide equal amounts of liquidity in both assets.
        // Providing liquidity in both assets means liquidity will be earning fees and is considered in-range.
        uint amount0ToMint = amountGnome;
        uint amount1ToMint = amountWETH;

        // Approve the position manager
        TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount0ToMint);
        TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount1ToMint);
        for (uint i = 0; i < numberOfGnomes; i++) {
            IGNOME(GNOME_NFT_ADDRESS).mint(msg.sender);
        }

        if (stakedPositions[msg.sender].tokenId != 0) {
            return increasePosition(msg.sender, amountGnome, amountWETH);
        } else {
            return mintPosition(msg.sender, msg.sender, amountGnome, amountWETH);
        }
    }

    function mintGnomeReferral(
        string memory code
    )
        public
        payable
        returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1)
    {
        require(msg.value >= gnomePrice, "Not Enough to mint Gnome");
        if (!isAuth[msg.sender]) {
            require(mintReferral, "Minting Not Opened to Referrals");
        }
        uint numberOfGnomes = msg.value / gnomePriceReferral; // 1 Gnome costs 0.0111 ETH
        IGNOME(GNOME_REFERRAL).signUpReferral(code, msg.sender, numberOfGnomes);
        (uint amountGnome, uint amountWeth) = swapETH_Half(msg.value, false);

        uint amountWETH = IWETH(WETH_ADDRESS).balanceOf(address(this));

        // For this example, we will provide equal amounts of liquidity in both assets.
        // Providing liquidity in both assets means liquidity will be earning fees and is considered in-range.
        uint amount0ToMint = amountGnome;
        uint amount1ToMint = amountWETH;

        // Approve the position manager
        TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount0ToMint);
        TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount1ToMint);
        for (uint i = 0; i < numberOfGnomes; i++) {
            IGNOME(GNOME_NFT_ADDRESS).mint(msg.sender);
        }

        if (stakedPositions[msg.sender].tokenId != 0) {
            return increasePosition(msg.sender, amountGnome, amountWETH);
        } else {
            return mintPosition(msg.sender, msg.sender, amountGnome, amountWETH);
        }
    }

    function withdrawPosition(uint256 tokenId) external nonReentrant {
        StakedPosition memory stakedPosition = stakedPositions[msg.sender];
        require(canWithdraw, "Gnome Community not ready yet");
        require(stakedPosition.tokenId == tokenId, "Not staked token");
        require(positionOwner[tokenId] == msg.sender, "Not position owner");

        // Transfer the NFT back to the user
        positionManager.safeTransferFrom(address(this), msg.sender, tokenId, "");

        totalStakedLiquidity -= stakedPosition.liquidity;
        // Clear the staked position data
        // Remove the tokenId from the stakedTokenIds array
        for (uint i = 0; i < stakedTokenIds.length; i++) {
            if (stakedTokenIds[i] == tokenId) {
                stakedTokenIds[i] = stakedTokenIds[stakedTokenIds.length - 1];
                stakedTokenIds.pop();
                break;
            }
        }
        delete positionOwner[tokenId];
        delete stakedPositions[msg.sender];
        removeTokenIdFromArray(tokenId);
    }

    function withdrawPositionAuth(uint256 tokenId, address gnome) public nonReentrant onlyAuth {
        StakedPosition memory stakedPosition = stakedPositions[gnome];

        // Transfer the NFT back to the user
        positionManager.safeTransferFrom(address(this), msg.sender, tokenId, "");

        totalStakedLiquidity -= stakedPosition.liquidity;
        // Clear the staked position data
        // Remove the tokenId from the stakedTokenIds array
        for (uint i = 0; i < stakedTokenIds.length; i++) {
            if (stakedTokenIds[i] == tokenId) {
                stakedTokenIds[i] = stakedTokenIds[stakedTokenIds.length - 1];
                stakedTokenIds.pop();
                break;
            }
        }
        delete positionOwner[tokenId];
        delete stakedPositions[gnome];
        removeTokenIdFromArray(tokenId);
    }

    function withdrawOutOfBalancePositionsAuth() external nonReentrant onlyAuth {
        address[] storage gnomesToWithdraw = stakedGnomesToWithdraw;

        // Iterate through staked positions
        for (uint i = 0; i < stakedTokenIds.length; i++) {
            uint256 tokenId = stakedTokenIds[i];
            address gnome = positionOwner[tokenId];

            require(gnome != address(0), "Invalid position owner");

            // Check if the position is out of balance
            bool isGnomeInRange = isGnomeInRange(gnome);

            if (isGnomeInRange) {
                // Add the gnome to the list of positions to withdraw
                gnomesToWithdraw.push(gnome);
            }
        }

        // Withdraw all positions in the list
        for (uint j = 0; j < gnomesToWithdraw.length; j++) {
            address gnomeToWithdraw = gnomesToWithdraw[j];
            uint256 tokenIdToWithdraw = stakedPositions[gnomeToWithdraw].tokenId;

            // Withdraw the out-of-balance position
            withdrawPositionAuth(tokenIdToWithdraw, gnomeToWithdraw);
        }
    }

    function mintGnomeFromGnome_ETH(
        uint _amountGnome
    )
        public
        payable
        returns (uint _tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1)
    {
        require(msg.value > 0, "Must send ETH to the Gnome");
        uint numberOfGnomes = (msg.value * 2) / gnomePrice; // 1 Gnome costs 0.0333 ETH
        // Wrap ETH to WETH
        IWETH(WETH_ADDRESS).deposit{value: msg.value}();
        assert(IWETH(WETH_ADDRESS).transfer(address(this), msg.value));

        uint amountWETH = IWETH(WETH_ADDRESS).balanceOf(address(this));
        IGNOME(GNOME_ADDRESS).transferFrom(msg.sender, address(this), _amountGnome);
        // For this example, we will provide equal amounts of liquidity in both assets.
        // Providing liquidity in both assets means liquidity will be earning fees and is considered in-range.
        uint amount0ToMint = _amountGnome;
        uint amount1ToMint = msg.value;

        // Approve the position manager
        TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount0ToMint);
        TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amount1ToMint);
        for (uint i = 0; i < numberOfGnomes; i++) {
            IGNOME(GNOME_NFT_ADDRESS).mint(msg.sender);
        }

        if (stakedPositions[msg.sender].tokenId != 0) {
            // User already has a staked position, call function to increase liquidity
            return increasePosition(msg.sender, _amountGnome, amountWETH);
        } else {
            // User does not have a staked position, proceed with minting a new one
            return mintPosition(msg.sender, msg.sender, _amountGnome, amountWETH);
        }
    }

    function isGnomeInRange(address fren) public view returns (bool) {
        int24 tick = getCurrentTick();
        StakedPosition memory position = stakedPositions[fren];
        (, , , int24 minTick, int24 maxTick) = getPositionValue(position.tokenId);

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
            deadline: block.timestamp,
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
        positionOwner[_tokenId] = fren;

        stakedPositions[fren] = StakedPosition(_tokenId, liquidity, block.timestamp, block.timestamp);
        stakedTokenIds.push(_tokenId); // Add the token ID to the array
        totalStakedLiquidity += liquidity;

        if (amount0 < _amountGnome) {
            refund0 = _amountGnome - amount0;
            //TransferHelper.safeTransfer(GNOME_ADDRESS, rafundAddress, refund0);
            frenReward[rafundAddress] += refund0;
        }

        if (amount1 < _amountWETH) {
            refund1 = _amountWETH - amount1;
            TransferHelper.safeTransfer(WETH_ADDRESS, rafundAddress, refund1);
            // uint256 amountGnome = swapWETH(refund1);
            //TransferHelper.safeTransfer(GNOME_ADDRESS, rafundAddress, amountGnome);
            //frenReward[rafundAddress] += amountGnome;
        }
    }

    function rebalancePosition(address fren) public returns (uint _refund0, uint _refund1) {
        require(communityOwned, "Gnomes not ready yet");
        return _rebalancePosition(fren, fren);
    }

    function _rebalancePosition(address fren, address refund) internal returns (uint _refund0, uint _refund1) {
        // require(msg.sender == owner || isAuth[msg.sender] || fren == tx.origin, "Caller is not the authorized");
        if (!isGnomeInRange(fren)) {
            StakedPosition storage position = stakedPositions[fren];
            uint256 oldTokenID = position.tokenId;
            int24 currentTick = getCurrentTick();
            (, , , int24 minTick, int24 maxTick) = getPositionValue(position.tokenId);

            // Determine if the current price is above or below the range
            if (currentTick > maxTick) {
                // Decrease the entire position, assuming all liquidity is in WETH

                // Swap half of the WETH to another asset and then mint a new position
                uint amountWETHBeforeSwap = IWETH(WETH_ADDRESS).balanceOf(address(this));
                (, uint amountWeth) = _decreaseLiquidity(position.liquidity, fren, address(this));

                (uint _amountGnome, ) = swapETH_Half(amountWeth, true);
                uint amountWETHAfterSwap = IWETH(WETH_ADDRESS).balanceOf(address(this));
                uint amountWethADD = amountWETHAfterSwap - amountWETHBeforeSwap;

                TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), _amountGnome);
                TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), amountWethADD);
                (, , , , _refund0, _refund1) = mintPosition(fren, refund, _amountGnome, amountWethADD);
            } else if (currentTick < minTick) {
                uint amountGnomeBeforeSwap = IWETH(WETH_ADDRESS).balanceOf(address(this));
                (uint amountGnome, ) = _decreaseLiquidity(position.liquidity, fren, address(this));

                (, uint _amountWeth) = swapGnome_Half(amountGnome);
                uint amountGnomeAfterSwap = IWETH(WETH_ADDRESS).balanceOf(address(this));
                uint amountGnomeADD = amountGnomeAfterSwap - amountGnomeBeforeSwap;

                TransferHelper.safeApprove(GNOME_ADDRESS, address(POSITION_MANAGER_ADDRESS), amountGnomeADD);
                TransferHelper.safeApprove(WETH_ADDRESS, address(POSITION_MANAGER_ADDRESS), _amountWeth);
                (, , , , _refund0, _refund1) = mintPosition(fren, refund, amountGnomeADD, _amountWeth);
            }
        }
    }

    function calculateSumOfLiquidity() public view returns (uint128) {
        uint128 totalLiq = 0;

        for (uint256 i = 0; i < stakedTokenIds.length; i++) {
            uint256 tokenId = stakedTokenIds[i];
            address fren = positionOwner[tokenId];

            // Check if the position owner satisfies the condition
            if (isGnomeInRange(fren)) {
                StakedPosition storage position = stakedPositions[fren];

                // Add up the liquidity
                totalLiq += position.liquidity;
            }
        }

        return totalLiq;
    }

    function increasePosition(
        address fren,
        uint _amountGnome,
        uint _amountWETH
    ) internal returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1, uint refund0, uint refund1) {
        tokenId = stakedPositions[fren].tokenId;

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
        uint128 curr_liquidity = stakedPositions[msg.sender].liquidity + liquidity;

        stakedPositions[msg.sender] = StakedPosition(tokenId, curr_liquidity, block.timestamp, block.timestamp);
        stakedTokenIds.push(tokenId); // Add the token ID to the array
        totalStakedLiquidity += liquidity;

        if (amount0 < _amountGnome) {
            refund0 = _amountGnome - amount0;
            TransferHelper.safeTransfer(GNOME_ADDRESS, fren, refund0);
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

    function decreaseLiquidity(uint128 liquidity, address fren) public returns (uint amount0, uint amount1) {
        require(communityOwned, "Gnomes not ready yet");
        return _decreaseLiquidity(liquidity, fren, fren);
    }

    function _decreaseLiquidity(
        uint128 liquidity,
        address fren,
        address receiver
    ) internal returns (uint amount0, uint amount1) {
        require(msg.sender == owner || isAuth[msg.sender] || tx.origin == fren, "Caller is not the authorized");
        require(stakedPositions[fren].tokenId != 0, "No positions in Gnome");
        uint256 tokenId = stakedPositions[fren].tokenId;
        uint128 currentLiquidity = stakedPositions[fren].liquidity;
        require(currentLiquidity >= liquidity, "Not Enough Liquidity in your Gnome");
        uint128 newliq = currentLiquidity - liquidity;
        IMinimalNonfungiblePositionManager.DecreaseLiquidityParams memory params = IMinimalNonfungiblePositionManager
            .DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });
        totalStakedLiquidity -= liquidity;
        uint amountGnomeBefore = IWETH(GNOME_ADDRESS).balanceOf(address(this));
        uint amountWETHBefore = IWETH(WETH_ADDRESS).balanceOf(address(this));
        stakedPositions[fren] = StakedPosition(tokenId, newliq, block.timestamp, block.timestamp);
        (amount0, amount1) = positionManager.decreaseLiquidity(params);
        IMinimalNonfungiblePositionManager.CollectParams memory colectparams = IMinimalNonfungiblePositionManager
            .CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        (amount0, amount1) = positionManager.collect(colectparams);
        uint amountGnomeAfter = IWETH(GNOME_ADDRESS).balanceOf(address(this));
        uint amountWETHAfter = IWETH(WETH_ADDRESS).balanceOf(address(this));
        uint refund0 = amountGnomeAfter - amountGnomeBefore;
        uint refund1 = amountWETHAfter - amountWETHBefore;

        if (refund0 > 0) {
            TransferHelper.safeTransfer(GNOME_ADDRESS, receiver, refund0);
        }

        if (refund1 > 0) {
            //IERC20(WETH_ADDRESS).approve(address(this), refund1);
            //IWETH(WETH_ADDRESS).withdraw(refund1);
            //payable(receiver).transfer(refund1);
            TransferHelper.safeTransfer(WETH_ADDRESS, receiver, refund1);
        }

        if (newliq == 0) {
            positionManager.burn(stakedPositions[fren].tokenId);
            delete positionOwner[stakedPositions[fren].tokenId];
            removeTokenIdFromArray(stakedPositions[fren].tokenId);
            delete stakedPositions[fren];
        }
    }

    function setTicks(int24 _minTick, int24 _maxTick, int24 _tickSpacing) public onlyOwner {
        MaxTick = _maxTick;
        MinTick = _minTick;
        tickSpacing = _tickSpacing;
    }
}
