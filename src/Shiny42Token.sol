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
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

contract Shiny42Token is ERC20, Ownable, Pausable {
    // 1. Mapping of user's addres to his balance
    // 2. Total supply
    // 3. Mint
    // 4. Burn
    // 5. Transfer
    // 6. Transfer from

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 public constant FAUCET_AMOUNT = 100 * 1e18;
    uint256 public constant FAUCET_COOLDOWN = 5 minutes;

    mapping(address => uint256) public s_lastMintedAt;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event FaucetUsed(address indexed user, uint256 amount);
    event Burned(address indexed user, uint256 amount);

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
    error Shiny42Token__FaucetCooldownNotFinished();

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor() ERC20("Shiny42Token", "S42T") Ownable(msg.sender) {}

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice Developers can mint a small amount for testing
     */
    function faucet() external whenNotPaused {
        if (s_lastMintedAt[msg.sender] - block.timestamp <= FAUCET_COOLDOWN) {
            revert Shiny42Token__FaucetCooldownNotFinished();
        }
        s_lastMintedAt[msg.sender] = block.timestamp;
        _mint(msg.sender, FAUCET_AMOUNT);
        emit FaucetUsed(msg.sender, FAUCET_AMOUNT);
    }

    /**
     * @notice Allow users to burn their tokens
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) external moreThanZero(amount) {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    /**
     * @notice Admin pause function
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice Admin unpause function
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                             VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
}
