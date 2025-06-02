// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IMevCommitMiddleware } from "src/interfaces/IMevCommitMiddleware.sol";
import { TimestampOccurrence } from "src/utils/Occurrence.sol";

contract MevCommitMiddlewareMock {
    mapping(bytes pubkey => IMevCommitMiddleware.ValidatorRecord) public validatorRecords;

    function register(bytes memory pubkey, bool exists, address operator) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(!validatorRecords[pubkey].exists, "pubkey exists");

        // Add record
        validatorRecords[pubkey] = IMevCommitMiddleware.ValidatorRecord({
            exists: exists,
            vault: address(0),
            operator: operator,
            deregRequestOccurrence: TimestampOccurrence.Occurrence({ exists: true, timestamp: 0 })
        });
    }
}
