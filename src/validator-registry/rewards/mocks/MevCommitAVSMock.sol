// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IMevCommitAVS } from "src/interfaces/IMevCommitAVS.sol";
import { BlockHeightOccurrence } from "src/utils/Occurrence.sol";

contract MevCommitAVSMock {
    mapping(bytes pubkey => IMevCommitAVS.ValidatorRegistrationInfo) public validatorRegistrations;

    function register(bytes memory pubkey, bool exists, address podOwner) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(!validatorRegistrations[pubkey].exists, "pubkey exists");

        // Add record
        validatorRegistrations[pubkey] = IMevCommitAVS.ValidatorRegistrationInfo({
            exists: exists,
            podOwner: podOwner,
            freezeOccurrence: BlockHeightOccurrence.Occurrence({ exists: true, blockHeight: 0 }),
            deregRequestOccurrence: BlockHeightOccurrence.Occurrence({ exists: true, blockHeight: 0 })
        });
    }
}
