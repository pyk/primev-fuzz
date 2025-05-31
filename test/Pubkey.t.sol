// SPDX-License-Identifier: BSL 1.1
pragma solidity 0.8.26;

import { Test } from "forge-std/Test.sol";

/// @custom:command forge test --match-contract PubkeyTest
contract PubkeyTest is Test {
    function testPubkey() external pure {
        bytes memory pubkey1 =
            hex"882341041449231925522008577481963784663216801704603473641223041157013500731201815006905812769981";
        assertEq(pubkey1.length, 48, "invalid length");
    }
}
