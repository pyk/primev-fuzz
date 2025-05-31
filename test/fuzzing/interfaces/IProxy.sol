// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

interface IProxy {
    function implementation() external returns (address);
}
