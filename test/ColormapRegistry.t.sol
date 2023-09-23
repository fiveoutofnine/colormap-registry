// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {BaseTest} from "./utils/BaseTest.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";
import {IPaletteGenerator} from "@/contracts/interfaces/IPaletteGenerator.sol";
import {GnuPlotPaletteGenerator} from "@/contracts/GnuPlotPaletteGenerator.sol";

/// @notice Unit tests for {ColormapRegistry}, organized by functions.
contract ColormapRegistryTest is BaseTest {
    // -------------------------------------------------------------------------
    // Batch register with palette generator
    // -------------------------------------------------------------------------

    /// @notice Test that registering the same color map via a palette generator
    /// fails.
    function test_batchRegister_ViaPaletteGeneratorAddSameColormapTwice_Fails()
        public
    {
        IPaletteGenerator[]
            memory gnuPlotPaletteGenerators = new IPaletteGenerator[](1);
        gnuPlotPaletteGenerators[0] = gnuPlotPaletteGenerator;

        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapAlreadyExists.selector,
                gnuPlotHash
            )
        );
        colormapRegistry.batchRegister(gnuPlotPaletteGenerators);
    }

    /// @notice Test events emitted and storage variable changes upon
    /// batch registering colormaps via palette generator.
    function test_batchRegister_ViaPaletteGenerator() public {
        // Deploy 2 `gnuplot` colormaps.
        GnuPlotPaletteGenerator newGnuPlotPaletteGenerator0 = new GnuPlotPaletteGenerator();
        GnuPlotPaletteGenerator newGnuPlotPaletteGenerator1 = new GnuPlotPaletteGenerator();
        bytes8 hash0 = bytes8(
            keccak256(abi.encodePacked(newGnuPlotPaletteGenerator0))
        );
        bytes8 hash1 = bytes8(
            keccak256(abi.encodePacked(newGnuPlotPaletteGenerator1))
        );

        // The palette generators are unset.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(hash0)),
                address(0)
            );
            assertEq(
                address(colormapRegistry.paletteGenerators(hash1)),
                address(0)
            );
        }

        IPaletteGenerator[]
            memory gnuPlotPaletteGenerators = new IPaletteGenerator[](2);
        gnuPlotPaletteGenerators[0] = newGnuPlotPaletteGenerator0;
        gnuPlotPaletteGenerators[1] = newGnuPlotPaletteGenerator1;

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(hash0, newGnuPlotPaletteGenerator0);
        emit RegisterColormap(hash1, newGnuPlotPaletteGenerator1);
        colormapRegistry.batchRegister(gnuPlotPaletteGenerators);

        // The palette generators were set.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(hash0)),
                address(newGnuPlotPaletteGenerator0)
            );
            assertEq(
                address(colormapRegistry.paletteGenerators(hash1)),
                address(newGnuPlotPaletteGenerator1)
            );
        }
    }

    // -------------------------------------------------------------------------
    // Batch register with segment data
    // -------------------------------------------------------------------------

    /// @notice Test that tach registering the same colormaps via segment data
    /// fails.
    function test_batchRegister_ViaSegmentDataAddSameColormapTwice_Fails()
        public
    {
        // The ``Spring'' colormap was already added during set up.
        IColormapRegistry.SegmentData memory springSegmentData;
        springSegmentData.r = 0xFFFFFF00FFFF;
        springSegmentData.g = 0xFFFFFF000000;
        springSegmentData.b = 0xFF000000FFFF;

        IColormapRegistry.SegmentData[]
            memory segmentDataArray = new IColormapRegistry.SegmentData[](1);
        segmentDataArray[0] = springSegmentData;

        // Expect revert with the hash of the ``Spring'' colormap.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapAlreadyExists.selector,
                SPRING_HASH
            )
        );
        colormapRegistry.batchRegister(segmentDataArray);
    }

    /// @notice Test events emitted and storage variable changes upon
    /// batch registering colormaps via segment data.
    function test_batchRegister_ViaSegmentData() public {
        // Initialize a simple, valid segment data and the ``bone'' colormap.
        IColormapRegistry.SegmentData memory segmentData0;
        segmentData0.r = SIMPLE_VALID_SEGMENT;
        segmentData0.g = SIMPLE_VALID_SEGMENT;
        segmentData0.b = SIMPLE_VALID_SEGMENT;
        IColormapRegistry.SegmentData memory segmentData1;
        segmentData1.r = 0xFFFFFFBEA6A6000000;
        segmentData1.g = 0xFFFFFFBEC6C65D5151000000;
        segmentData1.b = 0xFFFFFF5D7171000000;
        bytes8 hash0 = SIMPLE_VALID_SEGMENT_HASH;
        bytes8 hash1 = bytes8(
            keccak256(
                abi.encodePacked(
                    uint256(0xFFFFFFBEA6A6000000),
                    uint256(0xFFFFFFBEC6C65D5151000000),
                    uint256(0xFFFFFF5D7171000000)
                )
            )
        );

        // The segment data is unset.
        {
            (uint256 r0, uint256 g0, uint256 b0) = colormapRegistry.segments(
                hash0
            );
            (uint256 r1, uint256 g1, uint256 b1) = colormapRegistry.segments(
                hash1
            );
            assertEq(r0, 0);
            assertEq(g0, 0);
            assertEq(b0, 0);
            assertEq(r1, 0);
            assertEq(g1, 0);
            assertEq(b1, 0);
        }

        IColormapRegistry.SegmentData[]
            memory segmentDataArray = new IColormapRegistry.SegmentData[](2);
        segmentDataArray[0] = segmentData0;
        segmentDataArray[1] = segmentData1;

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(hash0, segmentData0);
        emit RegisterColormap(hash1, segmentData1);
        colormapRegistry.batchRegister(segmentDataArray);

        // The segment data was set.
        {
            (uint256 r, uint256 g, uint256 b) = colormapRegistry.segments(
                hash0
            );
            assertEq(r, SIMPLE_VALID_SEGMENT);
            assertEq(g, SIMPLE_VALID_SEGMENT);
            assertEq(b, SIMPLE_VALID_SEGMENT);
        }
    }

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
                gnuPlotHash
            )
        );
        colormapRegistry.register(gnuPlotPaletteGenerator);
    }

    /// @notice Test events emitted and storage variable changes upon
    /// registering a colormap via palette generator.
    function test_register_ViaPaletteGenerator() public {
        // Deploy a `gnuplot` colormap.
        GnuPlotPaletteGenerator newGnuPlotPaletteGenerator = new GnuPlotPaletteGenerator();
        bytes8 hash = bytes8(
            keccak256(abi.encodePacked(newGnuPlotPaletteGenerator))
        );

        // The palette generator is unset.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(hash)),
                address(0)
            );
        }

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(hash, newGnuPlotPaletteGenerator);
        colormapRegistry.register(newGnuPlotPaletteGenerator);

        // The palette generator was set.
        {
            assertEq(
                address(colormapRegistry.paletteGenerators(hash)),
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
        bytes8 hash = SIMPLE_VALID_SEGMENT_HASH;

        // The segment data is unset.
        {
            (uint256 r, uint256 g, uint256 b) = colormapRegistry.segments(hash);
            assertEq(r, 0);
            assertEq(g, 0);
            assertEq(b, 0);
        }

        vm.expectEmit(true, true, true, true);
        emit RegisterColormap(hash, segmentData);
        colormapRegistry.register(segmentData);

        // The segment data was set.
        {
            (uint256 r, uint256 g, uint256 b) = colormapRegistry.segments(hash);
            assertEq(r, SIMPLE_VALID_SEGMENT);
            assertEq(g, SIMPLE_VALID_SEGMENT);
            assertEq(b, SIMPLE_VALID_SEGMENT);
        }
    }

    // -------------------------------------------------------------------------
    // Get value
    // -------------------------------------------------------------------------

    /// @notice Test that the colormap hash must exist.
    /// @param _hash Hash of some nonexistant colormap.
    function test_getValue_ColormapHashDoesntExist_Fails(bytes8 _hash) public {
        vm.assume(
            _hash != SPRING_HASH && _hash != gnuPlotHash && _hash != JET_HASH
        );

        // Expect revert because the colormap hash doesn't exist.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapDoesNotExist.selector,
                _hash
            )
        );
        colormapRegistry.getValue(_hash, 0);
    }

    /// @notice Test that values are within bounds for all positions when read
    /// from a palette generator.
    /// @param _position Position in the colormap.
    function test_getValue_FromPaletteGenerator_ValueIsWithinBounds(
        uint256 _position
    ) public {
        _position = bound(_position, 0, 1e18);

        (uint256 r, uint256 g, uint256 b) = colormapRegistry.getValue(
            gnuPlotHash,
            _position
        );
        assertTrue(r <= 1e18);
        assertTrue(g <= 1e18);
        assertTrue(b <= 1e18);
    }

    /// @notice Test that values are within bounds for all positions when read
    /// from the ``Spring'' segment data.
    /// @param _position Position in the colormap.
    function test_getValue_FromSpringSegmentData_ValueIsWithinBounds(
        uint256 _position
    ) public {
        _position = bound(_position, 0, 1e18);

        (uint256 r, uint256 g, uint256 b) = colormapRegistry.getValue(
            SPRING_HASH,
            _position
        );
        assertTrue(r <= 1e18);
        assertTrue(g <= 1e18);
        assertTrue(b <= 1e18);
    }

    /// @notice Test that values are within bounds for all positions when read
    /// from the ``Jet'' segment data.
    /// @param _position Position in the colormap.
    function test_getValue_FromJetSegmentData_ValueIsWithinBounds(
        uint256 _position
    ) public {
        _position = bound(_position, 0, 1e18);

        (uint256 r, uint256 g, uint256 b) = colormapRegistry.getValue(
            JET_HASH,
            _position
        );
        assertTrue(r <= 1e18);
        assertTrue(g <= 1e18);
        assertTrue(b <= 1e18);
    }

    // -------------------------------------------------------------------------
    // Get value as hexstring
    // -------------------------------------------------------------------------

    /// @notice Test that the colormap hash must exist.
    /// @param _hash Hash of some nonexistant colormap.
    function test_getValueAsHexString_ColormapHashDoesntExist_Fails(
        bytes8 _hash
    ) public {
        vm.assume(
            _hash != SPRING_HASH && _hash != gnuPlotHash && _hash != JET_HASH
        );

        // Expect revert because the colormap hash doesn't exist.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapDoesNotExist.selector,
                _hash
            )
        );
        colormapRegistry.getValueAsHexString(_hash, 0);
    }

    /// @notice Test that all positions pass when read from a palette generator.
    /// @param _position Position in the colormap.
    function test_getValueAsHexString_FromPaletteGenerator_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsHexString(gnuPlotHash, _position);
    }

    /// @notice Test that all positions pass when read from the ``Spring''
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsHexString_FromSpringSegmentData_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsHexString(SPRING_HASH, _position);
    }

    /// @notice Test that all positions pass when read from the ``Jet''
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsHexString_FromJetSegmentData_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsHexString(JET_HASH, _position);
    }

    // -------------------------------------------------------------------------
    // Get value as `uint8`
    // -------------------------------------------------------------------------

    /// @notice Test that the colormap hash must exist.
    /// @param _hash Hash of some nonexistant colormap.
    function test_getValueAsUint8_ColormapHashDoesntExist_Fails(
        bytes8 _hash
    ) public {
        vm.assume(
            _hash != SPRING_HASH && _hash != gnuPlotHash && _hash != JET_HASH
        );

        // Expect revert because the colormap hash doesn't exist.
        vm.expectRevert(
            abi.encodeWithSelector(
                IColormapRegistry.ColormapDoesNotExist.selector,
                _hash
            )
        );
        colormapRegistry.getValueAsUint8(_hash, 0);
    }

    /// @notice Test that all positions pass when read from a palette generator.
    /// @param _position Position in the colormap.
    function test_getValueAsUint8_FromPaletteGenerator_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsUint8(gnuPlotHash, _position);
    }

    /// @notice Test that all positions pass when read from the ``Spring''
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsUint8_FromSpringSegmentData_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsUint8(SPRING_HASH, _position);
    }

    /// @notice Test that all positions pass when read from the ``Jet''
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsUint8_FromJetSegmentData_PassesAllPositions(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsUint8(JET_HASH, _position);
    }
}
