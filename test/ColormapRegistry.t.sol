// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";

import {ColormapRegistry} from "@/contracts/ColormapRegistry.sol";

contract ColormapRegistryTest is Test {
    ColormapRegistry public colormapRegistry;

    function setUp() public {
        colormapRegistry = new ColormapRegistry();
    }
}
