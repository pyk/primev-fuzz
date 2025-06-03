// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract ClaimOrphanedRewardsProperties is BaseProperties {
    struct ClaimOrphanedRewardsVars {
        bytes pubkey;
    }

    function claimOrphanedRewards(
        uint256 pubkeyId
    ) external {
        ClaimOrphanedRewardsVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);

        // Pre-conditions
        if (pubkeyExists[vars.pubkey]) return;
        if (expectedOrphanedRewards[vars.pubkey] == 0) return;

        bytes[] memory inputs = new bytes[](1);
        inputs[0] = vars.pubkey;

        uint256 orphanedRewards = primev.rewardManager.orphanedRewards(vars.pubkey);

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.claimOrphanedRewards(inputs, primev.owner) {
            // Post-conditions
            expectedTotalOrphanedRewards -= orphanedRewards;
            expectedOrphanedRewards[vars.pubkey] -= orphanedRewards;
        } catch {
            assert(false);
        }
    }
}
