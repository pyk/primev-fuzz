// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { PayProposerProperties } from "./properties/PayProposer.sol";

contract Fuzz is PayProposerProperties {
    constructor() {
        primev = deployContracts();
    }
}
