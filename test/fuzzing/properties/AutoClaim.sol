// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract AutoClaimProperties is BaseProperties {
    struct AutoClaimVars {
        address claimer;
    }

    struct AutoClaimSnapshot {
        uint256 claimerBalance;
        uint256 unclaimedRewards;
    }

    function autoClaimSnapshot(
        AutoClaimVars memory vars
    ) internal view returns (AutoClaimSnapshot memory s) {
        s.claimerBalance = vars.claimer.balance;
        s.unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.claimer);
    }

    /// @custom:property EACE01 If contract is paused, enable auto claim operation should revert
    /// @custom:property EACE02 If claimExistingRewards=true and contract can't receive ETH, the auto claim should revert
    /// @custom:property EACS01 If claimExistingRewards=true, the claimer balance will increased by exactly unclaimed rewards and the unclamed rewards of claimer should be zero
    /// @custom:property EACS02 If claimExistingRewards=false, the claimer balance and the unclaimed rewards should not change
    /// @custom:property EACS03 After enableAutoClaim. the autoClaim of claimer should set to true
    function enableAutoClaim(address claimer, bool claimExistingRewards) external {
        // Pre-conditions
        AutoClaimVars memory vars;
        vars.claimer = claimer;

        bool isPaused = primev.rewardManager.paused();
        AutoClaimSnapshot memory pre = autoClaimSnapshot(vars);

        bool isClaimerRewardManager = claimExistingRewards
            && (
                claimer == address(primev.rewardManager)
                    || claimer == IProxy(address(primev.rewardManager)).implementation()
            ) && pre.unclaimedRewards > 0;

        // Action
        vm.prank(claimer);
        try primev.rewardManager.enableAutoClaim(claimExistingRewards) {
            AutoClaimSnapshot memory post = autoClaimSnapshot(vars);

            // Post-conditions
            t(!isPaused, "EACE01"); // If contract is paused, it should revert
            t(!isClaimerRewardManager, "EACE02"); // If contract can't receive ether, it should revert

            if (claimExistingRewards) {
                t(post.claimerBalance == pre.claimerBalance + pre.unclaimedRewards, "EACS01");
                t(post.unclaimedRewards == 0, "EACS01");
            } else {
                t(post.claimerBalance == pre.claimerBalance, "EACS02");
                t(post.unclaimedRewards == pre.unclaimedRewards, "EACS02");
            }
            t(primev.rewardManager.autoClaim(claimer) == true, "EACS03");
        } catch {
            assert(isPaused || isClaimerRewardManager);
        }
    }

    /// @custom:property DACE01 If contract is paused, disable auto claim operation should revert
    /// @custom:property DACS01 After disable auto claim, the claimer auto claim should be disabled
    function disableAutoClaim(
        address claimer
    ) external {
        // Pre-conditions
        bool isPaused = primev.rewardManager.paused();

        // Action
        vm.prank(claimer);
        try primev.rewardManager.disableAutoClaim() {
            // Post-conditions
            t(!isPaused, "DACE01"); // If contract is paused, it should revert
            t(primev.rewardManager.autoClaim(claimer) == false, "DACS01");
        } catch {
            assert(isPaused);
        }
    }
}
