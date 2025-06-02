// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract OverrideReceiverProperties is BaseProperties {
    struct OverrideReceiverVars {
        bytes pubkey;
        address receiver;
        address overrideAddress;
    }

    function overrideReceiver(uint256 pubkeyId, uint256 overrideAddressId, bool migrateExistingRewards) external {
        OverrideReceiverVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = getOverrideAddress(overrideAddressId);

        // Pre-conditions
        if (vars.overrideAddress == address(0)) return;
        if (primev.rewardManager.paused()) return;

        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.overrideReceiver(vars.overrideAddress, migrateExistingRewards) {
            // Post-conditions
            expectedOverrideAddress[vars.receiver] = vars.overrideAddress;

            if (migrateExistingRewards) {
                expectedUnclaimedRewards[vars.receiver] -= unclaimedRewards;
                expectedUnclaimedRewards[vars.overrideAddress] += unclaimedRewards;
            }
        } catch {
            assert(false);
        }
    }

    struct RemoveOverrideAddressVars {
        bytes pubkey;
        address receiver;
        address overrideAddress;
    }

    function removeOverrideAddress(uint256 pubkeyId, bool migrateExistingRewards) external {
        RemoveOverrideAddressVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = expectedOverrideAddress[vars.receiver];

        // Pre-conditions
        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.overrideAddress);

        if (vars.overrideAddress == address(0)) return;
        if (primev.rewardManager.paused()) return;

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.removeOverrideAddress(migrateExistingRewards) {
            // Post-conditions
            t(!isNoOverriddenAddressToRemove, "ROAE01"); // If no overrideAddress, then it should revert
            t(!isPaused, "ROAE02"); // If contract is paused, then it should revert

            if (vars.migrateExistingRewards) {
                t(post.overrideUnclaimedRewards == 0, "ROAS01");
                t(
                    post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards + pre.overrideUnclaimedRewards,
                    "ROAS01"
                );
            } else {
                t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards, "ROAS02");
                t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "ROAS02");
            }
        } catch {
            assert(false);
        }
    }
}
