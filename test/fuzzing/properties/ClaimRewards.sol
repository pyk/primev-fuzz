// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract ClaimRewardsProperties is BaseProperties {
    struct ClaimRewardsVars {
        bytes pubkey;
        address receiver;
        address overrideAddress;
        address claimer;
    }

    function claimRewards(uint256 pubkeyId, bool useOverride) external payable {
        ClaimRewardsVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = expectedOverrideAddress[vars.receiver];

        // Pre-conditions
        if (primev.rewardManager.paused()) return;
        if (useOverride && vars.overrideAddress == address(0)) return;

        vars.claimer = vars.receiver;
        if (useOverride) {
            vars.claimer = vars.overrideAddress;
        }

        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.claimer);

        // Action
        vm.prank(vars.claimer);
        try primev.rewardManager.claimRewards() {
            // Post-conditions
            expectedUnclaimedRewards[vars.claimer] -= unclaimedRewards;
            expectedTotalUnclaimedRewards -= unclaimedRewards;
        } catch {
            assert(false);
        }
    }
}
