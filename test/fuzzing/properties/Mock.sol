// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract MockProperties is BaseProperties {
    function MevCommitMiddlewareMock_register(
        bytes memory pubkey,
        address vault,
        address operator,
        uint256 timestamp
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached =
            primev.mevCommitMiddleware.validatorCount() == primev.mevCommitMiddleware.maxValidators();
        bool isValidatorExists = primev.mevCommitMiddleware.validatorRecords(pubkey).exists;

        // Action
        try primev.mevCommitMiddleware.register(pubkey, vault, operator, timestamp) {
            // Post-conditions
            t(!isPubkeyInvalid, "MCMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "MCMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "MCMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function MevCommitMiddlewareMock_unregister(
        bytes memory pubkey
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isValidatorNotExists = !primev.mevCommitMiddleware.validatorRecords(pubkey).exists;

        // Action
        try primev.mevCommitMiddleware.unregister(pubkey) {
            // Post-conditions
            t(!isPubkeyInvalid, "MCMRE01"); // Invalid key should revert
            t(!isValidatorNotExists, "MCMR02"); // Should revert when validator not exists
        } catch {
            assert(isPubkeyInvalid || isValidatorNotExists);
        }
    }

    function VanillaRegistryMock_register(
        bytes memory pubkey,
        address withdrawalAddress,
        uint256 balance,
        uint256 blockHeight
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached = primev.vanillaRegistry.validatorCount() == primev.vanillaRegistry.maxValidators();
        bool isValidatorExists = primev.vanillaRegistry.stakedValidators(pubkey).exists;

        // Action
        try primev.vanillaRegistry.register(pubkey, withdrawalAddress, balance, blockHeight) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "VRMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "VRMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function VanillaRegistryMock_unregister(
        bytes memory pubkey
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isValidatorNotExists = !primev.vanillaRegistry.stakedValidators(pubkey).exists;

        // Action
        try primev.vanillaRegistry.unregister(pubkey) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isValidatorNotExists, "VRMR02"); // Should revert when validator not exists
        } catch {
            assert(isPubkeyInvalid || isValidatorNotExists);
        }
    }

    function MevCommitAVSMock_register(
        bytes memory pubkey,
        address withdrawalAddress,
        uint256 balance,
        uint256 blockHeight
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached = primev.mevCommitAVS.validatorCount() == primev.mevCommitAVS.maxValidators();
        bool isValidatorExists = primev.mevCommitAVS.validatorRegistrations(pubkey).exists;

        // Action
        try primev.mevCommitAVS.register(pubkey, withdrawalAddress, balance, blockHeight) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "VRMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "VRMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function MevCommitAVSMock_unregister(
        bytes memory pubkey
    ) external {
        // Pre-conditions
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isValidatorNotExists = !primev.mevCommitAVS.validatorRegistrations(pubkey).exists;

        // Action
        try primev.mevCommitAVS.unregister(pubkey) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isValidatorNotExists, "VRMR03"); // Should revert when validator not exists
        } catch {
            assert(isPubkeyInvalid || isValidatorNotExists);
        }
    }
}
