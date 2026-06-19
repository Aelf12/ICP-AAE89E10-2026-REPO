// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Staking {
    using SafeERC20 for IERC20;

    // Tightly packed struct layout for EVM gas efficiency
    struct UserPosition {
        uint256 stakedBalance;
        uint256 stakingTimestamp;
        uint256 accruedReward;
    }

    IERC20 public immutable STAKING_TOKEN;
    uint256 public constant REWARD_RATE_PER_SECOND = 100; 

    // Single unified mapping instead of three separate ones
    mapping(address => UserPosition) public userPositions;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);

    constructor(address _tokenAddress) {
        STAKING_TOKEN = IERC20(_tokenAddress);
    }

    function calculatePendingReward(address _user) public view returns (uint256) {
        UserPosition memory position = userPositions[_user];
        if (position.stakedBalance == 0) return 0;
        
        uint256 timeStaked = block.timestamp - position.stakingTimestamp;
        return (position.stakedBalance * timeStaked * REWARD_RATE_PER_SECOND) / 1e18;
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        // Use storage pointer to update values in place efficiently
        UserPosition storage position = userPositions[msg.sender];
        
        position.accruedReward += calculatePendingReward(msg.sender);
        
        STAKING_TOKEN.safeTransferFrom(msg.sender, address(this), _amount);
        
        position.stakedBalance += _amount;
        position.stakingTimestamp = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    function unstake(uint256 _amount) external {
        UserPosition storage position = userPositions[msg.sender];
        require(_amount > 0, "Amount must be greater than 0");
        require(position.stakedBalance >= _amount, "Insufficient staked balance");

        position.accruedReward += calculatePendingReward(msg.sender);

        position.stakedBalance -= _amount;
        position.stakingTimestamp = block.timestamp;

        STAKING_TOKEN.safeTransfer(msg.sender, _amount);

        emit Unstaked(msg.sender, _amount);
    }

    function claimReward() external {
        UserPosition storage position = userPositions[msg.sender];
        uint256 totalReward = position.accruedReward + calculatePendingReward(msg.sender);
        require(totalReward > 0, "No rewards to claim");

        position.accruedReward = 0;
        position.stakingTimestamp = block.timestamp;

        STAKING_TOKEN.safeTransfer(msg.sender, totalReward);

        emit RewardClaimed(msg.sender, totalReward);
    }
}