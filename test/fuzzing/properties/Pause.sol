// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract PauseProperties is BaseProperties {
    function pause() external payable {
        // Pre-conditions
        bool isEnforcedPause = primev.rewardManager.paused();

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.pause() {
            t(!isEnforcedPause, "RMPS-E01"); // If contract is paused, it should revert
            t(primev.rewardManager.paused(), "RMPS-S01");
        } catch {
            assert(isEnforcedPause);
        }
    }

    function unpause() external payable {
        // Pre-conditions
        bool isExpectedPause = primev.rewardManager.paused();

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.unpause() {
            t(isExpectedPause, "RMUP-E01"); // If contract is paused, it should revert
            t(primev.rewardManager.paused() == false, "RMUP-S01");
        } catch {
            assert(!isExpectedPause);
        }
    }
}
