// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IMevCommitMiddleware } from "src/interfaces/IMevCommitMiddleware.sol";
import { TimestampOccurrence } from "src/utils/Occurrence.sol";

contract MevCommitMiddlewareMock {
    uint256 public maxValidators;
    uint256 public validatorCount;
    mapping(bytes pubkey => IMevCommitMiddleware.ValidatorRecord) records;
    bytes[] pubkeys;

    constructor(
        uint256 maxValidators_
    ) {
        maxValidators = maxValidators_;
        pubkeys = new bytes[](maxValidators);
    }

    function register(bytes memory pubkey, address vault, address operator, uint256 timestamp) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(validatorCount <= maxValidators, "max validators reached");
        require(!records[pubkey].exists, "pubkey exists");

        // Add record
        pubkeys.push(pubkey);
        records[pubkey] = IMevCommitMiddleware.ValidatorRecord({
            exists: true,
            vault: vault,
            operator: operator,
            deregRequestOccurrence: TimestampOccurrence.Occurrence({ exists: true, timestamp: timestamp })
        });
        validatorCount += 1;
    }

    function validatorRecords(
        bytes memory pubkey
    ) external view returns (IMevCommitMiddleware.ValidatorRecord memory record) {
        record = records[pubkey];
    }
}
