// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IMevCommitAVS } from "src/interfaces/IMevCommitAVS.sol";
import { BlockHeightOccurrence } from "src/utils/Occurrence.sol";

contract MevCommitAVSMock {
    uint256 public maxValidators;
    uint256 public validatorCount;
    mapping(bytes pubkey => IMevCommitAVS.ValidatorRegistrationInfo) infos;

    constructor(
        uint256 maxValidators_
    ) {
        maxValidators = maxValidators_;
    }

    function register(
        bytes memory pubkey,
        address podOwner,
        uint256 freezeOccurrenceBlock,
        uint256 deregRequestOccurrenceBlock
    ) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(validatorCount <= maxValidators, "max validators reached");
        require(!infos[pubkey].exists, "pubkey exists");

        // Add record
        infos[pubkey] = IMevCommitAVS.ValidatorRegistrationInfo({
            exists: true,
            podOwner: podOwner,
            freezeOccurrence: BlockHeightOccurrence.Occurrence({ exists: true, blockHeight: freezeOccurrenceBlock }),
            deregRequestOccurrence: BlockHeightOccurrence.Occurrence({
                exists: true,
                blockHeight: deregRequestOccurrenceBlock
            })
        });
        validatorCount += 1;
    }

    function unregister(
        bytes memory pubkey
    ) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(infos[pubkey].exists, "pubkey is not exists");
        infos[pubkey].exists = false;
        infos[pubkey].podOwner = address(0);
        validatorCount -= 1;
    }

    function validatorRegistrations(
        bytes memory pubkey
    ) external view returns (IMevCommitAVS.ValidatorRegistrationInfo memory info) {
        info = infos[pubkey];
    }

    /// @dev Allows to receive random eth from fuzzing squence
    receive() external payable { }
}
