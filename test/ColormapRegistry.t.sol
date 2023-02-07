// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {console} from "forge-std/Test.sol";
import {BaseTest} from "./utils/BaseTest.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";
import {GnuPlotPaletteGenerator} from "@/contracts/GnuPlotPaletteGenerator.sol";

/// @notice Unit tests for {ColormapRegistry}, organized by functions.
contract ColormapRegistryTest is BaseTest {
    // -------------------------------------------------------------------------
    // Register with palette generator
    // -------------------------------------------------------------------------

    /// @notice Test that registering the same color map via a palette generator
    /// fails.
    function test_register_ViaPaletteGeneratorAddSameColormapTwice_Fails()
        public
    {
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapAlreadyExists.selector,
                gnuplotHash
            )
        );
        colormapRegistry.register(gnuPlotPaletteGenerator);
    }

    /// @notice Test events emitted and storage variable changes upon
    /// registering a colormap via palette generator.
    function test_register_ViaPaletteGenerator() public {
        // Deploy a `gnuplot` colormap.
        GnuPlotPaletteGenerator newGnuPlotPaletteGenerator = new GnuPlotPaletteGenerator();
        bytes32 colormapHash = keccak256(
            abi.encodePacked(newGnuPlotPaletteGenerator)
        );

        // The palette generator is unset.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(colormapHash)),
                address(0)
            );
        }

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(colormapHash, newGnuPlotPaletteGenerator);
        colormapRegistry.register(newGnuPlotPaletteGenerator);

        // The palette generator was set.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(colormapHash)),
                address(newGnuPlotPaletteGenerator)
            );
        }
    }

    // -------------------------------------------------------------------------
    // Register with segment data
    // -------------------------------------------------------------------------

    /// @notice Test that registering the same color map via segment data fails.
    function test_register_ViaSegmentDataAddSameColormapTwice_Fails() public {
        // The ``Spring'' colormap was already added during set up.
        IColormapRegistry.SegmentData memory springSegmentData;
        springSegmentData.r = 0xFFFFFF00FFFF;
        springSegmentData.g = 0xFFFFFF000000;
        springSegmentData.b = 0xFF000000FFFF;

        // Expect revert with the hash of the ``Spring'' colormap.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapAlreadyExists.selector,
                SPRING_HASH
            )
        );
        colormapRegistry.register(springSegmentData);
    }

    /// @notice Test that segment data must be defined from the start.
    /// @param _startPosition Start position of the segment data.
    function test_register_ViaSegmentDataUndefinedAtStart_Invalid(
        uint256 _startPosition
    ) public {
        // The following segment is undefined because bits 16-23 are not 0.
        _startPosition = bound(_startPosition, 1, 255);
        uint256 segmentDataUndefinedAtStart = 0xFFFFFF00FFFF |
            (_startPosition << 16);

        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = segmentDataUndefinedAtStart;
        segmentData.g = segmentDataUndefinedAtStart;
        segmentData.b = segmentDataUndefinedAtStart;

        // Expect revert because the segment doesn't start at 0.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.SegmentDataInvalid.selector,
                segmentDataUndefinedAtStart
            )
        );
        colormapRegistry.register(segmentData);
    }

    /// @notice Test that each segment must increase in position compared to
    /// the previous segment.
    function test_register_ViaSegmentDataDoesntIncrease_Invalid() public {
        // The position goes from 0 to 0x10 to 0x10 to 0xFF. Although the start
        // and end positions are correct, it doesn't increase from 0x10 to 0x10.
        // Thus, it is invalid.
        uint256 segmentDataDoesntIncrease = 0xFFFFFF10FFFF10FFFF00FFFF;
        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = segmentDataDoesntIncrease;
        segmentData.g = segmentDataDoesntIncrease;
        segmentData.b = segmentDataDoesntIncrease;

        // Expect revert because segment doesn't increase from the 2nd segment
        // to the 3rd.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.SegmentDataInvalid.selector,
                segmentDataDoesntIncrease
            )
        );
        colormapRegistry.register(segmentData);
    }

    /// @notice Test that each segment can not decrease in position compared to
    /// the previous segment.
    function test_register_ViaSegmentDataDecrease_Invalid() public {
        // The position goes from 0 to 0x80 to 0x70 to 0xFF. Although the start
        // and end positions are correct, it decreases from 0x80 to 0x70. Thus,
        // it is invalid.
        uint256 segmentDataDoesntIncrease = 0xFFFFFF70FFFF80FFFF00FFFF;
        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = segmentDataDoesntIncrease;
        segmentData.g = segmentDataDoesntIncrease;
        segmentData.b = segmentDataDoesntIncrease;

        // Expect revert because segment decreases from the 2nd segment to the
        // 3rd.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.SegmentDataInvalid.selector,
                segmentDataDoesntIncrease
            )
        );
        colormapRegistry.register(segmentData);
    }

    /// @notice Test that segment data must be defined til the end.
    /// @param _endPosition End position of the segment data.
    function test_register_ViaSegmentDataUndefinedAtEnd_Invalid(
        uint256 _endPosition
    ) public {
        // The following segment is undefined because bits 40-47 are not 0.
        _endPosition = bound(_endPosition, 0, 254);
        uint256 segmentDataUndefinedAtEnd = 0x00FFFF00FFFF |
            (_endPosition << 40);

        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = segmentDataUndefinedAtEnd;
        segmentData.g = segmentDataUndefinedAtEnd;
        segmentData.b = segmentDataUndefinedAtEnd;

        // Expect revert because the segment doesn't end at 255.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.SegmentDataInvalid.selector,
                segmentDataUndefinedAtEnd
            )
        );
        colormapRegistry.register(segmentData);
    }

    /// @notice Test events emitted and storage variable changes upon
    /// registering a colormap via segment data.
    function test_register_ViaSegmentData() public {
        // Initialize a simple, valid segment data.
        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = SIMPLE_VALID_SEGMENT;
        segmentData.g = SIMPLE_VALID_SEGMENT;
        segmentData.b = SIMPLE_VALID_SEGMENT;
        bytes32 colormapHash = SIMPLE_VALID_SEGMENT_HASH;

        // The segment data is unset.
        {
            (uint256 r, uint256 g, uint256 b) = colormapRegistry.segments(
                colormapHash
            );
            assertEq(r, 0);
            assertEq(g, 0);
            assertEq(b, 0);
        }

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(colormapHash, segmentData);
        colormapRegistry.register(segmentData);

        // The segment data was set.
        {
            (uint256 r, uint256 g, uint256 b) = colormapRegistry.segments(
                colormapHash
            );
            assertEq(r, SIMPLE_VALID_SEGMENT);
            assertEq(g, SIMPLE_VALID_SEGMENT);
            assertEq(b, SIMPLE_VALID_SEGMENT);
        }
    }

    // -------------------------------------------------------------------------
    // Get value
    // -------------------------------------------------------------------------

    /// @notice Test that the colormap hash must exist.
    /// @param _colormapHash Hash of some nonexistant colormap.
    function test_getValue_ColormapHashDoesntExist_Fails(bytes32 _colormapHash)
        public
    {
        vm.assume(_colormapHash != SPRING_HASH && _colormapHash != gnuplotHash);

        // Expect revert because the colormap hash doesn't exist.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapDoesNotExist.selector,
                _colormapHash
            )
        );
        colormapRegistry.getValue(_colormapHash, 0);
    }

    /// @notice Test that values are within bounds for all positions when read
    /// from a palette generator.
    /// @param _position Position in the colormap.
    function test_getValue_FromPaletteGenerator_ValueIsWithinBounds(
        uint256 _position
    ) public {
        _position = bound(_position, 0, 1e18);

        (uint256 r, uint256 g, uint256 b) = colormapRegistry.getValue(
            gnuplotHash,
            _position
        );
        assertTrue(r <= 1e18);
        assertTrue(g <= 1e18);
        assertTrue(b <= 1e18);
    }

    /// @notice Test that values are within bounds for all positions when read
    /// from segment data.
    /// @param _position Position in the colormap.
    function test_getValue_FromSegmentData_ValueIsWithinBounds(
        uint256 _position
    ) public {
        _position = bound(_position, 0, 1e18);
        console.log(_position);

        (uint256 r, uint256 g, uint256 b) = colormapRegistry.getValue(
            SPRING_HASH,
            _position
        );
        assertTrue(r <= 1e18);
        assertTrue(g <= 1e18);
        assertTrue(b <= 1e18);
    }

    // -------------------------------------------------------------------------
    // Get value as `uint8`
    // -------------------------------------------------------------------------

    /// @notice Test that the colormap hash must exist.
    /// @param _colormapHash Hash of some nonexistant colormap.
    function test_getValueAsUint8_ColormapHashDoesntExist_Fails(
        bytes32 _colormapHash
    ) public {
        vm.assume(_colormapHash != SPRING_HASH && _colormapHash != gnuplotHash);

        // Expect revert because the colormap hash doesn't exist.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapDoesNotExist.selector,
                _colormapHash
            )
        );
        colormapRegistry.getValueAsUint8(_colormapHash, 0);
    }

    /// @notice Test that all positions pass when read from a palette generator.
    /// @param _position Position in the colormap.
    function test_getValue_FromPaletteGenerator_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsUint8(gnuplotHash, _position);
    }

    /// @notice Test that all positions pass when read from segment data.
    /// @param _position Position in the colormap.
    function test_getValue_FromSegmentData_PassesAllPositions(uint8 _position)
        public
        view
    {
        colormapRegistry.getValueAsUint8(SPRING_HASH, _position);
    }
}
