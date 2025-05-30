// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { Setup, console } from "../Setup.sol";

contract BaseProperties is Setup {
    Deployment primev;

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
