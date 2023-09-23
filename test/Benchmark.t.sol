// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {BaseTest} from "./utils/BaseTest.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";
import {IPaletteGenerator} from "@/contracts/interfaces/IPaletteGenerator.sol";

/// @notice Benchmark tests for {ColormapRegistry}.
/// @dev For all read functions reading from a palette generator, the palette
/// generator that's used is the one for the `gnuplot` colormap. For all read
/// functions reading from segment data, the segment data that's used is the one
/// for the ``Jet'' colormap.
contract BenchmarkTest is BaseTest {
    /// @notice Benchmark for {ColormapRegistry.batchRegister} via palette
    /// generator.
    function test_batchRegister_ViaPaletteGenerator() public {
        IPaletteGenerator[] memory paletteGenerators = new IPaletteGenerator[](
            1
        );
        paletteGenerators[0] = samplePaletteGenerator;
        colormapRegistry.batchRegister(paletteGenerators);
    }

    /// @notice Benchmark for {ColormapRegistry.batchRegister} via segment data.
    function test_batchRegister_ViaSegmentData() public {
        // Initialize a simple, valid segment data.
        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = SIMPLE_VALID_SEGMENT;
        segmentData.g = SIMPLE_VALID_SEGMENT;
        segmentData.b = SIMPLE_VALID_SEGMENT;

        IColormapRegistry.SegmentData[]
            memory segmentDataArray = new IColormapRegistry.SegmentData[](1);
        segmentDataArray[0] = segmentData;

        colormapRegistry.batchRegister(segmentDataArray);
    }

    /// @notice Benchmark for {ColormapRegistry.register} via palette generator.
    function test_register_ViaPaletteGenerator() public {
        colormapRegistry.register(samplePaletteGenerator);
    }

    /// @notice Benchmark for {ColormapRegistry.register} via segment data.
    function test_register_ViaSegmentData() public {
        // Initialize a simple, valid segment data.
        IColormapRegistry.SegmentData memory segmentData;
        segmentData.r = SIMPLE_VALID_SEGMENT;
        segmentData.g = SIMPLE_VALID_SEGMENT;
        segmentData.b = SIMPLE_VALID_SEGMENT;

        colormapRegistry.register(segmentData);
    }

    /// @notice Benchmark for {ColormapRegistry.getValue} read from a palette
    /// generator.
    /// @param _position Position in the colormap.
    function test_getValue_FromPaletteGenerator(uint256 _position) public view {
        _position = bound(_position, 0, 1e18);

        colormapRegistry.getValue(gnuPlotHash, _position);
    }

    /// @notice Benchmark for {ColormapRegistry.getValue} read from segment
    /// data.
    /// @param _position Position in the colormap.
    function test_getValue_FromSegmentData(uint256 _position) public view {
        _position = bound(_position, 0, 1e18);

        colormapRegistry.getValue(JET_HASH, _position);
    }

    /// @notice Benchmark for {ColormapRegistry.getValueAsUint8} read from a
    /// palette generator.
    /// @param _position Position in the colormap.
    function test_getValueAsUint8_FromPaletteGenerator(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsUint8(gnuPlotHash, _position);
    }

    /// @notice Benchmark for {ColormapRegistry.getValueAsUint8} read from
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsUint8_FromSegmentData(uint8 _position) public view {
        colormapRegistry.getValueAsUint8(JET_HASH, _position);
    }

    /// @notice Benchmark for {ColormapRegistry.getValueAsHexString} read from a
    /// palette
    /// generator.
    /// @param _position Position in the colormap.
    function test_getValueAsHexString_FromPaletteGenerator(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsHexString(gnuPlotHash, _position);
    }

    /// @notice Benchmark for {ColormapRegistry.getValueAsHexString} read from
    /// segment data.
    /// @param _position Position in the colormap.
    function test_getValueAsHexString_FromSegmentData(
        uint8 _position
    ) public view {
        colormapRegistry.getValueAsHexString(JET_HASH, _position);
    }
}
