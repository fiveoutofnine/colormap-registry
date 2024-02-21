// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { Script } from "forge-std/Script.sol";

import { ColormapRegistry } from "@/contracts/ColormapRegistry.sol";
import { IColormapRegistry } from "@/contracts/interfaces/IColormapRegistry.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract AddColormapsToRegistryScript is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice Address of the colormap registry on Ethereum mainnet.
    address constant COLORMAP_REGISTRY = 0x00000000A84FcdF3E9C165e6955945E87dA2cB0D;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        vm.startBroadcast();

        ColormapRegistry colormapRegistry = ColormapRegistry(COLORMAP_REGISTRY);

        // ---------------------------------------------------------------------
        // Start of code generated by `generate_cmaps.py`.
        // ---------------------------------------------------------------------

        IColormapRegistry.SegmentData[] memory segmentDataArray =
            new IColormapRegistry.SegmentData[](17);

        // ``CMRmap'' colormap.
        segmentDataArray[0].r = 0xFFFFFFDFE5E5BFE5E59FE5E57FFFFF5F99993F4C4C1F2626000000;
        segmentDataArray[0].g = 0xFFFFFFDFE5E5BFBFBF9F7F7F7F3F3F5F33333F26261F2626000000;
        segmentDataArray[0].b = 0xFFFFFFDF7F7FBF19199F00007F26265F7F7F3FBFBF1F7F7F000000;

        // ``Wistia'' colormap.
        segmentDataArray[1].r = 0xFFFCFCBFFFFF7FFFFF3FFFFF00E4E4;
        segmentDataArray[1].g = 0xFF7F7FBFA0A07FBDBD3FE8E800FFFF;
        segmentDataArray[1].b = 0xFF0000BF00007F00003F1A1A007A7A;

        // ``autumn'' colormap.
        segmentDataArray[2].r = 0xFFFFFF00FFFF;
        segmentDataArray[2].g = 0xFFFFFF000000;
        segmentDataArray[2].b = 0xFF0000000000;

        // ``binary'' colormap.
        segmentDataArray[3].r = 0xFF000000FFFF;
        segmentDataArray[3].g = 0xFF000000FFFF;
        segmentDataArray[3].b = 0xFF000000FFFF;

        // ``bone'' colormap.
        segmentDataArray[4].r = 0xFFFFFFBEA6A6000000;
        segmentDataArray[4].g = 0xFFFFFFBEC6C65D5151000000;
        segmentDataArray[4].b = 0xFFFFFF5D7171000000;

        // ``cool'' colormap.
        segmentDataArray[5].r = 0xFFFFFF000000;
        segmentDataArray[5].g = 0xFF000000FFFF;
        segmentDataArray[5].b = 0xFFFFFF00FFFF;

        // ``copper'' colormap.
        segmentDataArray[6].r = 0xFFFFFFCEFFFF000000;
        segmentDataArray[6].g = 0xFFC7C7000000;
        segmentDataArray[6].b = 0xFF7E7E000000;

        // ``gist_rainbow'' colormap.
        segmentDataArray[7].r = 0xFFFFFFF3FFFFC4000095000066000036FFFF07FFFF00FFFF;
        segmentDataArray[7].g = 0xFF0000F30000C4000095FFFF66FFFF36FFFF070000000000;
        segmentDataArray[7].b = 0xFFBFBFF3FFFFC4FFFF95FFFF660000360000070000002828;

        // ``gist_stern'' colormap.
        segmentDataArray[8].r = 0xFFFFFF3F063F0DFFFF000000;
        segmentDataArray[8].g = 0xFFFFFF000000;
        segmentDataArray[8].b = 0xFFFFFFBB00007FFFFF000000;

        // ``gray'' colormap.
        segmentDataArray[9].r = 0xFFFFFF000000;
        segmentDataArray[9].g = 0xFFFFFF000000;
        segmentDataArray[9].b = 0xFFFFFF000000;

        // ``hot'' colormap.
        segmentDataArray[10].r = 0xFFFFFF5DFFFF000A0A;
        segmentDataArray[10].g = 0xFFFFFFBEFFFF5D0000000000;
        segmentDataArray[10].b = 0xFFFFFFBE0000000000;

        // ``hsv'' colormap.
        segmentDataArray[11].r = 0xFFFFFFDAFFFFD6F7F7AE0707AA00005900005407072CF7F728FFFF00FFFF;
        segmentDataArray[11].g = 0xFF0000AE0000AA0F0F81FFFF2CFFFF28EFEF000000;
        segmentDataArray[11].b = 0xFF1717DAEFEFD6FFFF81FFFF590F0F540000000000;

        // ``jet'' colormap.
        segmentDataArray[12].r = 0xFF7F7FE2FFFFA8FFFF590000000000;
        segmentDataArray[12].g = 0xFF0000E80000A3FFFF5FFFFF1F0000000000;
        segmentDataArray[12].b = 0xFF0000A5000056FFFF1CFFFF007F7F;

        // ``spring'' colormap.
        segmentDataArray[13].r = 0xFFFFFF00FFFF;
        segmentDataArray[13].g = 0xFFFFFF000000;
        segmentDataArray[13].b = 0xFF000000FFFF;

        // ``summer'' colormap.
        segmentDataArray[14].r = 0xFFFFFF000000;
        segmentDataArray[14].g = 0xFFFFFF007F7F;
        segmentDataArray[14].b = 0xFF6666006666;

        // ``terrain'' colormap.
        segmentDataArray[15].r = 0xFFFFFFBF7F7F7FFFFF3F0000260000003333;
        segmentDataArray[15].g = 0xFFFFFFBF5B5B7FFFFF3FCCCC269999003333;
        segmentDataArray[15].b = 0xFFFFFFBF54547F99993F666626FFFF009999;

        // ``winter'' colormap.
        segmentDataArray[16].r = 0xFF0000000000;
        segmentDataArray[16].g = 0xFFFFFF000000;
        segmentDataArray[16].b = 0xFF7F7F00FFFF;

        // ``base-chain'' colormap.
        segmentDataArray[17].r = 0xFFFFFF000000;
        segmentDataArray[17].g = 0xFFFFFF00FF52;
        segmentDataArray[17].b = 0xFFFFFF00FFFF;

        colormapRegistry.batchRegister(segmentDataArray);

        // ---------------------------------------------------------------------
        // End of code generated by `generate_cmaps.py`.
        // ---------------------------------------------------------------------

        vm.stopBroadcast();
    }
}
