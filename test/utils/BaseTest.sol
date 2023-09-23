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
    /// @dev `0xc1806ea961848ac00c1f20aa0611529da522a7bd125a3036fe4641b07ee5c61c`.
    bytes8 constant SPRING_HASH =
        bytes8(
            keccak256(
                abi.encodePacked(
                    uint256(0xFFFFFF00FFFF),
                    uint256(0xFFFFFF000000),
                    uint256(0xFF000000FFFF)
                )
            )
        );

    /// @notice Hash of the segment data corresponding to the ``Jet'' colormap.
    /// @dev `0x026736ef8439ebcf8e7b8006bf8cb7482ced84d71b900407a9ed63e1b7bfe234`.
    bytes8 constant JET_HASH =
        bytes8(
            keccak256(
                abi.encodePacked(
                    uint256(0xFF7F7FE2FFFFA8FFFF590000000000),
                    uint256(0xFF0000E80000A3FFFF5FFFFF1F0000000000),
                    uint256(0xFF0000A5000056FFFF1CFFFF007F7F)
                )
            )
        );

    /// @notice The simplest, valid segment.
    uint256 constant SIMPLE_VALID_SEGMENT = 0xFFFFFF00FFFF;

    /// @notice Hash of segment data where R, G, and B are all the simplest,
    /// valid segment.
    /// @dev `0xcb7631b03f24518f4e4590ff71b1008d6aec2ae35b6c62cd9fb4d72608060e8e`.
    bytes8 constant SIMPLE_VALID_SEGMENT_HASH =
        bytes8(
            keccak256(
                abi.encodePacked(
                    SIMPLE_VALID_SEGMENT,
                    SIMPLE_VALID_SEGMENT,
                    SIMPLE_VALID_SEGMENT
                )
            )
        );

    // -------------------------------------------------------------------------
    // Events
    // -------------------------------------------------------------------------

    /// @notice Emitted when a colormap is registered via a palette generator
    /// function.
    /// @dev Copied from {IColormapRegistry}.
    /// @param _hash Hash of `_paletteGenerator`.
    /// @param _paletteGenerator Instance of {IPaletteGenerator} for the
    /// colormap.
    event RegisterColormap(bytes8 _hash, IPaletteGenerator _paletteGenerator);

    /// @notice Emitted when a colormap is registered via segment data.
    /// @dev Copied from {IColormapRegistry}.
    /// @param _hash Hash of `_segmentData`.
    /// @param _segmentData Segment data defining the colormap.
    event RegisterColormap(
        bytes8 _hash,
        IColormapRegistry.SegmentData _segmentData
    );

    // -------------------------------------------------------------------------
    // Contracts
    // -------------------------------------------------------------------------

    /// @notice The colormap registry contract.
    ColormapRegistry public colormapRegistry;

    /// @notice An instance of the `gnuplot` palette generator contract.
    GnuPlotPaletteGenerator public gnuPlotPaletteGenerator;

    /// @notice A second instance of the `gnuplot` palette generator contract.
    /// @dev This is used to benchmark the `register` function.
    GnuPlotPaletteGenerator public samplePaletteGenerator;

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @notice Hash of the ``gnuplot` colormap deployed in {BaseTest.setUp}.
    bytes8 public gnuPlotHash;

    // -------------------------------------------------------------------------
    // Set up
    // -------------------------------------------------------------------------

    /// @notice Set up the test contract by deploying an instance of
    /// {ColormapRegistry}. Then, the ``Spring'' colormap is added via a segment
    /// data definition, and the `gnuplot` colormap is added via a palette
    /// generator definition.
    function setUp() public {
        colormapRegistry = new ColormapRegistry();

        // Add ``Spring'' colormap to the registry via segment data definition.
        IColormapRegistry.SegmentData memory springSegmentData;
        springSegmentData.r = 0xFFFFFF00FFFF;
        springSegmentData.g = 0xFFFFFF000000;
        springSegmentData.b = 0xFF000000FFFF;
        colormapRegistry.register(springSegmentData);

        // Add ``Jet'' colormap to the registry via segment data definition. It
        // has a more complex structure than ``Spring,'' so it'll be useful for
        // testing the ``get value'' functions.
        IColormapRegistry.SegmentData memory jetSegmentData;
        jetSegmentData.r = 0xFF7F7FE2FFFFA8FFFF590000000000;
        jetSegmentData.g = 0xFF0000E80000A3FFFF5FFFFF1F0000000000;
        jetSegmentData.b = 0xFF0000A5000056FFFF1CFFFF007F7F;
        colormapRegistry.register(jetSegmentData);

        // Add `gnuplot` colormap to the registry via palette generator
        // definition.
        gnuPlotPaletteGenerator = new GnuPlotPaletteGenerator();
        colormapRegistry.register(gnuPlotPaletteGenerator);

        // Set hash.
        gnuPlotHash = bytes8(
            keccak256(abi.encodePacked(gnuPlotPaletteGenerator))
        );

        // Deploy a second instance of the `gnuplot` palette generator contract.
        samplePaletteGenerator = new GnuPlotPaletteGenerator();
    }
}
