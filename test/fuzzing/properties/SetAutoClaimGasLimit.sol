// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract SetAutoClaimGasLimitProperties is BaseProperties {
    /// @custom:property SGLE01 If autoClaimGasLimit is zero, the operation will revert
    /// @custom:property SGLS01 After gas limit is set, the autoClaimGasLimit is correctly updated
    function setAutoClaimGasLimit(
        uint256 autoClaimGasLimit
    ) external {
        // Pre-conditions
        bool isAutoClaimGasLimitZero = autoClaimGasLimit == 0;

        // Action
        vm.prank(primev.owner);
        try primev.rewardManager.setAutoClaimGasLimit(autoClaimGasLimit) {
            // Post-conditions
            t(!isAutoClaimGasLimitZero, "SGL01"); // It should revert if autoClaimGasLimit=0

            t(primev.rewardManager.autoClaimGasLimit() == autoClaimGasLimit, "SGLS01");
        } catch {
            assert(isAutoClaimGasLimitZero);
        }
    }
}
