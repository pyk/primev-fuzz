// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { BaseProperties } from "./Base.sol";

contract MockProperties is BaseProperties {
    function MevCommitMiddlewareMock_register(uint256 pubkeyId, uint256 operatorId) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached =
            primev.mevCommitMiddleware.validatorCount() == primev.mevCommitMiddleware.maxValidators();
        bool isValidatorExists = primev.mevCommitMiddleware.validatorRecords(pubkey).exists;

        address operator = getRandomReceiver(operatorId);

        // Action
        try primev.mevCommitMiddleware.register(pubkey, address(0), operator, 0) {
            // Post-conditions
            t(!isPubkeyInvalid, "MCMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "MCMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "MCMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function MevCommitMiddlewareMock_unregister(
        uint256 pubkeyId
    ) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
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

    function VanillaRegistryMock_register(uint256 pubkeyId, uint256 withdrawalAddressId) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached = primev.vanillaRegistry.validatorCount() == primev.vanillaRegistry.maxValidators();
        bool isValidatorExists = primev.vanillaRegistry.stakedValidators(pubkey).exists;
        address withdrawalAddress = getRandomReceiver(withdrawalAddressId);

        // Action
        try primev.vanillaRegistry.register(pubkey, withdrawalAddress, 0, 0) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "VRMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "VRMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function VanillaRegistryMock_unregister(
        uint256 pubkeyId
    ) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
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

    function MevCommitAVSMock_register(uint256 pubkeyId, uint256 withdrawalAddressId) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
        bool isPubkeyInvalid = pubkey.length != 48;
        bool isMaxValidatorsReached = primev.mevCommitAVS.validatorCount() == primev.mevCommitAVS.maxValidators();
        bool isValidatorExists = primev.mevCommitAVS.validatorRegistrations(pubkey).exists;
        address withdrawalAddress = getRandomReceiver(withdrawalAddressId);

        // Action
        try primev.mevCommitAVS.register(pubkey, withdrawalAddress, 0, 0) {
            // Post-conditions
            t(!isPubkeyInvalid, "VRMRE01"); // Invalid key should revert
            t(!isMaxValidatorsReached, "VRMRE02"); // Should revert when max validators reached
            t(!isValidatorExists, "VRMR03"); // Should revert when validator exists
        } catch {
            assert(isPubkeyInvalid || isMaxValidatorsReached || isValidatorExists);
        }
    }

    function MevCommitAVSMock_unregister(
        uint256 pubkeyId
    ) external {
        // Pre-conditions
        bytes memory pubkey = getRandomPubkey(pubkeyId);
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
