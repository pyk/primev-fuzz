// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract PauseProperties is BaseProperties {
    /// @custom:property PAE01 If contract is paused, the operation will revert
    /// @custom:property PAS01 After pause, the contract is paused
    function pause() external {
        // Pre-conditions
        bool isEnforcedPause = primev.rewardManager.paused();

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.pause() {
            t(!isEnforcedPause, "PAE01"); // If contract is paused, it should revert
            t(primev.rewardManager.paused(), "PAS01");
        } catch {
            assert(isEnforcedPause);
        }
    }

    /// @custom:property UPE01 If contact is not paused, the operation will revert
    /// @custom:property UPS01 After unpause, the contract is not paused
    function unpause() external {
        // Pre-conditions
        bool isExpectedPause = primev.rewardManager.paused();

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.unpause() {
            t(isExpectedPause, "UPE01"); // If contract is paused, it should revert
            t(primev.rewardManager.paused() == false, "UPS01");
        } catch {
            assert(!isExpectedPause);
        }
    }
}
