// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { Test } from "forge-std/Test.sol";

import { RewardManager } from "src/validator-registry/rewards/RewardManager.sol";

import { MevCommitAVSMock } from "./mocks/MevCommitAVSMock.sol";
import { MevCommitMiddlewareMock } from "./mocks/MevCommitMiddlewareMock.sol";
import { VanillaRegistryMock } from "./mocks/VanillaRegistryMock.sol";

contract Setup is Test {
    struct Deployment {
        address owner;
        VanillaRegistryMock vanillaRegistry;
        MevCommitAVSMock mevCommitAVS;
        MevCommitMiddlewareMock mevCommitMiddleware;
        RewardManager rewardManager;
    }

    function deployVanillaRegistryMock() internal returns (VanillaRegistryMock deployment) {
        deployment = new VanillaRegistryMock();
    }

    function deployMevCommitAVSMock() internal returns (MevCommitAVSMock deployment) {
        deployment = new MevCommitAVSMock();
    }

    function deployMevCommitMiddlewareMock() internal returns (MevCommitMiddlewareMock deployment) {
        deployment = new MevCommitMiddlewareMock();
    }

    function deployRewardManager(
        address owner,
        VanillaRegistryMock vanillaRegistry,
        MevCommitAVSMock mevCommitAVS,
        MevCommitMiddlewareMock mevCommitMiddleware
    ) internal returns (RewardManager deployment) {
        RewardManager implementation = new RewardManager();
        vm.label(address(implementation), "RewardManagerImplementation");

        uint256 autoClaimGasLimit = 0.01 ether;
        bytes memory data = abi.encodeWithSelector(
            RewardManager.initialize.selector,
            vanillaRegistry,
            mevCommitAVS,
            mevCommitMiddleware,
            autoClaimGasLimit,
            owner
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);
        deployment = RewardManager(payable(address(proxy)));
        vm.label(address(deployment), "RewardManagerProxy");

        //
    }

    function deployContracts() internal returns (Deployment memory deployment) {
        deployment.owner = makeAddr("RewardManagerOwner");
        deployment.vanillaRegistry = deployVanillaRegistryMock();
        deployment.mevCommitAVS = deployMevCommitAVSMock();
        deployment.mevCommitMiddleware = deployMevCommitMiddlewareMock();
        deployment.rewardManager = deployRewardManager(
            deployment.owner, deployment.vanillaRegistry, deployment.mevCommitAVS, deployment.mevCommitMiddleware
        );
    }
}
