// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract GlobalProperties is BaseProperties {
    function property_RewardManager_balance() external view returns (bool) {
        uint256 sum = 0;
        for (uint256 i = 0; i < pubkeys.length; i++) {
            sum += primev.rewardManager.orphanedRewards(pubkeys[i]);
        }
        for (uint256 i = 0; i < receivers.length; i++) {
            sum += primev.rewardManager.unclaimedRewards(receivers[i]);
        }
        uint256 balance = address(primev.rewardManager).balance;

        return sum == balance;
    }
}
