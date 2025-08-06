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

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Shiny42Token is ERC20, Ownable {

    // 1. Mapping of user's addres to his balance
    // 2. Total supply
    // 3. Mint
    // 4. Burn
    // 5. Transfer
    // 6. Transfer from

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    mapping(address user => uint256 balance) s_userBalance;
    mapping(address token => uint256 totalSupply) s_totalTokenSupply;
    uint256 s_totalShiny42TokenSupply;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier moreThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert Shiny42Token__NeedsToBeMoreThanZero();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error Shiny42Token__NeedsToBeMoreThanZero();
    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor() ERC20("Shiny42Token", "S42T") Ownable(msg.sender) {}

    /**
     * @notice Mints Shiny42Tokens to the user
     */
    function mint(address _account, uint256 _value) private onlyOwner {
        _mint(_account, _value);
    }

    /**
     * @notice Burns Shiny42Tokens from the user
     */
    function burn(address _account, uint256 _value) private onlyOwner {
        _burn(_account, _value);
    }

    /**
     * @notice Swaps other tokens for Shiny42Tokens. A user can only swap for officially recognized tokens.
     */
    function getShiny42Tokens(address _user, uint256 _amount, address _token) public moreThanZero(_amount) onlyOwner() {
        s_userBalance += _amount;
        s_totalTokenSupply[_token]
        mint(_user, _amount);
    }
}