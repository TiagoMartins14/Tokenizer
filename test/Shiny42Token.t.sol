// Order of Layout
// Contract elements should be laid out in the following order:

// Pragma statements
// Import statements
// Events
// Errors
// Interfaces
// Libraries
// Contracts

// Inside each contract, library or interface, use the following order:

// Type declarations
// State variables
// Events
// Errors
// Modifiers
// Functions

// Order of Functions

// Constructor
// Receive function (if exists)
// Falback function (if exists)
// External
// Public
// Internal
// Private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Shiny42Token} from "src/Shiny42Token.sol";

contract Shiny42TokenTest is Test {
    error Shiny42Token__NeedsToBeMoreThanZero();
    error Shiny42Token__FaucetCooldownNotFinished();
    error Shiny42Token__NotEnoughBalance();
	error OwnableUnauthorizedAccount(address account);
	error EnforcedPause();
    error ExpectedPause();

    Shiny42Token shiny42Token;
    address user;

    function setUp() external {
        shiny42Token = new Shiny42Token();
        user = makeAddr("user");
    }

    function testFaucet() public {
        // Check initial balance
        assertEq(shiny42Token.balanceOf(user), 0);
        vm.startPrank(user);
        shiny42Token.faucet();
        // Check balance after faucet
        assertEq(shiny42Token.balanceOf(user), shiny42Token.FAUCET_DRIP_AMOUNT());
        vm.warp(10 minutes);
        vm.roll(block.timestamp + 1);
        shiny42Token.faucet();
        // Check balance after second faucet call
        assertEq(shiny42Token.balanceOf(user), shiny42Token.FAUCET_DRIP_AMOUNT() * 2);
        vm.stopPrank();
    }

    function testFaucetCooldown() public {
        vm.startPrank(user);
        shiny42Token.faucet();
        // Check that the cooldown is enforced
        vm.expectRevert(Shiny42Token__FaucetCooldownNotFinished.selector);
        shiny42Token.faucet();
        vm.warp(shiny42Token.FAUCET_COOLDOWN());
        vm.roll(block.timestamp + 1);
        // Check the lower limit of the cooldown
        vm.expectRevert(Shiny42Token__FaucetCooldownNotFinished.selector);
        shiny42Token.faucet();
        vm.warp(shiny42Token.FAUCET_COOLDOWN() + 1 seconds);
        vm.roll(block.timestamp + 1);
        // After the cooldown, the faucet should work again
        shiny42Token.faucet();
        vm.stopPrank();
    }

    function testBurn() public {
        vm.startPrank(user);
        shiny42Token.faucet();
        shiny42Token.burn(shiny42Token.FAUCET_DRIP_AMOUNT() / 2);
        // Check balance after burn
        assertEq(shiny42Token.balanceOf(user), shiny42Token.FAUCET_DRIP_AMOUNT() / 2);
        // Check it reverts when trying to burn 0 tokens
        vm.expectRevert(Shiny42Token__NeedsToBeMoreThanZero.selector);
        shiny42Token.burn(0);
        // Check it reverts when trying to burn more than balance
		uint256 overBalance = shiny42Token.balanceOf(user) + 1;
        vm.expectRevert(Shiny42Token__NotEnoughBalance.selector);
        shiny42Token.burn(overBalance + 1);
        //  Check final balance - should be half of the faucet amount
        assertEq(shiny42Token.balanceOf(user), shiny42Token.FAUCET_DRIP_AMOUNT() / 2);
        vm.stopPrank();
    }

	function testOnlyOwnerCanPause() public {
		vm.prank(user);
		vm.expectPartialRevert(OwnableUnauthorizedAccount.selector);
		// Reverts for prank user
		shiny42Token.pause();
		// Does not revert for owner
		shiny42Token.pause();	
	}

	function testOwnerCanOnlyPauseIfUnpaused() public {
		shiny42Token.pause();
		// Reverts if paused
		vm.expectRevert(EnforcedPause.selector);
		shiny42Token.pause();
	}

	function testOnlyOwnerCanUnpause() public {
		shiny42Token.pause();
		vm.prank(user);
		vm.expectPartialRevert(OwnableUnauthorizedAccount.selector);
		// Reverts for prank user
		shiny42Token.unpause();
		// Does not revert for owner
		shiny42Token.unpause();	
	}

	function testOwnerCanOnlyUnpauseIfPaused() public {
		// As contract is defaulted to unpaused, it should revert if trying to unpause
		vm.expectRevert(ExpectedPause.selector);
		shiny42Token.unpause();
	}
}
