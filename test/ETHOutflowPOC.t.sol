// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { Test } from "forge-std/Test.sol";

import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import { RewardManager } from "src/validator-registry/rewards/RewardManager.sol";

interface IMevCommitMiddleware {
    struct Occurrence {
        bool exists;
        uint256 timestamp;
    }

    struct ValidatorRecord {
        address vault;
        address operator;
        bool exists;
        Occurrence deregRequestOccurrence;
    }

    function validatorRecords(
        bytes memory pubkey
    ) external returns (ValidatorRecord memory);
}

/// @author pyk
/// @custom:command forge test --match-contract ETHOutflowPOC
contract ETHOutflowPOC is Test {
    // Mocks
    address vanillaRegistry = makeAddr("vanillaRegistry");
    address mevCommitAVS = makeAddr("mevCommitAVS");
    address mevCommitMiddleware = makeAddr("mevCommitMiddleware");

    // Admin
    address owner = makeAddr("owner");
    address receiver = makeAddr("receiver");

    bytes constant pubkey =
        hex"882341041449231925522008577481963784663216801704603473641223041157013500731201815006905812769981";
    RewardManager rewardManager;

    function setUp() external {
        deployRewardManager();
        mockMevCommitMiddleware();
    }

    function deployRewardManager() internal {
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
        rewardManager = RewardManager(payable(address(proxy)));
        vm.label(address(rewardManager), "RewardManagerProxy");
    }

    function mockMevCommitMiddleware() internal {
        IMevCommitMiddleware.ValidatorRecord memory output = IMevCommitMiddleware.ValidatorRecord({
            vault: address(0),
            operator: receiver,
            exists: true,
            deregRequestOccurrence: IMevCommitMiddleware.Occurrence({ exists: true, timestamp: 0 })
        });
        vm.mockCall(
            mevCommitMiddleware,
            abi.encodeWithSelector(IMevCommitMiddleware.validatorRecords.selector),
            abi.encode(output)
        );
    }

    function test_poc() external {
        // 1) Receiver enable auto-claim
        vm.prank(receiver);
        rewardManager.enableAutoClaim(false);

        // 2) Contract paused
        vm.prank(owner);
        rewardManager.pause();

        // 3) Operator receives rewards even tho claimRewards paused
        // Pause cannot halt ETH outflow due to autoclaim
        uint256 rewardAmount = 1 ether;
        rewardManager.payProposer{ value: rewardAmount }(pubkey);

        assertEq(receiver.balance, rewardAmount);
    }
}
