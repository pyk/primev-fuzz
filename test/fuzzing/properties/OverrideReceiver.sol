// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract OverrideReceiverProperties is BaseProperties {
    struct OverrideReceiverVars {
        bytes pubkey;
        address receiver;
        address overrideAddress;
    }

    function overrideReceiver(uint256 pubkeyId, uint256 overrideAddressId, bool migrateExistingRewards) external {
        OverrideReceiverVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = getOverrideAddress(overrideAddressId);

        // Pre-conditions
        if (vars.overrideAddress == address(0)) return;
        if (primev.rewardManager.paused()) return;

        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.overrideReceiver(vars.overrideAddress, migrateExistingRewards) {
            // Post-conditions
            expectedOverrideAddress[vars.receiver] = vars.overrideAddress;

            if (migrateExistingRewards) {
                expectedUnclaimedRewards[vars.receiver] -= unclaimedRewards;
                expectedUnclaimedRewards[vars.overrideAddress] += unclaimedRewards;
            }
        } catch {
            assert(false);
        }
    }

    struct RemoveOverrideAddressVars {
        bytes pubkey;
        address receiver;
        address overrideAddress;
    }

    function removeOverrideAddress(uint256 pubkeyId, bool migrateExistingRewards) external {
        RemoveOverrideAddressVars memory vars;
        vars.pubkey = getPubkey(pubkeyId);
        vars.receiver = pubkeyReceivers[vars.pubkey];
        vars.overrideAddress = expectedOverrideAddress[vars.receiver];

        // Pre-conditions
        uint256 unclaimedRewards = primev.rewardManager.unclaimedRewards(vars.overrideAddress);

        if (vars.overrideAddress == address(0)) return;
        if (primev.rewardManager.paused()) return;

        // Action
        vm.prank(vars.receiver);
        try primev.rewardManager.removeOverrideAddress(migrateExistingRewards) {
            // Post-conditions
            expectedOverrideAddress[vars.receiver] = address(0);
            if (migrateExistingRewards) {
                expectedUnclaimedRewards[vars.receiver] += unclaimedRewards;
                expectedUnclaimedRewards[vars.overrideAddress] -= unclaimedRewards;
            }
        } catch {
            assert(false);
        }
    }
}
