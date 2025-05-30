// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract PayProposerProperties is BaseProperties {
    function payProposer(
        bytes memory pubkey
    ) external payable {
        // Pre-conditions
        bool pubKeyInvalid = pubkey.length != 48;
        bool isNoEthPayable = msg.value == 0;

        // Action
        try primev.rewardManager.payProposer{ value: msg.value }(pubkey) {
            // Post-conditions
            t(!pubKeyInvalid, "RME01"); // Invalid key should revert
            t(!isNoEthPayable, "RME02"); // Zero value should revert
        } catch {
            assert(pubKeyInvalid || isNoEthPayable);
        }
    }
}
