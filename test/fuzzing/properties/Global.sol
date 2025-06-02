// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract GlobalProperties is BaseProperties {
    function property_RewardManager_balance() external view returns (bool) {
        uint256 balance = address(primev.rewardManager).balance;
        return balance == expectedTotalOrphanedRewards + expectedTotalUnclaimedRewards;
    }

    function property_UnclaimedRewards() external view returns (bool) {
        for (uint256 i = 0; i < pubkeys.length; i++) {
            address receiver = pubkeyReceivers[pubkeys[i]];
            uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(receiver);
            if (unclaimedRewards != expectedUnclaimedRewards[receiver]) {
                return false;
            }
        }

        for (uint256 i = 0; i < overrides.length; i++) {
            uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(overrides[i]);
            if (unclaimedRewards != expectedUnclaimedRewards[overrides[i]]) {
                return false;
            }
        }

        return true;
    }

    function property_OrphanedRewards() external view returns (bool) {
        for (uint256 i = 0; i < pubkeys.length; i++) {
            bytes memory pubkey = pubkeys[i];
            if (pubkeyExists[pubkey]) continue;
            uint256 rewards = primev.rewardManager.orphanedRewards(pubkey);
            if (rewards != expectedOrphanedRewards[pubkey]) {
                return false;
            }
        }

        return true;
    }
}
