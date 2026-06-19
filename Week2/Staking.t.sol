// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Staking} from "./Staking.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract StakingTest is Test {
    Staking public staking;
    MockToken public token;

    address public alice = address(0x1);
    address public bob = address(0x2);

    uint256 public constant INITIAL_BALANCE = 1000 * 10**18;

    function setUp() public {
        token = new MockToken();
        staking = new Staking(address(token));

        require(token.transfer(alice, INITIAL_BALANCE), "Seed Alice failed!");
        require(token.transfer(bob, INITIAL_BALANCE), "Seed Bob failed!");
        require(token.transfer(address(staking), 500000 * 10**18), "Seed Staking failed!");
    }

    function test_InitialState() public view {
        // Destructure the public mapping getter (ignores timestamp and reward parameters)
        (uint256 balance, , ) = staking.userPositions(alice);
        assertEq(balance, 0);
    }

    function test_StakeTokens() public {
        uint256 stakeAmount = 100 * 10**18;

        vm.startPrank(alice);
        token.approve(address(staking), stakeAmount);
        staking.stake(stakeAmount);
        vm.stopPrank();

        (uint256 balance, uint256 timestamp, ) = staking.userPositions(alice);
        assertEq(balance, stakeAmount);
        assertEq(timestamp, block.timestamp);
    }

    function test_AccruedRewardsOverTime() public {
        uint256 stakeAmount = 100 * 10**18;

        vm.startPrank(alice);
        token.approve(address(staking), stakeAmount);
        staking.stake(stakeAmount);
        vm.stopPrank();

        vm.warp(block.timestamp + 86400);

        uint256 expectedReward = (stakeAmount * 86400 * staking.REWARD_RATE_PER_SECOND()) / 1e18;
        uint256 actualReward = staking.calculatePendingReward(alice);

        assertEq(actualReward, expectedReward);
    }

    function test_CannotUnstakeMoreThanBalance() public {
        uint256 stakeAmount = 50 * 10**18;

        vm.startPrank(alice);
        token.approve(address(staking), stakeAmount);
        staking.stake(stakeAmount);

        vm.expectRevert();
        staking.unstake(100 * 10**18);
        vm.stopPrank();
    }

    function testFuzz_StakeAnyAmount(uint256 randomAmount) public {
        // Bound the random number to keep it within a realistic transaction range
        vm.assume(randomAmount > 0 && randomAmount <= INITIAL_BALANCE);

        vm.startPrank(alice);
        token.approve(address(staking), randomAmount);
        staking.stake(randomAmount);
        vm.stopPrank();

        (uint256 balance, , ) = staking.userPositions(alice);
        assertEq(balance, randomAmount);
    }

    function testFuzz_UnstakeAnyAmount(uint256 randomAmount) public {
        uint256 stakeAmount = 100 * 10**18;
        vm.startPrank(alice);
        token.approve(address(staking), stakeAmount);
        staking.stake(stakeAmount);
        vm.stopPrank();

        vm.assume(randomAmount > 0 && randomAmount <= stakeAmount);

        vm.startPrank(alice);
        staking.unstake(randomAmount);
        vm.stopPrank();

        uint256 expectedBalance = stakeAmount - randomAmount;
        (uint256 balance, , ) = staking.userPositions(alice);
        assertEq(balance, expectedBalance);
    }
}
