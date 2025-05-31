// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IVanillaRegistry } from "src/interfaces/IVanillaRegistry.sol";
import { BlockHeightOccurrence } from "src/utils/Occurrence.sol";

contract VanillaRegistryMock {
    uint256 public maxValidators;
    uint256 public validatorCount;
    mapping(bytes pubkey => IVanillaRegistry.StakedValidator) validators;

    constructor(
        uint256 maxValidators_
    ) {
        maxValidators = maxValidators_;
    }

    function register(bytes memory pubkey, address withdrawalAddress, uint256 balance, uint256 blockHeight) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(validatorCount <= maxValidators, "max validators reached");
        require(!validators[pubkey].exists, "pubkey exists");

        // Add record
        validators[pubkey] = IVanillaRegistry.StakedValidator({
            exists: true,
            withdrawalAddress: withdrawalAddress,
            balance: balance,
            unstakeOccurrence: BlockHeightOccurrence.Occurrence({ exists: true, blockHeight: blockHeight })
        });
        validatorCount += 1;
    }

    function unregister(
        bytes memory pubkey
    ) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(validators[pubkey].exists, "pubkey not exists");
        validatorCount -= 1;
        validators[pubkey].exists = false;
        validators[pubkey].withdrawalAddress = address(0);
    }

    function stakedValidators(
        bytes memory pubkey
    ) external view returns (IVanillaRegistry.StakedValidator memory validator) {
        validator = validators[pubkey];
    }
}
