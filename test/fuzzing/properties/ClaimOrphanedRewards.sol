// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract ClaimOrphanedRewardsProperties is BaseProperties {
    mapping(bytes => bool) claimOrphanedRewardsPubkeys;

    struct ClaimOrphanedRewardsVars {
        address toPay;
    }

    struct ClaimOrphanedRewardsSnapshot {
        uint256 toPayBalance;
    }

    function claimOrphanedRewardsSnapshot(
        ClaimOrphanedRewardsVars memory vars
    ) internal view returns (ClaimOrphanedRewardsSnapshot memory s) {
        s.toPayBalance = vars.toPay.balance;
    }

    /// @custom:property CORE01 If one of the pubkey have zero orphaned rewards, it will revert
    /// @custom:property CORE02 If toPay = reward manager address, it will revert
    /// @custom:property CORS01 After claim orphaned rewards, the toPay balance will increased by total orphaned rewards claimed
    /// @custom:property CORS02 After claim orphaned rewards, the orphaned rewards of pubkey is zero
    function claimOrphanedRewards(uint256 pubkeyId1, uint256 pubkeyId2, uint256 pubkeyId3) external {
        // Pre-conditions
        bytes memory pubkey1 = getPubkey(pubkeyId1);
        bytes memory pubkey2 = getPubkey(pubkeyId2);
        bytes memory pubkey3 = getPubkey(pubkeyId3);

        bytes[] memory pubkeyInputs = new bytes[](3);
        pubkeyInputs[0] = pubkey1;
        pubkeyInputs[1] = pubkey2;
        pubkeyInputs[2] = pubkey3;

        ClaimOrphanedRewardsVars memory vars;
        vars.toPay = primev.owner;

        bool isZeroOrphanedRewards = false;
        uint256 totalOrphanedRewards = 0;
        for (uint256 i = 0; i < pubkeyInputs.length; i++) {
            bytes memory pubkey = pubkeyInputs[i];
            if (claimOrphanedRewardsPubkeys[pubkey]) {
                isZeroOrphanedRewards = true;
                break;
            }
            uint256 amount = primev.rewardManager.orphanedRewards(pubkey);
            if (amount == 0) {
                isZeroOrphanedRewards = true;
                break;
            }
            totalOrphanedRewards += amount;
            claimOrphanedRewardsPubkeys[pubkey] = true;
        }

        ClaimOrphanedRewardsSnapshot memory pre = claimOrphanedRewardsSnapshot(vars);

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.claimOrphanedRewards(pubkeyInputs, vars.toPay) {
            // Post-conditions
            ClaimOrphanedRewardsSnapshot memory post = claimOrphanedRewardsSnapshot(vars);

            t(!isZeroOrphanedRewards, "CORE01"); // If there is zero unclaimed rewards, the operation should revert
            // t(!isToPayRewardManager, "CORE02"); // If there is zero unclaimed rewards, the operation should revert

            t(post.toPayBalance == pre.toPayBalance + totalOrphanedRewards, "CORS01");

            for (uint256 i = 0; i < pubkeyInputs.length; i++) {
                bytes memory pubkey = pubkeyInputs[0];
                uint256 amount = primev.rewardManager.orphanedRewards(pubkey);
                t(amount == 0, "CORS02");
            }
        } catch {
            assert(isZeroOrphanedRewards);
        }

        // Clean up
        for (uint256 i = 0; i < pubkeyInputs.length; i++) {
            bytes memory pubkey = pubkeyInputs[i];
            claimOrphanedRewardsPubkeys[pubkey] = false;
        }
    }
}
