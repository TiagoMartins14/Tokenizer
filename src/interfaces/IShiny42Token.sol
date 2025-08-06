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

interface IShiny42Token {
    function mint(address _user, uint256 _amount) external;
    function burn(address _user, uint256 _amount) external;
}