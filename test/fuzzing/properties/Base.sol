// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { Setup, console } from "../Setup.sol";

contract ETHReceiver {
    receive() external payable { }
}

contract NonETHReceiver {
    receive() external payable {
        revert("NOTOK");
    }
}

contract BaseProperties is Setup {
    Deployment primev;
    // mapping(address => bool) ethReceivers;

    // Shadow variables to track pubkeys
    bytes[] pubkeys;
    mapping(bytes => bool) pubkeyExists;
    mapping(bytes => address) pubkeyReceivers;

    // Shadow variables to track orphaned rewards
    uint256 expectedTotalOrphanedRewards = 0;
    mapping(bytes pubkey => uint256 rewards) expectedOrphanedRewards;

    // Shadow variables to track unclaimed rewards
    uint256 expectedTotalUnclaimedRewards = 0;
    mapping(address receiver => uint256 rewards) expectedUnclaimedRewards;

    // Shadow variables to track overrides
    address[] overrides;
    mapping(address receiver => address overrideAddress) expectedOverrideAddress;

    function setupPubkeys() internal {
        // Setup MevCommitMiddleware
        bytes memory pubkey1 =
            hex"727896011037470273037918000728492843042888584323764058414553840142261816080802112727705947390421";
        address receiver1 = makeAddr("receiver1");
        pubkeyExists[pubkey1] = true;
        pubkeyReceivers[pubkey1] = receiver1;
        primev.mevCommitMiddleware.register(pubkey1, true, receiver1);

        bytes memory pubkey2 =
            hex"261766778474163969060129741750393883469790426806273514202507349349577696105071201351672568618434";
        address random = makeAddr("random");
        primev.mevCommitMiddleware.register(pubkey2, false, random);

        bytes memory pubkey3 =
            hex"998421616645774819162207295961705294132051162882237096423807583426352318568424663124032052394313";
        address zero = address(0);
        primev.mevCommitMiddleware.register(pubkey3, true, zero);

        bytes memory pubkey4 =
            hex"653804587467452099364291195355806416492435415224825943408618004649861055261750046199021949717537";
        primev.mevCommitMiddleware.register(pubkey4, false, zero);

        // Setup VanillaRegistry
        // The pubkey2 should set to receiver2
        address receiver2 = makeAddr("receiver2");
        pubkeyExists[pubkey2] = true;
        pubkeyReceivers[pubkey2] = receiver2;
        primev.vanillaRegistry.register(pubkey2, true, receiver2);

        // Setup MevCommitAVS
        // The pubkey3 should set to receiver3
        address receiver3 = makeAddr("receiver3");
        pubkeyExists[pubkey3] = true;
        pubkeyReceivers[pubkey3] = receiver3;
        primev.mevCommitAVS.register(pubkey3, true, receiver3);

        // Pubkey that does not exists
        bytes memory pubkey5 =
            hex"013177234192148963118947337755486283449352010116338809155559774810633928253669203115279671689945";

        pubkeys = new bytes[](5);
        pubkeys[0] = pubkey1;
        pubkeys[1] = pubkey2;
        pubkeys[2] = pubkey3;
        pubkeys[3] = pubkey4;
        pubkeys[4] = pubkey5;
    }

    function setupOverrides() internal {
        // EOA that can receive ETH
        address override1 = makeAddr("override1");
        address override2 = makeAddr("override2");
        address override3 = makeAddr("override3");

        overrides = new address[](4);
        overrides[0] = address(0);
        overrides[1] = override1;
        overrides[2] = override2;
        overrides[3] = override3;
    }

    function getPubkey(
        uint256 id
    ) internal view returns (bytes memory pubkey) {
        id = bound(id, 0, pubkeys.length - 1);
        pubkey = pubkeys[id];
    }

    function getOverrideAddress(
        uint256 id
    ) internal view returns (address receiver) {
        id = bound(id, 0, overrides.length - 1);
        receiver = overrides[id];
    }

    function eq(uint256 a, uint256 b, string memory property) internal pure {
        if (a == b) return;
        console.log("a=%d", a);
        console.log("b=%d", b);
        console.log("Failed: %s", property);
        assert(false);
    }

    function t(bool statement, string memory property) internal pure {
        if (statement) return;
        console.log("Failed: %s", property);
        assert(false);
    }
}
