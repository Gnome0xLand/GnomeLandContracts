// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GnomeWrapper {
    IERC20 public gnomeToken = IERC20(0x42069d11A2CC72388a2e06210921E839Cfbd3280);
    IERC20 public gnomeWhormHoleToken = IERC20(0xa29F2f60aA589B2dac72e72b7CFed51bfbA52862);

    uint256 public wrapFee = 100; // Fee for wrapping in basis points (1% = 100)
    uint256 public unwrapFee = 5000; // Fee for unwrapping in basis points (1% = 100)

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    event Wrap(address indexed account, uint256 amount, uint256 fee);
    event Unwrap(address indexed account, uint256 amount, uint256 fee);

    constructor() {
        owner = msg.sender;
    }

    function setGnomeToken(address _gnomeToken) external onlyOwner {
        gnomeToken = IERC20(_gnomeToken);
    }

    function setGnomeWhormHoleToken(address _gnomeWhormHoleToken) external onlyOwner {
        gnomeWhormHoleToken = IERC20(_gnomeWhormHoleToken);
    }

    function setWrapFee(uint256 _wrapFee) external onlyOwner {
        require(_wrapFee <= 10000, "Wrap fee must be less than or equal to 100%");
        wrapFee = _wrapFee;
    }

    function setUnwrapFee(uint256 _unwrapFee) external onlyOwner {
        require(_unwrapFee <= 10000, "Unwrap fee must be less than or equal to 100%");
        unwrapFee = _unwrapFee;
    }

    function wrap(uint256 amount) external {
        require(address(gnomeToken) != address(0), "GnomeToken address not set");
        require(address(gnomeWhormHoleToken) != address(0), "GnomeWhormHoleToken address not set");

        uint256 feeAmount = (amount * wrapFee) / 10000;
        uint256 transferAmount = amount - feeAmount;
        transferAmount *= 10 ** 9;
        require(gnomeToken.transferFrom(msg.sender, address(this), amount * 10 ** 18), "Transfer failed");
        gnomeWhormHoleToken.transfer(msg.sender, transferAmount);
        emit Wrap(msg.sender, amount, feeAmount);
    }

    function unwrap(uint256 amount) external {
        require(address(gnomeToken) != address(0), "GnomeToken address not set");
        require(address(gnomeWhormHoleToken) != address(0), "GnomeWhormHoleToken address not set");

        uint256 feeAmount = (amount * unwrapFee) / 10000;
        uint256 transferAmount = amount - feeAmount;
        transferAmount *= 10 ** 18;
        require(gnomeWhormHoleToken.transferFrom(msg.sender, address(this), amount * 10 ** 9), "Transfer failed");
        gnomeToken.transfer(msg.sender, transferAmount);
        emit Unwrap(msg.sender, amount, feeAmount);
    }

    // Owner functions for emergency recovery
    function recoverERC20(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }
}
