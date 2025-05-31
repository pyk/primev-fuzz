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
import { AutoClaimProperties } from "./properties/AutoClaim.sol";
import { ClaimRewardsProperties } from "./properties/ClaimRewards.sol";
import { OverrideReceiverProperties } from "./properties/OverrideReceiver.sol";
import { PayProposerProperties } from "./properties/PayProposer.sol";

// Global
import { GlobalProperties } from "./properties/Global.sol";

contract Fuzz is
    ClaimOrphanedRewardsProperties,
    PauseProperties,
    RemoveFromAutoClaimBlacklistProperties,
    SetAutoClaimGasLimitProperties,
    MockProperties,
    AutoClaimProperties,
    ClaimRewardsProperties,
    OverrideReceiverProperties,
    PayProposerProperties,
    GlobalProperties
{
    constructor() {
        setupReceivers();
        setupPubkeys();
        primev = deployContracts();
    }
}
