// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract OverrideReceiverProperties is BaseProperties {
    struct OverrideReceiverVars {
        address receiver;
        address newReceiver;
        bool migrateExistingRewards;
    }

    struct OverrideReceiverSnapshot {
        uint256 receiverUnclaimedRewards;
        uint256 newReceiverUnclaimedRewards;
        address overrideAddress;
    }

    function overrideReceiverSnapshot(
        OverrideReceiverVars memory vars
    ) internal view returns (OverrideReceiverSnapshot memory s) {
        s.receiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);
        s.newReceiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.newReceiver);
        s.overrideAddress = primev.rewardManager.overrideAddresses(vars.receiver);
    }

    function overrideReceiver(bytes memory pubkey, address overrideAddress, bool migrateExistingRewards) external {
        // Pre-conditions
        OverrideReceiverVars memory vars;
        address receiver = primev.rewardManager.findReceiver(pubkey);
        if (receiver == address(0)) return;
        vars.receiver = receiver;
        vars.newReceiver = overrideAddress;
        vars.migrateExistingRewards = migrateExistingRewards;

        bool isInvalidAddress = overrideAddress == address(0) || receiver == overrideAddress;
        bool isPaused = primev.rewardManager.paused();

        OverrideReceiverSnapshot memory pre = overrideReceiverSnapshot(vars);

        // Action
        vm.prank(receiver);
        try primev.rewardManager.overrideReceiver(overrideAddress, migrateExistingRewards) {
            OverrideReceiverSnapshot memory post = overrideReceiverSnapshot(vars);

            // Post-conditions
            t(!isInvalidAddress, "RMOR-E01"); // Invalid address should revert
            t(!isPaused, "RMOR-E02"); // Paused should revert

            t(post.overrideAddress == overrideAddress, "RMOR-S01"); // overrideAddresses should be set
            if (vars.migrateExistingRewards) {
                t(post.receiverUnclaimedRewards == 0, "RMOR-S02");
                t(post.newReceiverUnclaimedRewards == pre.receiverUnclaimedRewards, "RMOR-S03");
            } else {
                t(post.newReceiverUnclaimedRewards == pre.newReceiverUnclaimedRewards, "RMOR-S04");
                t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "RMOR-S05");
            }
        } catch {
            assert(isInvalidAddress || isPaused);
        }
    }
}
