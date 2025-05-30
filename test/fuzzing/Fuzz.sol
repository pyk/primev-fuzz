// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { MockProperties } from "./properties/Mock.sol";
import { PayProposerProperties } from "./properties/PayProposer.sol";

contract Fuzz is MockProperties, PayProposerProperties {
    constructor() {
        primev = deployContracts();
    }
}
