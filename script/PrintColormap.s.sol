// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {LibString} from "solmate/utils/LibString.sol";

import {ColormapRegistry} from "@/contracts/ColormapRegistry.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract PrintColormap is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice Address of the colormap registry on Ethereum mainnet.
    address constant COLORMAP_REGISTRY =
        0x0000000012883D1da628e31c0FE52e35DcF95D50;

    /// @notice Hash of the colormap to print.
    /// @dev Replace this.
    bytes8 constant COLORMAP_HASH = bytes8(0);

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        ColormapRegistry colormapRegistry = ColormapRegistry(COLORMAP_REGISTRY);

        // Start SVG.
        string
            memory svg = '<svg width="52" height="26" viewBox="0 0 52 26" fill="none" xmlns="http://www.w3.org/2000/svg">';

        for (uint256 i; i < 256; i += 5) {
            svg = string.concat(
                svg,
                '<rect fill="#',
                colormapRegistry.getValueAsHexString(COLORMAP_HASH, uint8(i)),
                '" x="',
                LibString.toString(i / 5),
                '" y="0" width="1" height="26"/>'
            );
        }

        // Finish SVG.
        svg = string.concat(svg, "</svg>");

        console.log(svg);
    }
}
