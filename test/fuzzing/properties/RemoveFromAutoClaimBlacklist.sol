// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract RemoveFromAutoClaimBlacklistProperties is BaseProperties {
/// @custom:property RABS01 After auto claim blacklist is removed, autoClaimBlacklist[addr] should be false
// function removeFromAutoClaimBlacklist(
//     uint256 receiverId
// ) external {
//     address receiver = getRandomReceiver(receiverId);
//     // Action
//     vm.prank(primev.owner);
//     try primev.rewardManager.removeFromAutoClaimBlacklist(receiver) {
//         // Post-conditions

//         t(primev.rewardManager.autoClaimBlacklist(receiver) == false, "RABS01");
//     } catch {
//         assert(false);
//     }
// }
}
