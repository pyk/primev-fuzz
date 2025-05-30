// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { MockProperties } from "./properties/Mock.sol";
import { OverrideReceiverProperties } from "./properties/OverrideReceiver.sol";
import { PauseProperties } from "./properties/Pause.sol";
import { PayProposerProperties } from "./properties/PayProposer.sol";
import { RemoveOverrideAddressProperties } from "./properties/RemoveOverrideAddress.sol";

contract Fuzz is
    MockProperties,
    PauseProperties,
    OverrideReceiverProperties,
    RemoveOverrideAddressProperties,
    PayProposerProperties
{
    constructor() {
        primev = deployContracts();
    }
}
