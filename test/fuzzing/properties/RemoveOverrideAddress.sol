// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract RemoveOverrideAddressProperties is BaseProperties {
    struct RemoveOverrideAddressVars {
        address receiver;
        bool migrateExistingRewards;
    }

    struct RemoveOverrideAddressSnapshot {
        address overrideAddress;
        uint256 overrideUnclaimedRewards;
        uint256 receiverUnclaimedRewards;
    }

    function removeOverrideAddressSnapshot(
        RemoveOverrideAddressVars memory vars
    ) internal view returns (RemoveOverrideAddressSnapshot memory s) {
        s.overrideAddress = primev.rewardManager.overrideAddresses(vars.receiver);

        s.overrideUnclaimedRewards = primev.rewardManager.unclaimedRewards(s.overrideAddress);
        s.receiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);
    }

    function removeOverrideAddress(bytes memory pubkey, bool migrateExistingRewards) external {
        // Pre-conditions
        RemoveOverrideAddressVars memory vars;
        address receiver = primev.rewardManager.findReceiver(pubkey);
        if (receiver == address(0)) return;
        vars.receiver = receiver;
        vars.migrateExistingRewards = migrateExistingRewards;

        RemoveOverrideAddressSnapshot memory pre = removeOverrideAddressSnapshot(vars);
        bool isNoOverriddenAddressToRemove = pre.overrideAddress == address(0);
        bool isPaused = primev.rewardManager.paused();

        // Action
        vm.prank(receiver);
        try primev.rewardManager.removeOverrideAddress(migrateExistingRewards) {
            RemoveOverrideAddressSnapshot memory post = removeOverrideAddressSnapshot(vars);

            // Post-conditions
            t(!isNoOverriddenAddressToRemove, "RMROA-E01"); // If no overrideAddress, then it should revert
            t(!isPaused, "RMROA-E02"); // Paused should revert

            t(post.overrideAddress == address(0), "RMROA-S01"); // overrideAddresses should be set to zero
            if (vars.migrateExistingRewards) {
                t(post.overrideUnclaimedRewards == 0, "RMROA-S02");
                t(post.receiverUnclaimedRewards == pre.overrideUnclaimedRewards, "RMROA-S03");
            } else {
                t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards, "RMROA-S04");
                t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "RMROA-S05");
            }
        } catch {
            assert(isNoOverriddenAddressToRemove || isPaused);
        }
    }
}
