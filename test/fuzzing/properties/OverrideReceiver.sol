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

    /// @custom:proeprty ORE01 If contract is paused, override receiver operation should failed
    /// @custom:property ORE02 If overrideAddress is zero address or same as receiver, override receiver operation should failed
    /// @custom:property ORS01 If migrateExistingRewards=true, the unclaimed rewards of receiver should be zero and the unclaimed rewards of overrideAddress should be increased exactly by the unclaimed rewards of receiver
    /// @custom:property ORS02 If migrateExistingRewards=false, the unclaimed rewards of receiver and override addres should be the same as before operations
    /// @custom:property ORS03 The overrideAddress of receiver should be updated
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
            t(!isPaused, "ORE01"); // Paused should revert
            t(!isInvalidAddress, "ORE02"); // Invalid address should revert

            if (vars.migrateExistingRewards) {
                t(post.receiverUnclaimedRewards == 0, "ORS01");
                t(
                    post.newReceiverUnclaimedRewards == pre.receiverUnclaimedRewards + pre.newReceiverUnclaimedRewards,
                    "ORS01"
                );
            } else {
                t(post.newReceiverUnclaimedRewards == pre.newReceiverUnclaimedRewards, "ORS02");
                t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "ORS02");
            }

            t(post.overrideAddress == overrideAddress, "ORS03"); // overrideAddresses should be set
        } catch {
            assert(isInvalidAddress || isPaused);
        }
    }
}
