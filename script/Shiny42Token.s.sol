// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console2} from "forge-std/Script.sol";
import {Shiny42Token} from "src/Shiny42Token.sol";

contract Shiny42TokenDeploy is Script {
    function run() external returns (Shiny42Token shiny42Token) {
        vm.startBroadcast();
        change
        shiny42Token = new Shiny42Token();
        console2.log("Created a new Shiny42Token contract!");
        console2.log("Adress: ", address(shiny42Token));
        vm.stopBroadcast();
    }
}
