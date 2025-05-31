// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseProperties } from "./Base.sol";

contract PayProposerProperties is BaseProperties {
    struct PayProposerVars {
        address rewardManager;
        bytes pubkey;
        uint256 amountIn;
        address receiver;
        address overrideAddress;
        bool autoClaimEnabled;
        bool autoClaimBlacklist;
    }

    struct PayProposerSnapshot {
        uint256 rewardManagerBalance;
        uint256 pubkeyOrphanedRewards;
        uint256 receiverUnclaimedRewards;
        uint256 receiverBalance;
        uint256 overrideUnclaimedRewards;
        uint256 overrideBalance;
    }

    function payProposerSnapshot(
        PayProposerVars memory vars
    ) internal view returns (PayProposerSnapshot memory s) {
        s.rewardManagerBalance = vars.rewardManager.balance;
        s.pubkeyOrphanedRewards = primev.rewardManager.orphanedRewards(vars.pubkey);
        s.receiverUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.receiver);
        s.receiverBalance = vars.receiver.balance;
        s.overrideUnclaimedRewards = primev.rewardManager.unclaimedRewards(vars.overrideAddress);
        s.overrideBalance = vars.overrideAddress.balance;
    }

    function isFailedSend(
        address addr
    ) internal returns (bool) {
        return addr == address(primev.rewardManager) || addr == IProxy(address(primev.rewardManager)).implementation();
    }

    /// @custom:audit no paused is intentional by the dev
    /// @custom:property PPE01 If pubkey is invalid, it should revert
    /// @custom:property PPE02 If msg.value is zero, it should revert
    /// @custom:property PPS01 After pay proposer, the reward contract balance should be increased by the msg.value
    /// @custom:property PPS02 If Receiver Not Exists, orphaned rewards should be increased
    /// @custom:property PPS03 If Receiver exists, the logic should be correct
    function payProposer(
        bytes memory pubkey
    ) external payable {
        // Pre-conditions
        PayProposerVars memory vars;
        vars.pubkey = pubkey;
        vars.amountIn = msg.value;
        vars.rewardManager = address(primev.rewardManager);
        vars.receiver = primev.rewardManager.findReceiver(pubkey);
        vars.overrideAddress = primev.rewardManager.overrideAddresses(vars.receiver);
        vars.autoClaimEnabled = primev.rewardManager.autoClaim(vars.receiver);
        vars.autoClaimBlacklist = primev.rewardManager.autoClaimBlacklist(vars.receiver);

        bool pubKeyInvalid = pubkey.length != 48;
        bool isNoEthPayable = msg.value == 0;

        PayProposerSnapshot memory pre = payProposerSnapshot(vars);

        // Action
        try primev.rewardManager.payProposer{ value: vars.amountIn }(pubkey) {
            PayProposerSnapshot memory post = payProposerSnapshot(vars);

            // Post-conditions
            t(!pubKeyInvalid, "PPE01"); // Invalid key should revert
            t(!isNoEthPayable, "PPE02"); // Zero value should revert

            if (vars.receiver == address(0)) {
                t(post.rewardManagerBalance == pre.rewardManagerBalance + vars.amountIn, "PPS01");
                t(post.pubkeyOrphanedRewards == pre.pubkeyOrphanedRewards + vars.amountIn, "PPS02");
            } else {
                if (vars.overrideAddress != address(0)) {
                    if (vars.autoClaimEnabled && !vars.autoClaimBlacklist) {
                        if (isFailedSend(vars.overrideAddress)) {
                            t(primev.rewardManager.autoClaim(vars.receiver) == false, "PPS03_1");
                            t(primev.rewardManager.autoClaimBlacklist(vars.receiver) == true, "PPS03_2");
                            t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards + vars.amountIn, "PPS03_3");
                            t(post.rewardManagerBalance == pre.rewardManagerBalance + vars.amountIn, "PPS03_4");
                            t(post.overrideBalance == pre.overrideBalance, "PPS03_5");
                        } else {
                            t(post.rewardManagerBalance == pre.rewardManagerBalance, "PPS03_6");
                            t(post.overrideBalance == pre.overrideBalance + vars.amountIn, "PPS03_7");
                            t(post.receiverBalance == pre.receiverBalance, "PPS03_8");
                            t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "PPS03_9");
                            t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards, "PPS03_10");
                        }
                    } else {
                        t(post.overrideUnclaimedRewards == pre.overrideUnclaimedRewards + vars.amountIn, "PPS03_11");
                        t(post.rewardManagerBalance == pre.rewardManagerBalance + vars.amountIn, "PPS03_12");
                        t(post.overrideBalance == pre.overrideBalance, "PPS03_13");
                    }
                } else {
                    if (vars.autoClaimEnabled && !vars.autoClaimBlacklist) {
                        if (isFailedSend(vars.overrideAddress)) {
                            t(primev.rewardManager.autoClaim(vars.receiver) == false, "PPS03_14");
                            t(primev.rewardManager.autoClaimBlacklist(vars.receiver) == true, "PPS03_15");
                            t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards + vars.amountIn, "PPS03_16");
                            t(post.rewardManagerBalance == pre.rewardManagerBalance + vars.amountIn, "PPS03_17");
                            t(post.overrideBalance == pre.overrideBalance, "PPS03_18");
                        } else {
                            t(post.rewardManagerBalance == pre.rewardManagerBalance, "PPS03_19");
                            t(post.overrideBalance == pre.overrideBalance + vars.amountIn, "PPS03_20");
                            t(post.receiverBalance == pre.receiverBalance, "PPS03_21");
                            t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "PPS03_22");
                            t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards, "PPS03_23");
                        }
                    } else {
                        t(post.receiverUnclaimedRewards == pre.receiverUnclaimedRewards + vars.amountIn, "PPS03_24");
                        t(post.rewardManagerBalance == pre.rewardManagerBalance + vars.amountIn, "PPS03_25");
                        t(post.overrideBalance == pre.overrideBalance, "PPS03_26");
                    }
                }
            }
        } catch {
            assert(pubKeyInvalid || isNoEthPayable);
        }
    }
}
