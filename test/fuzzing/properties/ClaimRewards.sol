// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract ClaimRewardsProperties is BaseProperties {
    struct ClaimRewardsVars {
        address claimer;
    }

    struct ClaimRewardsSnapshot {
        uint256 claimerBalance;
        uint256 unclaimedRewards;
    }

    function claimRewardsSnapshot(
        ClaimRewardsVars memory vars
    ) internal view returns (ClaimRewardsSnapshot memory s) {
        s.claimerBalance = vars.claimer.balance;
        s.unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.claimer);
    }

    /// @custom:property CRE01 If contract is paused, the operation will revert
    /// @custom:property CRE01 If claimer can't reveive ether, the operation will revert
    /// @custom:property CRS01 After claim rewards, the balance of claimer will be increased exactly by the unclaimed rewards amount
    /// @custom:property CRS02 After claim rewards, the unclaimed rewards of claimer is zero
    function claimRewards(
        uint256 claimerId
    ) external payable {
        // Pre-conditions
        ClaimRewardsVars memory vars;
        vars.claimer = getRandomReceiver(claimerId);

        ClaimRewardsSnapshot memory pre = claimRewardsSnapshot(vars);

        bool isPaused = primev.rewardManager.paused();
        bool isClaimerCannotReceiveEther = !ethReceivers[vars.claimer];

        // Action
        vm.prank(vars.claimer);
        try primev.rewardManager.claimRewards() {
            ClaimRewardsSnapshot memory post = claimRewardsSnapshot(vars);

            // Post-conditions
            t(!isPaused, "CRE01"); // If contract is paused, it should revert
            t(pre.unclaimedRewards == 0 || !isClaimerCannotReceiveEther, "CRE01"); // If contract can't receive ether, it should revert

            t(post.claimerBalance == pre.claimerBalance + pre.unclaimedRewards, "CRS01");
            t(post.unclaimedRewards == 0, "CRS02");
        } catch {
            assert(isPaused || isClaimerCannotReceiveEther);
        }
    }
}
