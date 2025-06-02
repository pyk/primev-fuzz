// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract PayProposerProperties is BaseProperties {
    struct PayProposerVars {
        bytes pubkey;
        uint256 amountIn;
        address receiver;
        address overrideAddress;
    }

    struct PayProposerSnapshot {
        uint256 pubkeyOrphanedRewards;
        uint256 receiverUnclaimedRewards;
        uint256 overrideUnclaimedRewards;
    }

    function payProposerSnapshot(
        PayProposerVars memory vars
    ) internal view returns (PayProposerSnapshot memory s) {
        s.pubkeyOrphanedRewards = primev.rewardManager.orphanedRewards(vars.pubkey);
        s.receiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);
        s.overrideUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.overrideAddress);
    }

    /// @custom:property PPS01 If pubkey exists and auto claim not enabled, receiver or override should receive unclaimed rewards
    /// @custom:property PPS02 If pubkey not exists, orphaned rewards for the pubkey should increased
    function payProposer(
        uint256 pubkeyId
    ) external payable {
        bytes memory pubkey = getPubkey(pubkeyId);
        // Pre-conditions
        PayProposerVars memory vars;
        vars.pubkey = pubkey;
        vars.amountIn = msg.value;
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = expectedOverrideAddress[vars.receiver];

        if (vars.amountIn == 0) return;

        PayProposerSnapshot memory pre = payProposerSnapshot(vars);

        // Action
        try primev.rewardManager.payProposer{ value: vars.amountIn }(pubkey) {
            PayProposerSnapshot memory post = payProposerSnapshot(vars);

            // Post-conditions
            if (pubkeyExists[vars.pubkey]) {
                expectedTotalUnclaimedRewards += vars.amountIn;
                if (vars.overrideAddress == address(0)) {
                    t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards + vars.amountIn, "PPS01_1");
                    expectedUnclaimedRewards[vars.receiver] += vars.amountIn;
                } else {
                    t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards + vars.amountIn, "PPS01_2");
                    expectedUnclaimedRewards[vars.overrideAddress] += vars.amountIn;
                }
            } else {
                t(post.pubkeyOrphanedRewards == pre.pubkeyOrphanedRewards + vars.amountIn, "PPS02");
                expectedTotalOrphanedRewards += vars.amountIn;
                expectedOrphanedRewards[pubkey] += vars.amountIn;
            }
        } catch {
            assert(false);
        }
    }
}
