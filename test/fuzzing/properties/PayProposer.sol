// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract PayProposerProperties is BaseProperties {
    function payProposer(
        bytes memory pubkey
    ) external {
        try primev.rewardManager.payProposer(pubkey) { }
        catch {
            assert(false);
        }
    }
}
