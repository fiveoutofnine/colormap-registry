// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface ICreate2Factory {
    function safeCreate2(bytes32, bytes memory) external;
}
