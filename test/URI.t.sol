// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Program, Params} from "src/Program.sol";
import {Research} from "src/Research.sol";
import {Data} from "src/Data.sol";

contract URITest is Test {
    address ETHFS_MAINNET = 0x9746fD0A77829E12F8A9DBe70D7a322412325B91;
    address ETHFS_TESTNET = 0x5E348d0975A920E9611F8140f84458998A53af94;

    Program program;
    Research research;

    function setUp() public {
        program = new Program(ETHFS_MAINNET);
        research = new Research(ETHFS_MAINNET);
    }

    function xtestProgramURI() public {
        Params memory params = Params(
            0,
            0,
            0,
            "[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]",
            address(0),
            0,
            0,
            0
        );

        console2.log(program.uri(params));
    }

    function xtestResearchURI() public {
        console2.log(research.uri(0));
    }

    function xtestDataURI() public {
        console2.log(Data._image(0));
    }
}
