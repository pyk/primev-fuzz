// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IVanillaRegistry } from "src/interfaces/IVanillaRegistry.sol";
import { BlockHeightOccurrence } from "src/utils/Occurrence.sol";

contract VanillaRegistryMock {
    mapping(bytes pubkey => IVanillaRegistry.StakedValidator) public stakedValidators;

    constructor() { }

    function register(bytes memory pubkey, bool exists, address withdrawalAddress) external {
        require(pubkey.length == 48, "invalid pubkey");
        require(!stakedValidators[pubkey].exists, "pubkey exists");

        // Add record
        stakedValidators[pubkey] = IVanillaRegistry.StakedValidator({
            exists: exists,
            withdrawalAddress: withdrawalAddress,
            balance: 0,
            unstakeOccurrence: BlockHeightOccurrence.Occurrence({ exists: true, blockHeight: 0 })
        });
    }
}
