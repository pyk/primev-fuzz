// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract AutoClaimProperties is BaseProperties {
    struct AutoClaimVars {
        bytes pubkey;
        address receiver;
    }

    function enableAutoClaim(uint256 pubkeyId, bool claimExistingRewards) external {
        AutoClaimVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];

        // Pre-conditions
        if (primev.rewardManager.paused()) return;

        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.enableAutoClaim(claimExistingRewards) {
            // Post-conditions
            expectedAutoClaim[vars.receiver] = true;
            if (claimExistingRewards) {
                expectedUnclaimedRewards[vars.receiver] -= unclaimedRewards;
                expectedTotalUnclaimedRewards -= unclaimedRewards;
            }
        } catch {
            assert(false);
        }
    }

    function disableAutoClaim(
        uint256 pubkeyId
    ) external {
        AutoClaimVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];

        // Pre-conditions
        if (primev.rewardManager.paused()) return;

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.disableAutoClaim() {
            // Post-conditions
            expectedAutoClaim[vars.receiver] = false;
        } catch {
            assert(false);
        }
    }
}
