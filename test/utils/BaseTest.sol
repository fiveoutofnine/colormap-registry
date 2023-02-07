// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";

import {ColormapRegistry} from "@/contracts/ColormapRegistry.sol";
import {GnuPlotPaletteGenerator} from "@/contracts/GnuPlotPaletteGenerator.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";
import {IPaletteGenerator} from "@/contracts/interfaces/IPaletteGenerator.sol";

/// @notice A base test contract for ColormapRegistry. In the `setUp` function,
/// an instance of {ColormapRegistry} is deployed, and the ``Spring'' color map
/// is added to the registry via a segment data definition.
contract BaseTest is Test {
    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Hash of the segment data corresponding to the ``Spring''
    /// colormap.
    /// @dev `keccak256(abi.encodePacked(0xFFFFFF00FFFF, 0xFFFFFF000000, 0xFF000000FFFF))`
    bytes32 constant SPRING_HASH =
        0xc1806ea961848ac00c1f20aa0611529da522a7bd125a3036fe4641b07ee5c61c;

    /// @notice The simplest, valid segment.
    uint256 constant SIMPLE_VALID_SEGMENT = 0xFFFFFF00FFFF;

    /// @notice Hash of segment data where R, G, and B are all the simplest,
    /// valid segment.
    /// @dev `keccak256(abi.encodePacked(SIMPLE_VALID_SEGMENT, SIMPLE_VALID_SEGMENT, SIMPLE_VALID_SEGMENT))``
    bytes32 constant SIMPLE_VALID_SEGMENT_HASH =
        0xcb7631b03f24518f4e4590ff71b1008d6aec2ae35b6c62cd9fb4d72608060e8e;

    // -------------------------------------------------------------------------
    // Events
    // -------------------------------------------------------------------------

    /// @notice Emitted when a colormap is registered via a palette generator
    /// function.
    /// @dev Copied from {IColormapRegistry}.
    /// @param _hash Hash of `_paletteGenerator`.
    /// @param _paletteGenerator Instance of {IPaletteGenerator} for the
    /// colormap.
    event RegisterColormap(bytes32 _hash, IPaletteGenerator _paletteGenerator);

    /// @notice Emitted when a colormap is registered via segment data.
    /// @dev Copied from {IColormapRegistry}.
    /// @param _hash Hash of `_segmentData`.
    /// @param _segmentData Segment data defining the colormap.
    event RegisterColormap(
        bytes32 _hash,
        IColormapRegistry.SegmentData _segmentData
    );

    // -------------------------------------------------------------------------
    // Contracts
    // -------------------------------------------------------------------------

    /// @notice The colormap registry contract.
    ColormapRegistry public colormapRegistry;

    // -------------------------------------------------------------------------
    // Set up
    // -------------------------------------------------------------------------

    function setUp() public {
        colormapRegistry = new ColormapRegistry();

        // Add ``Spring'' colormap to the registry via segment data definition.
        IColormapRegistry.SegmentData memory springSegmentData;
        springSegmentData.r = 0xFFFFFF00FFFF;
        springSegmentData.g = 0xFFFFFF000000;
        springSegmentData.b = 0xFF000000FFFF;
        colormapRegistry.register(springSegmentData);

        // Add `gnuplot` colormap to the registry via palette generator
        // definition.
        colormapRegistry.register(new GnuPlotPaletteGenerator());
    }
}
