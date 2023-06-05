// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {AngelMatter} from "src/AngelMatter.sol";

contract Deploy is Script {
    address ETHFS_MAINNET = 0x9746fD0A77829E12F8A9DBe70D7a322412325B91;
    address ETHFS_TESTNET = 0x5E348d0975A920E9611F8140f84458998A53af94;

    address mainMe = 0x0aa0Bc25769C52e623D09A9764e079A221BeA2a1;
    address testMe = 0xDead8d41881c82b9fc393D812239F41f3C943a37;

    uint256 startTime = 0;

    AngelMatter am;

    function run() external {
        vm.startBroadcast();

        am = new AngelMatter(testMe, startTime);

        vm.stopBroadcast();
    }
}
