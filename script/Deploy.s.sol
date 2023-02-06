// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

import {ColormapRegistry} from "@/contracts/ColormapRegistry.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract DeployScript is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice The instance of `ColormapRegistry` that will be deployed after
    /// the script runs.
    ColormapRegistry public colormapRegistry;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        vm.startBroadcast();

        // Deploy contract.
        colormapRegistry = new ColormapRegistry();

        vm.stopBroadcast();
    }
}
