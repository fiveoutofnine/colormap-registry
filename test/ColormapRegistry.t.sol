// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {BaseTest} from "./utils/BaseTest.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";

/// @notice Unit tests for {ColormapRegistry}, organized by functions.
contract ColormapRegistryTest is BaseTest {
    // -------------------------------------------------------------------------
    // Register with palette generator
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // Register with segment data
    // -------------------------------------------------------------------------

    /// @notice Test that registering the same color map fails.
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
        vm.assume(_startPosition < 256 && _startPosition != 0);
        uint256 segmentDataUndefinedAtStart = 0xFFFFFF00FFFF &
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
        vm.assume(_endPosition < 256 && _endPosition != 255);
        uint256 segmentDataUndefinedAtEnd = 0x00FFFFFFFFFF &
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
}
