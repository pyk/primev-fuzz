# Primev Cantina Competition Details

Mev-commit is a peer-to-peer networking platform designed to facilitate real-time interactions and coordination between mev actors and execution providers. It provides a robust network for exchanging execution bids and cryptographic commitments, which are used to specify execution requirements in detail and to receive credible commitments that act as promises to fulfill bid requirements. Mev-commit allows actors to engage in “fast games” such as preconfirmations through real-time cryptographic commitments and settles results using a high throughput blockchain for permissionless access.

## **Prize distribution and scoring**

- **Public Prize Pool:** $12,000
- Additional pay for dedicated Cantina researcher: $3000
- Scoring described in the [competition scoring page](https://docs.cantina.xyz/cantina-docs/cantina-competitions/judging-process/scoring).
- Findings Severities described in detail on [our docs page](https://docs.cantina.xyz/cantina-docs/cantina-competitions/judging-process/finding-severity-criteria).

## **Documentation**

- [Protocol docs](https://docs.primev.xyz/)
- Many contracts have inline README files which further explain behavior.

## **Scope**

- Repository: [https://github.com/primev/mev-commit/tree/c902f8cc9101c2d84d123a0422044026fd91209a/contracts/contracts/validator-registry/rewards](https://github.com/primev/mev-commit/tree/c902f8cc9101c2d84d123a0422044026fd91209a/contracts/contracts/validator-registry/rewards)
- Commit: `c902f8cc9101c2d84d123a0422044026fd91209a`
- Total LOC: 287
- Files:
  - All files in the `contracts/validator-registry/rewards`

### **Build Instructions**

- Clone the [https://github.com/primev/mev-commit](https://github.com/primev/mev-commit) repo.
- Install [https://book.getfoundry.sh/](https://book.getfoundry.sh/).
- Navigate to the [contracts directory](https://github.com/primev/mev-commit/tree/a8f287ed6c2759edad7cc1c2df9d30f6d5da31c3/contracts).
- Run forge clean && forge build --via-ir

### **Basic POC Test**

- Mandatory POC rule applies for this competition
- The RewardManagerTest.sol file can be utilized as an example for running POCs against the [reward manager](https://github.com/primev/mev-commit/blob/c902f8cc9101c2d84d123a0422044026fd91209a/contracts/test/validator-registry/rewards/RewardManagerTest.sol). It’s runnable using forge clean && forge test --via-ir from the [contracts directory](https://github.com/primev/mev-commit/tree/c902f8cc9101c2d84d123a0422044026fd91209a/contracts).

### **Out of Scope**

- The owner account is assumed to be honest and secure
- The owner account is assumed to call functions correctly.
  - Ie. Any scenario that involves the owner account calling an onlyOwner function incorrectly is a non-issue.
- The contract is upgradeable, and most on-chain parameters are intentionally mutable by the owner. On-chain parameters are assumed to be set to sane values upon contract deployment.
- Functions with the onlyOwner modifier are intentionally not pause-able, since the owner account controls pausing anyways
- We’re aware that validators can be registered with more than one contract at once in certain scenarios. The handling of such scenarios OOS. For this audit, it is assumed that a validator pubkey can only ever be opted-in with one of the three validator registries at a time.
- The reward manager uses 48 byte BLS pubkeys, and only validates those pubkeys by byte length. We are aware there are ramifications to not validating BLS identities/signatures on-chain, and this is something we’ll address in future versions of the contracts. See [https://github.com/primev/mev-commit/issues/213](https://github.com/primev/mev-commit/issues/213).
  - For now this issue is solved by the ability for pubkeys to be manually slashed via any of the three registries.
- Small and/or trivial changes to the contracts that would result in trivial gas savings are considered out of scope.
- There is currently no protocol or mechanism that enforces mev-commit providers use the RewardManager contract for paying validator rewards. For now it is assumed providers will always call `payProposer` to make reward payments to proposers.
- Calling `payProposer` with a non-registered pubkey creates “orphaned rewards”, which requires an address to send and irrevocably lose ETH (plus pay gas). There is no incentive for a malicious actor to create orphaned rewards. Further, the owner account is in no way obligated to redistribute orphaned rewards. Thus the ability for any account to create orphaned rewards is a non-issue.
- Auto-claim state is stored with respect to a validator’s receiver address, not the override address.
- It is assumed a receiver address and its override address are the same entity and/or fully trust one another. There is no issue in the receiver address being able to migrate unclaimed rewards to/from the override address. The ability to set an override address purely exists as a convenience, and for customization/flexibility.
- payProposer is intentionally not pause-able. It should always be callable for mev-commit providers.
- There will be unavoidable differences in gas cost to call payProposer, depending on which control flow logic is executed.
- It is assumed builders will only call payProposer for validator pubkeys that are opted-in to mev-commit. Rewards should only be “orphaned” if a builder goes against the protocol and attempts to call payProposer on a pubkey that’s not opted-in to mev-commit. In this scenario, it is intentionally left up to the owner account to possibly distribute rewards as needed.
- It’s intentional that auto-claim only transfers msg.value in payProposer. This prevents the need for a read or write to the unclaimedRewards mapping.
  - In this vein, there is an edge case in which an address that currently has autoClaim enabled, can still have unclaimed rewards. See this example from tests [https://github.com/primev/mev-commit/blob/e72cb4608ad92ea7794baa5d56fb51e96b97068b/contracts/test/validator-registry/rewards/RewardManagerTest.sol#L522](https://github.com/primev/mev-commit/blob/e72cb4608ad92ea7794baa5d56fb51e96b97068b/contracts/test/validator-registry/rewards/RewardManagerTest.sol#L522). This edge case is a non-issue, the address can just manually claim rewards.
- Auto-claim is a permissionless feature, only until an auto-claim transfer fails. When an auto-claim transfer fails, it is intentional that the relevant address which enabled auto-claim cannot use auto-claim again (unless removed from the blacklist by the owner).
- The onus is on users to have receive functions that do not revert, for either the override or receiver address. If a receiver and/or its override address revert upon eth transfers, this could result in funds intended for that user being inaccessible in the RewardsManager contract.
- When calling enableAutoClaim, the msg.sender has the ability to claim their existing rewards during the same transaction. If the msg.sender does not claim their existing rewards when enabling auto-claim, it’s expected behavior that unclaimed rewards could persist in the contract until the user manually claims those rewards.
- Addresses have the ability to override their claim address, or remove an overridden address. For each of overrideClaimAddress, and removeOverriddenClaimAddress, there is the ability to migrate existing rewards. If the user sets that parameter to false, it’s expected behavior that unclaimed rewards could exist in both the override and receiver address.
- Automated findings by LightChaser
  - [https://gist.github.com/ChaseTheLight01/65680d734f4a84f35b796a7262392034](https://gist.github.com/ChaseTheLight01/65680d734f4a84f35b796a7262392034)

## **Contact Us**

For any issues or concerns regarding this competition, please reach out to the Cantina core team through the Cantina Discord.
