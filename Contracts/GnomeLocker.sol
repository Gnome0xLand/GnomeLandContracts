// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
pragma solidity ^0.8.0;

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

contract GnomeLockerV3 {
    address public uniswapV3NFTManager; // Uniswap V3 NFT Position Manager address
    IERC721 public nftToken; // NFT token representing the Uniswap V3 liquidity position

    struct LockedNFT {
        uint256 tokenId;
        uint256 lockTimestamp;
    }

    mapping(address => LockedNFT) public lockedNFTs;

    uint256 public constant lockDuration = 72 days; // 72 days lock duration
    address public owner;

    event NFTLocked(address indexed locker, uint256 tokenId, uint256 lockTimestamp);
    event NFTUnlocked(address indexed unlocker, uint256 tokenId);
    event FeesClaimed(address indexed claimer, uint fee1, uint fee2);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the authorized");
        _;
    }

    constructor(address _uniswapV3NFTManager) {
        uniswapV3NFTManager = _uniswapV3NFTManager;
        nftToken = IERC721(_uniswapV3NFTManager);
        owner = msg.sender;
    }

    function lockNFT(uint256 tokenId) external onlyOwner {
        require(nftToken.ownerOf(tokenId) == address(this), "NFT not owned by locker");

        IERC721(uniswapV3NFTManager).transferFrom(address(this), address(this), tokenId);

        uint256 lockTimestamp = block.timestamp;
        lockedNFTs[msg.sender] = LockedNFT(tokenId, lockTimestamp);

        emit NFTLocked(msg.sender, tokenId, lockTimestamp);
    }

    function unlockNFT() external onlyOwner {
        LockedNFT storage lockedNFT = lockedNFTs[msg.sender];
        require(lockedNFT.tokenId != 0, "No locked NFT found");
        require(block.timestamp >= lockedNFT.lockTimestamp + lockDuration, "Lock duration not elapsed");

        nftToken.transferFrom(address(this), msg.sender, lockedNFT.tokenId);

        emit NFTUnlocked(msg.sender, lockedNFT.tokenId);

        delete lockedNFTs[msg.sender];
    }

    function claimFees() external onlyOwner {
        IMinimalNonfungiblePositionManager.CollectParams memory params = IMinimalNonfungiblePositionManager
            .CollectParams({
                tokenId: lockedNFTs[msg.sender].tokenId,
                recipient: owner,
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });
        uint amount0;
        uint amount1;
        (amount0, amount1) = IMinimalNonfungiblePositionManager(uniswapV3NFTManager).collect(params);

        emit FeesClaimed(msg.sender, amount0, amount1);
    }
}
