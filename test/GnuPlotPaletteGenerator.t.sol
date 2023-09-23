// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { Test } from "forge-std/Test.sol";

import { GnuPlotPaletteGenerator } from "@/contracts/GnuPlotPaletteGenerator.sol";
import { IPaletteGenerator } from "@/contracts/interfaces/IPaletteGenerator.sol";

/// @notice Unit tests for {GnuPlotPaletteGenerator}.
/// @dev These unit tests should pass for all implementations of
/// {IPaletteGenerator}.
contract GnuPlotPaletteGeneratorTest is Test {
    // -------------------------------------------------------------------------
    // Contracts
    // -------------------------------------------------------------------------

    /// @notice The `gnuplot` palette generator contract.
    GnuPlotPaletteGenerator public gnuPlotPaletteGenerator;

    // -------------------------------------------------------------------------
    // Setup
    // -------------------------------------------------------------------------

    /// @notice Set up the test contract by deploying an instance of
    /// {GnuPlotPaletteGenerator}.
    function setUp() public {
        gnuPlotPaletteGenerator = new GnuPlotPaletteGenerator();
    }

    // -------------------------------------------------------------------------
    // Tests
    // -------------------------------------------------------------------------

    /// @notice Test that querying the red portion of the colormap with a
    /// position greater than 1e18 fails.
    /// @param _position Position in the colormap.
    function test_r_PositionGreaterThanE18_Fails(uint256 _position) public {
        vm.assume(_position > 1e18);

        // Expect revert because `_position` is greater than 1e18.
        vm.expectRevert(
            abi.encodeWithSelector(IPaletteGenerator.InvalidPosition.selector, _position)
        );
        gnuPlotPaletteGenerator.r(_position);
    }

    /// @notice Test that querying the red portion of the colormap yields a 18
    /// decimal fixed-point number in [0, 1].
    /// @param _position Position in the colormap.
    function test_r(uint256 _position) public {
        _position = bound(_position, 0, 1e18);

        uint256 value = gnuPlotPaletteGenerator.r(_position);
        assertTrue(value <= 1e18);
    }

    /// @notice Test that querying the green portion of the colormap with a
    /// position greater than 1e18 fails.
    /// @param _position Position in the colormap.
    function test_g_PositionGreaterThanE18_Fails(uint256 _position) public {
        vm.assume(_position > 1e18);

        // Expect revert because `_position` is greater than 1e18.
        vm.expectRevert(
            abi.encodeWithSelector(IPaletteGenerator.InvalidPosition.selector, _position)
        );
        gnuPlotPaletteGenerator.g(_position);
    }

    /// @notice Test that querying the green portion of the colormap yields a 18
    /// decimal fixed-point number in [0, 1].
    /// @param _position Position in the colormap.
    function test_g(uint256 _position) public {
        _position = bound(_position, 0, 1e18);

        uint256 value = gnuPlotPaletteGenerator.g(_position);
        assertTrue(value <= 1e18);
    }

    /// @notice Test that querying the blue portion of the colormap with a
    /// position greater than 1e18 fails.
    /// @param _position Position in the colormap.
    function test_b_PositionGreaterThanE18_Fails(uint256 _position) public {
        vm.assume(_position > 1e18);

        // Expect revert because `_position` is greater than 1e18.
        vm.expectRevert(
            abi.encodeWithSelector(IPaletteGenerator.InvalidPosition.selector, _position)
        );
        gnuPlotPaletteGenerator.b(_position);
    }

    /// @notice Test that querying the blue portion of the colormap yields a 18
    /// decimal fixed-point number in [0, 1].
    /// @param _position Position in the colormap.
    function test_b(uint256 _position) public {
        _position = bound(_position, 0, 1e18);

        uint256 value = gnuPlotPaletteGenerator.b(_position);
        assertTrue(value <= 1e18);
    }
}
