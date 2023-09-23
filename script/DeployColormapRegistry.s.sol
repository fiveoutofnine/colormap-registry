// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { Script } from "forge-std/Script.sol";

import { ColormapRegistry } from "@/contracts/ColormapRegistry.sol";
import { ICreate2Factory } from "@/contracts/interfaces/ICreate2Factory.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract DeployColormapRegistryScript is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice Address of the CREATE2 factory.
    address constant IMMUTABLE_CREATE2_FACTORY_ADDRESS = 0x0000000000FFe8B47B3e2130213B802212439497;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        vm.startBroadcast();

        ICreate2Factory factory = ICreate2Factory(IMMUTABLE_CREATE2_FACTORY_ADDRESS);

        // Deploy {ColormapRegistry} via the factory.
        bytes32 salt = 0x00000000000000000000000000000000000000000e558e93fbb8d803204fdbdb;
        factory.safeCreate2(salt, type(ColormapRegistry).creationCode);

        vm.stopBroadcast();
    }
}
