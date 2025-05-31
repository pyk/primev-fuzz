// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract RemoveOverrideAddressProperties is BaseProperties {
    struct RemoveOverrideAddressVars {
        address receiver;
        address existingOverrideAddress;
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
        s.receiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);
        s.overrideUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.existingOverrideAddress);
    }

    /// @custom:property ROAE01 If there is no existing override address, the override address removal will be failed
    /// @custom:property ROAE02 If contract is paused, the override address removal will be failed
    /// @custom:property ROAS01 If migrateExistingRewards=true, the unclaimed reward of removed override address will be moved to the receiver
    /// @custom:property ROAS02 If migrateExistingRewards=false, the unclaimed reward of removed override address and receiver address will be the same as before override address operation
    /// @custom:property ROAS03 After override address is removed, the overide address of receiver will be zero address
    function removeOverrideAddress(bytes memory pubkey, bool migrateExistingRewards) external {
        // Pre-conditions
        RemoveOverrideAddressVars memory vars;
        address receiver = primev.rewardManager.findReceiver(pubkey);
        if (receiver == address(0)) return;
        vars.receiver = receiver;
        vars.migrateExistingRewards = migrateExistingRewards;
        vars.existingOverrideAddress = primev.rewardManager.overrideAddresses(vars.receiver);

        RemoveOverrideAddressSnapshot memory pre = removeOverrideAddressSnapshot(vars);
        bool isNoOverriddenAddressToRemove = vars.existingOverrideAddress == address(0);
        bool isPaused = primev.rewardManager.paused();

        // Action
        vm.prank(receiver);
        try primev.rewardManager.removeOverrideAddress(migrateExistingRewards) {
            RemoveOverrideAddressSnapshot memory post = removeOverrideAddressSnapshot(vars);

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

            t(post.overrideAddress == address(0), "ROAS03"); // overrideAddresses should be set to zero
        } catch {
            assert(isNoOverriddenAddressToRemove || isPaused);
        }
    }
}
