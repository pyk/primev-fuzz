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
    mapping(address => bool) ethReceivers;
    address[] receivers;

    function setupReceivers() internal {
        // EOA that can receive ETH
        address receiver1 = makeAddr("receiver1");
        address receiver2 = makeAddr("receiver2");
        address receiver3 = makeAddr("receiver3");
        address receiver4 = makeAddr("receiver4");
        address receiver5 = makeAddr("receiver5");

        // Contracts that can receive ETH
        address receiver6 = address(new ETHReceiver());
        vm.label(receiver6, "receiver6");
        address receiver7 = address(new ETHReceiver());
        vm.label(receiver7, "receiver7");
        address receiver8 = address(new ETHReceiver());
        vm.label(receiver8, "receiver8");

        // Contracts that can't receive ETH
        address receiver9 = address(new NonETHReceiver());
        vm.label(receiver9, "receiver9");
        address receiver10 = address(new NonETHReceiver());
        vm.label(receiver10, "receiver10");

        receivers = new address[](11);
        receivers[0] = address(0);
        receivers[1] = receiver1;
        receivers[2] = receiver2;
        receivers[3] = receiver3;
        receivers[4] = receiver4;
        receivers[5] = receiver5;
        receivers[6] = receiver6;
        receivers[7] = receiver7;
        receivers[8] = receiver8;
        receivers[9] = receiver9;
        receivers[10] = receiver10;

        ethReceivers[receiver1] = true;
        ethReceivers[receiver2] = true;
        ethReceivers[receiver3] = true;
        ethReceivers[receiver4] = true;
        ethReceivers[receiver5] = true;
        ethReceivers[receiver6] = true;
        ethReceivers[receiver7] = true;
        ethReceivers[receiver8] = true;
        ethReceivers[receiver9] = false;
        ethReceivers[receiver10] = false;
    }

    function getRandomReceiver(
        uint256 id
    ) internal view returns (address receiver) {
        id = bound(id, 0, receivers.length - 1);
        receiver = receivers[id];
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
