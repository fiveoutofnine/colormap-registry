// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";

import {ColormapRegistry} from "@/contracts/ColormapRegistry.sol";
import {IColormapRegistry} from "@/contracts/interfaces/IColormapRegistry.sol";

/// @notice A script to deploy {ColormapRegistry}.
contract AddColormapsToRegistryScript is Script {
    // -------------------------------------------------------------------------
    // Deploy addresses
    // -------------------------------------------------------------------------

    /// @notice Address of the colormap registry.
    address constant COLORMAP_REGISTRY =
        0x0000000012883D1da628e31c0FE52e35DcF95D50;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice See description for {DeployScript}.
    function run() public virtual {
        vm.startBroadcast();

        ColormapRegistry colormapRegistry = ColormapRegistry(COLORMAP_REGISTRY);

        // Add ``CMRmap'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory CMRmapSegmentData;
            CMRmapSegmentData
                .r = 0xFFFFFFDFE5E5BFE5E59FE5E57FFFFF5F99993F4C4C1F2626000000;
            CMRmapSegmentData
                .g = 0xFFFFFFDFE5E5BFBFBF9F7F7F7F3F3F5F33333F26261F2626000000;
            CMRmapSegmentData
                .b = 0xFFFFFFDF7F7FBF19199F00007F26265F7F7F3FBFBF1F7F7F000000;
            colormapRegistry.register(CMRmapSegmentData);
        }

        // Add ``Wistia'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory WistiaSegmentData;
            WistiaSegmentData.r = 0xFFFCFCBFFFFF7FFFFF3FFFFF00E4E4;
            WistiaSegmentData.g = 0xFF7F7FBFA0A07FBDBD3FE8E800FFFF;
            WistiaSegmentData.b = 0xFF0000BF00007F00003F1A1A007A7A;
            colormapRegistry.register(WistiaSegmentData);
        }

        // Add ``autumn'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory autumnSegmentData;
            autumnSegmentData.r = 0xFFFFFF00FFFF;
            autumnSegmentData.g = 0xFFFFFF000000;
            autumnSegmentData.b = 0xFF0000000000;
            colormapRegistry.register(autumnSegmentData);
        }

        // Add ``binary'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory binarySegmentData;
            binarySegmentData.r = 0xFF000000FFFF;
            binarySegmentData.g = 0xFF000000FFFF;
            binarySegmentData.b = 0xFF000000FFFF;
            colormapRegistry.register(binarySegmentData);
        }

        // Add ``bone'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory boneSegmentData;
            boneSegmentData.r = 0xFFFFFFBEA6A6000000;
            boneSegmentData.g = 0xFFFFFFBEC6C65D5151000000;
            boneSegmentData.b = 0xFFFFFF5D7171000000;
            colormapRegistry.register(boneSegmentData);
        }

        // Add ``cool'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory coolSegmentData;
            coolSegmentData.r = 0xFFFFFF000000;
            coolSegmentData.g = 0xFF000000FFFF;
            coolSegmentData.b = 0xFFFFFF00FFFF;
            colormapRegistry.register(coolSegmentData);
        }

        // Add ``copper'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory copperSegmentData;
            copperSegmentData.r = 0xFFFFFFCEFFFF000000;
            copperSegmentData.g = 0xFFC7C7000000;
            copperSegmentData.b = 0xFF7E7E000000;
            colormapRegistry.register(copperSegmentData);
        }

        // Add ``gist_rainbow'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory gist_rainbowSegmentData;
            gist_rainbowSegmentData
                .r = 0xFFFFFFF3FFFFC4000095000066000036FFFF07FFFF00FFFF;
            gist_rainbowSegmentData
                .g = 0xFF0000F30000C4000095FFFF66FFFF36FFFF070000000000;
            gist_rainbowSegmentData
                .b = 0xFFBFBFF3FFFFC4FFFF95FFFF660000360000070000002828;
            colormapRegistry.register(gist_rainbowSegmentData);
        }

        // Add ``gist_stern'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory gist_sternSegmentData;
            gist_sternSegmentData.r = 0xFFFFFF3F063F0DFFFF000000;
            gist_sternSegmentData.g = 0xFFFFFF000000;
            gist_sternSegmentData.b = 0xFFFFFFBB00007FFFFF000000;
            colormapRegistry.register(gist_sternSegmentData);
        }

        // Add ``gray'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory graySegmentData;
            graySegmentData.r = 0xFFFFFF000000;
            graySegmentData.g = 0xFFFFFF000000;
            graySegmentData.b = 0xFFFFFF000000;
            colormapRegistry.register(graySegmentData);
        }

        // Add ``hot'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory hotSegmentData;
            hotSegmentData.r = 0xFFFFFF5DFFFF000A0A;
            hotSegmentData.g = 0xFFFFFFBEFFFF5D0000000000;
            hotSegmentData.b = 0xFFFFFFBE0000000000;
            colormapRegistry.register(hotSegmentData);
        }

        // Add ``hsv'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory hsvSegmentData;
            hsvSegmentData
                .r = 0xFFFFFFDAFFFFD6F7F7AE0707AA00005900005407072CF7F728FFFF00FFFF;
            hsvSegmentData.g = 0xFF0000AE0000AA0F0F81FFFF2CFFFF28EFEF000000;
            hsvSegmentData.b = 0xFF1717DAEFEFD6FFFF81FFFF590F0F540000000000;
            colormapRegistry.register(hsvSegmentData);
        }

        // Add ``jet'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory jetSegmentData;
            jetSegmentData.r = 0xFF7F7FE2FFFFA8FFFF590000000000;
            jetSegmentData.g = 0xFF0000E80000A3FFFF5FFFFF1F0000000000;
            jetSegmentData.b = 0xFF0000A5000056FFFF1CFFFF007F7F;
            colormapRegistry.register(jetSegmentData);
        }

        // Add ``spring'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory springSegmentData;
            springSegmentData.r = 0xFFFFFF00FFFF;
            springSegmentData.g = 0xFFFFFF000000;
            springSegmentData.b = 0xFF000000FFFF;
            colormapRegistry.register(springSegmentData);
        }

        // Add ``summer'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory summerSegmentData;
            summerSegmentData.r = 0xFFFFFF000000;
            summerSegmentData.g = 0xFFFFFF007F7F;
            summerSegmentData.b = 0xFF6666006666;
            colormapRegistry.register(summerSegmentData);
        }

        // Add ``terrain'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory terrainSegmentData;
            terrainSegmentData.r = 0xFFFFFFBF7F7F7FFFFF3F0000260000003333;
            terrainSegmentData.g = 0xFFFFFFBF5B5B7FFFFF3FCCCC269999003333;
            terrainSegmentData.b = 0xFFFFFFBF54547F99993F666626FFFF009999;
            colormapRegistry.register(terrainSegmentData);
        }

        // Add ``winter'' colormap to the registry.
        {
            IColormapRegistry.SegmentData memory winterSegmentData;
            winterSegmentData.r = 0xFF0000000000;
            winterSegmentData.g = 0xFFFFFF000000;
            winterSegmentData.b = 0xFF7F7F00FFFF;
            colormapRegistry.register(winterSegmentData);
        }

        vm.stopBroadcast();
    }
}
