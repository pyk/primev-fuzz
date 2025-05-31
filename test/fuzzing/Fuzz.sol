// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

// Admins
import { ClaimOrphanedRewardsProperties } from "./properties/ClaimOrphanedRewards.sol";
import { PauseProperties } from "./properties/Pause.sol";
import { RemoveFromAutoClaimBlacklistProperties } from "./properties/RemoveFromAutoClaimBlacklist.sol";
import { SetAutoClaimGasLimitProperties } from "./properties/SetAutoClaimGasLimit.sol";

// Mocks
import { MockProperties } from "./properties/Mock.sol";

// Users
import { ClaimRewardsProperties } from "./properties/ClaimRewards.sol";
import { OverrideReceiverProperties } from "./properties/OverrideReceiver.sol";
import { PayProposerProperties } from "./properties/PayProposer.sol";
import { RemoveOverrideAddressProperties } from "./properties/RemoveOverrideAddress.sol";

contract Fuzz is
    ClaimOrphanedRewardsProperties,
    PauseProperties,
    RemoveFromAutoClaimBlacklistProperties,
    SetAutoClaimGasLimitProperties,
    MockProperties,
    ClaimRewardsProperties,
    OverrideReceiverProperties,
    PayProposerProperties,
    RemoveOverrideAddressProperties
{
    constructor() {
        primev = deployContracts();
    }

    /// @dev Allows to receive random eth from fuzzing squence
    receive() external payable { }
}
