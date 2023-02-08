// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

import {GnuPlotPaletteGenerator} from "@/contracts/GnuPlotPaletteGenerator.sol";
import {ICreate2Factory} from "@/contracts/interfaces/ICreate2Factory.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract DeployGnuPlotPalettegeneratorScript is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice Address of the CREATE2 factory.
    address constant IMMUTABLE_CREATE2_FACTORY_ADDRESS =
        0x0000000000FFe8B47B3e2130213B802212439497;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        vm.startBroadcast();

        // Deploy {GnuPlotPaletteGenerator}.
        ICreate2Factory factory = ICreate2Factory(
            IMMUTABLE_CREATE2_FACTORY_ADDRESS
        );

        // Deploy {GnuPlotPaletteGenerator} via the factory.
        bytes32 salt = bytes32(0);
        factory.safeCreate2(salt, type(GnuPlotPaletteGenerator).creationCode);

        vm.stopBroadcast();
    }
}
