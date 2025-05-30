# Primev Docs

### **What is mev-commit?**

Mev-commit is a peer-to-peer (P2P) networking platform designed to facilitate real-time interactions and coordination between mev actors and execution providers. It provides a robust network for exchanging execution bids and cryptographic commitments, which are used to specify execution requirements in detail and to receive credible commitments that act as promises to fulfill bid requirements. Mev-commit allows actors to engage in “fast games” such as preconfirmations through real-time cryptographic commitments and settles results using a high throughput blockchain for permissionless access.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/mev-commit.png)

## **What are Bids?**

Within mev-commit, bids act as the foundational requests placed by bidders, signaling their need for specific transaction execution services. This process occurs within a peer-to-peer networking setup to streamline direct negotiations with execution service providers like block builders and rollup sequencers. Each bid, marked by the unique identifier of a transaction hash, enables a straightforward mechanism for providers across the network to recognize and respond to these requests.

Bids essentially convey a user’s readiness to pay a certain fee for the execution of their transaction, proposing a price designed to motivate execution providers to give priority to their transaction.

## **What are Commitments?**

Commitments within mev-commit represent the execution providers’ affirmative responses to bids, confirming their agreement to execute the specified transactions at the proposed prices within designated blocks. These commitments are conveyed through cryptographic proofs or digital signatures, signifying the providers’ acceptance of a bid.

Commitments serve as the critical link that aligns the supply and demand dynamics of the network, facilitating an effective and streamlined process for transaction execution.

## **Actors**

Network actors’ roles are defined based on their interactions with other ecosystem actors. The diagram below depicts a given mev actor’s relative placement compared to others:

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/supply-chain.png)

For example, a Searcher can be a bidder for a Sequencer, but that same Sequencer can be a bidder for a block builder. Thus, it’s best to think of actors’ roles in mev-commit as similar to their roles in the mev pipeline. To the left of the diagram are bidders, and to the right of the diagram are execution providers who can issue commitments against these bids.

Under the Proposer Builder Separation (PBS) model, information only moves to the right among actors in the mev pipeline. With mev-commit, credible commitments for execution and bits of information flow from providers back to bidders, enabling them to effectively utilize block space. This two-way exchange of information and commitments within the mev-commit system enhances the dynamic utilization and management of block space, supporting a more interactive and responsive ecosystem.

### **Providers**

Providers in the mev ecosystem include **Block Builders, Relays, Rollup Sequencers, and even Solvers**. They are crucial for the delivery of commitments through their role in the respective ecosystem or their sophistication. These providers receive bids and deliver transaction inclusion and execution, ensuring the efficient and effective use of block space.

### **Bidders**

Bidders consist of **Searchers, Solvers, Blob Producers, AA Bundlers, Wallets, and even End Users**. They bid for execution services, aiming to optimize their transactions within the block space. Their activities are fundamental to maintaining a competitive and efficient environment within the mev pipeline, facilitating a dynamic market for block space utilization.

For a detailed look at these roles and their interactions, please visit the [**Actors**](https://docs.primev.xyz/v1.1.0/concepts/actors) section.

## **Why mev-commit?**

Through our experience developing products for the Ethereum and the broader crypto ecosystem, we’ve learned that users want to interact with networks as a whole as opposed to single actors that represent some percentage of the network, which is challenging to provide in decentralized systems that have goals beyond user needs.

We’ve created mev-commit to address this and optimized it to solve coordination inefficiencies across the actors of any blockchain network, which are sure to increase with decentralization and greater transaction complexity. Mev-commit’s actor and chain agnostic credible commitment approach ensures that users are not only able to convey their needs to a blockchain network, but receive commitments from the executors of those needs in real time so they can confidently take actions based on their expectation being satisfied or not.

We’re constructing mev-commit to be aligned with the ethos of the crypto ecosystem, specifically the vision being laid out by the Ethereum Foundation, and out of protocol services that supplement that vision such as the current mev pipeline largely introduced by Flashbots. We don’t aim to design a different mev pipeline, but create new avenues for efficiency in solving coordination problems between actors that can be used to have an expectation matching experience when engaging in the existing auctions and mev pipeline. We plan to continue supporting mev-commit’s evolution and adoption according to this mission as the existing landscape shifts and new paradigms are introduced.

---

### **Actors**

Network actors’ roles are defined based on their interactions with other ecosystem actors. A diagram below depicts a given mev actor’s relative placement compared to others.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/supply-chain.png)

A list of potential Actors on the mev-commit network are listed below:

### **Providers:**

Providers of execution services include but are not limited to:

- **Block Builders**: They curate and order transactions in blocks, and have their own private mempool, giving them an advantage in committing to transaction inclusion or making related decisions.
- **Relays**: Relays are trusted actors that accept block bids from block builders and make them available to proposers, also relaying the block payload when requested. Due to their fundamental role in the mev pipeline, they can also act as guardians of proposer preferences for blocks and provide execution services.
- **Rollup Sequencers**: They’re practically block builders for the L2 ecosystem, curating and ordering transactions for the L2 rollups.
- **Miners and Mining Pools**: In PoW systems such as Bitcoin, miners and mining pools can provide execution services as they mine the blocks that contain transactions.

### **Bidders**

Bidders are users of execution services, bidding for inclusion of their transactions, for some specific preference to be adhered to by providers, and more. Bidders include but are not limited to:

- **Searchers**: Searchers of mev opportunities are in prime position to bid for execution services as they may have specific preferences or time constraints that maximize the profitability of their strategies.
- [**Solvers**](https://docs.primev.xyz/v1.1.0/concepts/solvers): Solvers practically act similar to searchers, and will want to bid for execution services that optimize their order in specific ways depending on the protocols they adhere to.
- **Rollup Provers**: Provers and other rollup actors that create blobs and calldata to be posted to L1 will bid for execution services so their data can reliably make it on-chain.
- **AA Bundlers, Wallets, and other transaction aggregators** : These entities possess transactions from end users, and can bid for execution services with them or on their behalf so their platform provides the best user experience.
- **End Users**: While we don’t anticipate most end users to send execution service bids directly beyond the gas price of their transactions, end users are considered bidders of execution services in general whether through gas price or other deal or engagement with where they send their transaction order flow to.

Generally, if you send transactions you’ll be a bidder, and if you receive transactions you’ll be a provider. If you are unsure whether you should be a bidder or provider, or both, reach out to our team and we will guide you according to your specific considerations.

---

### **ConceptsUnderstanding mev-commit**

### **Overview**

Mev-commit is designed as an out of protocol layer to systems like mev-boost, facilitating the exchange of execution bids and commitments between mev actors, solving for coordination inefficiencies. This design ensures that only necessary parts of this faciliation happen on mev-commit (bids, commitments, settlement) and not the transaction flow itself. This design achieves chain abstraction by its nature, as any transaction hash on any chain can be referred to in a mev-commit bid, and be paid in eth. Bids and commitments on mev-commit also do not rely on blockchain bottlenecks and are real-time.

### **Bids and Commitments**

Bids are received and evaluated by providers, who run decisioning logic in their own environment and may decide to issue a cryptographic commitment against whatever the bid is for. In the preconfirmation case, the minimum a commitment can be made is for inclusion of the referred transaction hash(es) in the bid on the target L1 block number specified.

### **Settling Commitments**

Commitments are simultaneously sent to bidders and the mev-commit chain in hash format. This ensures the network can operate with end-to-end pre-execution privacy and low latency. Once the commitment is revealed by either of the participating parties at the end of a slot, an oracle will check the target L1 block number as it gets confirmed to see if the commitment is delivered. If so, the bid amount will be rewarded to the provider. If not, the provider stake will be slashed.

### **Rewards and Slashing**

*Only the actors who participated in the block’s confirmation are considered for rewards or slashing.* This means if Block Builder A and Block Builder B commit to a bid and the target block is built by Block Builder A, the oracle will reward or slash Block Builder A.

### **Network Architechture**

The architecture of the mev-commit peer-to-peer (P2P) network is designed to support instantaneous communication among network participants. The diagram below depicts how mev-commit acts as a layer on bidder and provider operations, that are external to the mev-commit network by its nature:

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/mev-commit-network.png)

### **Network Connectivity**

The network is structured to ensure robust connectivity among users and providers. Each participant node connects to a primary network node, known as a bootnode, during the initial startup phase, establishing a foundational network link.

### **Gateway Nodes**

The subsequent diagram provides a detailed representation of the bid, commitment, and fund flows within the mev-commit framework, showcasing the efficiency and effectiveness of interactions among mev actors.

![image.png](Primev%20Docs%2020368e169201801c8f83f0d2bf2986de/image.png)

---

### **Security & Privacy**

If bids and transaction bundles were transmitted in clear text over the peer-to-peer (P2P) network, it could allow competing bidders and providers to observe and adjust their strategies based on the visible bids. This visibility potentially harms the expected utility of bidders, as their competitors could outbid them by adjusting their bids accordingly. Moreover, the premature revelation of a provider’s commitment to a bid could lead to information leakage about the total value of the block being constructed. This would not only affect the privacy of the providers but also skews the competitive landscape, enabling providers to underbid based on the leaked value information.

To counteract these privacy issues mev-commit provides end-to-end privacy for all bids and commitments in the sense that until commitments are opened after the corresponding L1 block has been confirmed, the contents of the commitment and the corresponding bid are only visible to the bidder who made the bid and the provider who made the commitment. All other bidders and providers and external parties learn nothing except that this provider has made a commitment. Moreover, it is crucial that commitments to bids are binding to the specific bid, i.e., that the commitment can only be opened for that single bid. Since bidders and providers can have conflicting incentives, it is important that they can both open the commitments, which is guaranteed using zero-knowledge proofs.

The security and privacy of mev-commit is achieved by combining two novel cryptographic primitives, anonymous receiver-updatable broadcast encryption (ARUBE), and dual-phase commitments (DPCOM), with a highly efficient ZK proof.

ARUBE is used to efficiently disseminate bids from bidders to providers of their choice in a privacy-preserving manner, DPCOM is used to securely commit to those bids and later allow for the opening of such commitments, and a ZK proof is used to ensure that commitments can be opened by providers and bidders. Below we expand on the specific security and privacy notions achieved for the bidders and the providers along with a short description of the corresponding cryptographic primitive used for each.

## **Posting Bids**

Each bidder can choose a group of providers who will have access to their bids. The bids are then encrypted and sent to this specific group of providers. Other bidders and providers remain unaware of the details of a bid and its designated receivers. The cryptographic primitve that mev-commit leverages to achieve this privacy notion in an efficient way is called ARUBE.

### **Anonymous Receiver-Updatable Broadcast Encryption (ARUBE)**

ARUBE is the primitive that allows bidders in the mev-commit protocol to privately send bids to a subset of the providers without revealing what this subset is. This functionality is commonly provided by anonymous broadcast encryption [**[BBW06]**](https://www.cs.utexas.edu/~bwaters/publications/papers/privatebe.pdf). A feature of broadcast encryption is that a new set of recipients can be specified for each message that is encrypted.

In commitment games, the set of recipients for a given bidder typically remains stable since bidders mostly send their bids to the set of providers they work with and occasionally add or remove a provider from that set. To be able to leverage this for more efficient schemes, we refine the notion of broadcast encryption by adding an algorithm for updating the set of recipients, while the encryption algorithm encrypts a message for a previously determined recipient set. We call this notion anonymous receiver-updatable broadcast encryption (ARUBE).

The image below illustrates ARUBE in operation, where a bidder securely posts an encrypted bid to providers A and B. Provider C and any eavesdropper will be unable to decrypt the bid.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/ARUBE.png)

Using ARUBE, mev-commit keeps all information and value related to bids private pre-execution while allowing them to be settled in a decentralized manner.

## **Committing to Bids**

A provider who receives a bid can make a commitment to it, which they also sign for authentication. The signed commitment binds the provider to the bid. Furthermore, the process is executed in such a way that only the bidder who issued the bid can identify a commitment as being related to their bid. This approach ensures a high level of privacy for the providers, as the commitments they issue are not linkable to a specific bid. In a normal run of the protocol the provider opens all its commitments at the end of the L1 slot, however if the provider refuses to open any of its commtiments, the bidder can independently open the commitment without needing assistance from the provider. This functionality is provided by the novel notion of dual-phase commitments.

### **Dual-Phase Commitment (DPCOM)**

DPCOM is a two-party commitment protocol that allows a message to be committed in two distinct phases. In the first phase, one party precommits to a message and receives both a precommitment and an opening key. In the second phase, the other party commits to the precommitment generated in the first phase, receiving a decommitment information as the output.

A key feature of a dual-phase commitment scheme is its flexibility in opening the resulting commitment using either the opening key or the decommitment information. This is especially useful in the context of the mev-commit protocol, where the bidder generates a precommitment to its bid, after which the provider commits to that precommitment. This process also ensures that both parties can open the commitment: the bidder obtains the opening key when generating the precommitment, and the provider obtains the decommitment information when committing to the precommitment. Consequently, both parties can later prove the content of the committed message to third parties. Crucially, if the provider misbehaves and refuses to publicly open the commitment, the bidder can independently open it without needing assistance from the provider.

The image below illustrates provider B committing to a bid posted by bidder 2, while the other parties remain unaware of the specific bid being committed to.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/dpcom.png)

You can read more on ARUBE and DPCOM [**here**](https://mirror.xyz/preconf.eth/iz2J0uTXHhl8DiAkG-VLLwvCp-8qcc_Z7A8_4rU0A3g).

## **ZK Proofs for Opening Commitments**

A crucial property of the commitments issued by providers on mev-commit is that they can both be opened by providers as well as bidders. Being able for the bidders to open commitments is necessary when providers violate the commitment and thus have no incentive to open it. Therefore, when providers open a commitment, they have to prove in zero-knowledge that the commitment was generated correctly. This ZK proof is verified in a smart contract on the mev-commit chain when the provider sends the commitment-opening transaction. Thus, a provider can only open commitments that have been generated correctly and could also have been opened by the bidder.

### **Implementation and Efficiency**

The ZK proof used has been tailor-made for this particular use-case and optimized for efficiency. It is based on so-called sigma protocols and only requires a few elliptic curve operations and the computation of a hash. Generating a single ZK proof for the commitment opening takes only 0.122 milliseconds on a Mac M1 Pro. Furthermore, only around 32k gas is consumed in the smart contract to verify the proof. For comparison, the overall gas cost of the commitment opening transaction is around 488k gas. Hence, only less than 7% of the gas cost is attributed to the zero-knowledge proof verification.

More details on the used ZK proofs can be found [**here**](https://mirror.xyz/preconf.eth/AgtLSBob1hd2A924vlL7jCyJxQDZZE2tCq_K07w5vuU).

---

### **Commitments**

Commitments represent promises made by providers in a cryptographically verifiable manner.

| **Key**                         | **Description**                                                       |
| ------------------------------- | --------------------------------------------------------------------- |
| **`commitmentDigest`**          | Represents the hash of the bid structure, including the bid signature |
| **`commitmentSignature`**       | Represents an ECDSA signature of the **`commitmentDigest`**           |
| **`commitmentProviderAddress`** | Represents the address of the provider                                |
| **`sharedSecret`**              | Represents the shared secret between the bidder and provider          |

**Example commitmentCopy**

```solidity
{   "result":{      "txHash":"91a89B633194c0D86C539A1A5B14DCCacfD47094",      "bidAmount":"2000",      "blockNumber":"890200",      "receivedBidDigest":"61634fad9081e1b23a00234a52a85386a91fc0fad3fb32d325891bdc4f8a52a9",      "receivedBidSignature":"be99f499be5483665d569bd52fa8c4c9ed5c3bed2f94fb9949259bf640d8bd365b1d9a4b9ccb3ace86ffdcd1fdadc605b0f49b3adaf1c6a9ffea25585234664f1c",      "decayStartTimestamp":"1716935571901",      "decayEndTimestamp":"1716935572901",      "nikePublicKey":"04c631d017981efdc0c319b475de36389a10ede86fbbc9adcf573844a858ce8ddcddb41306eb9c34ec4ee9bc0234f7e30684bf389142437166d407e47974d5cbf7",      "commitmentDigest":"08a98d4c9d45f8431b46d99a23e6e8f82601ccf0773499d4e47bcd857cad92a6",      "commitmentSignature":"cfc1e4e2ea9cc417027ed5846fa073c8e6031f70f91ffa9b92051b5b7738c0500d8fefb0fc189bce16004b3c0e1c4cfa41260968161adf8b55446ed5c40d1ac51b",      "commitmentProviderAddress":"0x1234567890123456789012345678901234567890",      "sharedSecret":"0x1234567890123456789012345678901234567890",   }}
```

The commitment consists of the details associated with the bid along with signatures made by the provider.

The provider generates a digest from the commitment, signs it with their private key, stores the digest and signature as an encrypted commitment on the mev-commit chain, and sends the commitment back to the originating bidder via the P2P network.

Copy

```solidity
{   "result":{      "commitment":"08a98d4c9d45f8431b46d99a23e6e8f82601ccf0773499d4e47bcd857cad92a6",      "signature":"cfc1e4e2ea9cc417027ed5846fa073c8e6031f70f91ffa9b92051b5b7738c0500d8fefb0fc189bce16004b3c0e1c4cfa41260968161adf8b55446ed5c40d1ac51b",   }}
```

---

### **Solvers**

This article explains how third parties, referred to as solvers, can use mev-commit as a tool to offer commitment services to users. By offering commitments, solvers can fulfill a range of user requests, from basic operations such as a preconfirmation for a fast bundle inclusion in the chain to complex operations involving multiple chains. Solvers aim to abstract these detailed processes from end-users, who may lack the expertise to perform these operations independently. Here we discuss how solvers can help users secure commitments for their transaction bundle.

Commitments serve various purposes. They can benefit a searcher looking to profit from an arbitrage opportunity by getting a preconfirmation or a regular user wanting to sell assets on Ethereum while buying assets on Solana at the same time. We anticipate sophisticated actors to interact directly with mev-commit to request and acquire the necessary commitments from providers to fulfill their needs, abstracting the commitment bidding and receiving process from end users.

We assume there is a single solver (called the “leader”) performing operations on behalf of the users. The leader can be selected in various ways, such as through an auction or a lottery.

## **Sourcing and Handling Commitments**

The solver leader interacts with its users and the mev-commit protocol by receiving user’s messages and transforming them into mev-commit bids. The solver then tries to source commitments for the bid on the mev-commit protocol. Once the commitments are successfully acquired, there are three main ways the solver can handle them. We describe each of them next.

1. The solver accumulates the commitments it receives for each bid and it only sends a commitment to the user if/when it manages to source commitments from all the providers for a bid. In this case, we say the commitment is credible as it was issued by all the providers in mev-commit.
2. The solver relays all the commitments it receives from the providers back to the user. In this case, the commitments the user gets are “weak commitments” because they are tied to specific providers, unlike the credible commitment from above.
3. The solver can immediately send a commitment to the user (if it chooses to) even before getting commitments from the providers. In this case, the solver issues a commitment to the user optimistically and is responsible for sourcing the commitments from all the providers. If the solver cannot source the commitments from the providers, it may be penalized by having its collateral slashed.

The approaches mentioned above would most likely differ in the economical aspects and should be priced differently by the solver. An interesting future direction is to analyze the game-theoretical aspects that each approach encompasses. For instance, understanding the strategies and trade-offs a solver must consider when deciding how to manage their bids and commitments, or how different pricing models might affect the user experience and the overall efficiency of the process.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/Solver.png)

The solver acts as a “middle layer” between users and the mev-commit network. Users express their intention to the solver which then creates mev-commit bids based on these intentions and work towards sourcing the corresponding commitments from the providers on the mev-commit protocol.

---

### **Builder Attribution**Understanding how builders are identified and attributed in mev-commit

# **Builder Attribution**

Builder attribution in the mev-commit system involves identifying the provider responsible for building an L1 block. This is crucial for ensuring that rewards and slashing mechanisms are correctly applied based on the commitments made by providers.

## **How Builder Attribution Works**

### **Oracle and Builder Attribution**

The oracle plays a central role in verifying whether commitments made by providers are fulfilled. It does this by:

- Querying the PBS relay to obtain block delivery data and associated BLS keys
- Cross-referencing block hashes from L1 with those delivered via the relay
- Identifying the builder through their registered BLS key when block hashes match
- Validating commitments against the identified builder in the mev-commit system

This system ensures accurate provider attribution for block building and appropriate distribution of rewards or penalties based on commitment fulfillment.

---

### **Bid Structure**

The bid payload sent to the internal mev-commit API is as follows:

| **Key**                   | **Description**                                                  |
| ------------------------- | ---------------------------------------------------------------- |
| **`txHashes`**            | Array of transaction hashes as strings                           |
| **`amount`**              | Bid amount in wei                                                |
| **`blockNumber`**         | L1 block number targeted for bid inclusion                       |
| **`decayStartTimestamp`** | Start timestamp for bid decay (in Unix milliseconds)             |
| **`decayEndTimestamp`**   | End timestamp for bid decay (in Unix milliseconds)               |
| **`revertingTxHashes`**   | Array of transaction hashes as strings that can revert           |
| **`rawTransactions`**     | Array of raw signed transaction payloads                         |
| **`slashAmount`**         | Amount to be slashed from provider stake in case of a failed bid |

Only one out of the **`txHashes`** or **`rawTransactions`** need to be provided in the bid. If the **`rawTransactions`** is given, the **`txHashes`** are inferred from it.

**Example bidCopy**

`{    "txHashes": ["0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacae", "0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacaf","0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4effff"],    "amount": "100040",    "blockNumber": 133459,    "decayStartTimestamp": 1716935571901,    "decayEndTimestamp": 1716935572901,    "revertingTxHashes": ["22145ba31366d29a893ae3ffbc95c36c06e8819a289ac588594c9512d0a99810"]}`

**Example bid with raw transaction payloadsCopy**

`{    "rawTransactions": ["0x02f8db82426882010c8410433624841043362f8303425094ea593b730d745fb5fe01b6d20e6603915252c6bf87016e03ce313800b864ce0b63ce0000000000000000000000000e94804eaa3c4c5355992086647f683f6f41ef1f000000000000000000000000000000000000000000000000000150e0786cc000000000000000000000000000000000000000000000000000000000000004e378c001a0ece6d13b20247abdc07d669c9186ee5a1ac9601db8c98a3323024ab299cb6662a01c20680efe4e0bb48a3a936b5ab27c741819f0ac567b12b34b230004b20b78a0", "0x02f8748242682c841043362684104336318252089412b141665da4a5f617c759ad996ef91ad806a9c0880de0b6b3a764000080c001a0806552ed846808580eb896994825f07e73de2f42e2d3554f228284ecfaa89d9ca046d58b62ba565982fb07a64b436dd7a6c210b2f59c4fb2aee2cdd150ccf8bfaa"],    "amount": "100040",    "blockNumber": 133459,    "decayStartTimestamp": 1716935571901,    "decayEndTimestamp": 1716935572901,    "revertingTxHashes": ["22145ba31366d29a893ae3ffbc95c36c06e8819a289ac588594c9512d0a99810"]}`

The final bid structure includes a hash and signature that is auto-constructed by your mev-commit bidder node and looks as follows.

Copy

`{   "txHash":"0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacae,0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacaf,0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4effff",   "bidAmount":277610,   "revertingTxHashes":"22145ba31366d29a893ae3ffbc95c36c06e8819a289ac588594c9512d0a99810",   "blockNumber":2703,   "digest":"uU2p20f5KmehWqpuY1u+CbhcS8jNwdQAJQe2dh0Vnrk=",   "signature":"nY6jYsGPxj6LVlSVQJbZcxvmRrw8Ym5rqOL1x0W/xPlJGBaF/ZzzjkxiioY/MDiRGvlflSWeoT0fh3aIJiJxAhw=",   "decayStartTimestamp":1716935571901,   "decayEndTimestamp": 1716935572901,   "slashAmt":0,   "rawTransactions":["0x02f8db82426882010c8410433624841043362f8303425094ea593b730d745fb5fe01b6d20e6603915252c6bf87016e03ce313800b864ce0b63ce0000000000000000000000000e94804eaa3c4c5355992086647f683f6f41ef1f000000000000000000000000000000000000000000000000000150e0786cc000000000000000000000000000000000000000000000000000000000000004e378c001a0ece6d13b20247abdc07d669c9186ee5a1ac9601db8c98a3323024ab299cb6662a01c20680efe4e0bb48a3a936b5ab27c741819f0ac567b12b34b230004b20b78a0"],   "nikePublicKey": "04c631d017981efdc0c319b475de36389a10ede86fbbc9adcf573844a858ce8ddcddb41306eb9c34ec4ee9bc0234f7e30684bf389142437166d407e47974d5cbf7"}`

Note that the deposit amount a bidder has set needs to be 10 times higher than the amount in the bid.

## **Details on Bid Structure**

| **Property**        | **Description**                                                  |
| ------------------- | ---------------------------------------------------------------- |
| txnHash             | Array of transaction hashes represented as strings               |
| bidAmount           | Amount to bid in wei                                             |
| blockNumber         | L1 target block to have bid included                             |
| decayStartTimestamp | Start timestamp for bid decay (in Unix milliseconds)             |
| decayEndTimestamp   | End timestamp for bid decay (in Unix milliseconds)               |
| bidDigest           | Hash of the bid                                                  |
| bidSignature        | Signed bidВigest = sign(bidDigest, signingKey)                   |
| nikePublicKey       | NIKE public key of the bidder, autogenerated for each bid        |
| revertingTxHashes   | Array of transaction hashes as strings that can revert           |
| rawTransactions     | Array of hexadecimal encoded raw signed transaction payloads     |
| slashAmount         | Amount to be slashed from provider stake in case of a failed bid |

### **Details on Decay Parameters**

The **`decayStartTimestamp`** and **`decayEndTimestamp`** parameters allow bidders to control the range over which their bid decays.

Due to inherent network delays, preconfirmation times can range between 50 to 250 milliseconds even if providers commit immediately after seeing the bid. To account for this, you might want to set your **`decayStartTimestamp`** approximately 300 milliseconds in the future. However, setting this delay is not mandatory and should be adjusted based on your strategic preferences for bid timing and pricing. For more detailed information about the decay mechanism, refer to the [**Bid Decay Page**](https://docs.primev.xyz/v1.1.0/concepts/bids/bid-decay-mechanism).

### **Details on Encrypted Bid Structure**

The bid structure is encrypted using an AES key, which the bidder P2P node generates at the start, and is then sent to the provider.

Copy

`{    "ciphertext": "5750d8af6296296f1147f5e11f47f253f376dea3fd5c2760cd82bd82a7066a8fe1c84f48a4e738d1df7c0e64f930c6b0b642800156e453a501c8b993951fcb50fe0b9fce4a2046838f499317a6018eb59abd5e84dbe3b7e296d4e0e70ef3bb221af7afe341908dbd02e8c91b4eff935b2697208f51ccacf5fe744c199afca687d85850a2e12a75433510dccda9258612348c586e971cc521486806ea25ec94d5fa7038beda3f532970e7b06198deef96677af3a6889c84d657585a9eefd224961f87a3353ad4ede4a7368e2e5bc9571d320a8a3be0f1e08e769f9bb2da6fb76c81cd"}`

---

### **Reverting txns**

## **Reverting Transactions**

Transactions are by default execution commitments when put in the bid payload. The **`revertingTxHashes`** field is used to describe transactions that you would like to allow to not need to be executed.

When you include transaction hashes in the **`revertingTxHashes`** array, you are indicating that these transactions can be reverted if necessary. This can be useful in scenarios where certain transactions are optional or conditional, and their execution is not strictly required for the bid to be valid.

Here is an example of how to include reverting transactions in your bid payload:

**Example bidCopy**

`{    "txHashes": ["0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacae", "0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4eacaf","0549fc7c57fffbdbfb2cf9d5e0de165fc68dadb5c27c42fdad0bdf506f4effff"],    "amount": "100040",    "blockNumber": 133459,    "decayStartTimestamp": 1716935571901,    "decayEndTimestamp": 1716935572901,    "revertingTxHashes": ["22145ba31366d29a893ae3ffbc95c36c06e8819a289ac588594c9512d0a99810"]}`

In the example above, the **`revertingTxHashes`** field is used to specify a list of transaction hashes that can be reverted if necessary. This field is an array of strings, where each string represents a transaction hash.

In this particular example, the **`revertingTxHashes`** array contains a single transaction hash: **`"22145ba31366d29a893ae3ffbc95c36c06e8819a289ac588594c9512d0a99810"`**. This means that the transaction with this hash can be reverted if needed, without invalidating the bid.

By including the **`revertingTxHashes`** field, bidders can provide flexibility in their bids, allowing certain transactions to be reverted if necessary, which can be useful in various scenarios where transaction execution is conditional or optional.

---

### **Understanding Bidder Deposit Rules**

Bidders need to deposit funds to be able to place bids on the mev-commit network. As bids are posted privately, providers cannot determine how much bidders have bid previously. To still ensure that bidders can cover all their bids, we bind deposits to specific L1 block numbers. Providers con thus ensure that bids from a given bidder do not exceed the amount deposited for the corresponding L1 block number. It is important to note that if a bidder deposits, for example, 1 ETH for some L1 block number, they can post bids totaling 1 ETH for each provider. This is because only a single provider can post the block to L1, meaning bids made to other providers will not be executed.

To simplify the user experience, mev-commit considers windows consisting of blocksPerWindow=10blocksPerWindow=10 blocks and splits deposits to a window evenly over the corresponding blocks.

The remaining funds of a bidder from a window (if any) can be unlocked after the corresponding blocks have been settled. The bidder can then withdraw the funds from the deposit. To further ease the user experience, bidders can enable autodeposits in their nodes, to automatically withdraw deposits from previous windows and redeposit them into future ones.

## **Current window number**

The window number for a given L1 block can be calculated via the following formula, where **`blocksPerWindow`** is equal to 10 and **`blockNumber`** is the L1 block number for which the bidder wants to bid:

blockNumber−1blocksPerWindow+1

blocksPerWindowblockNumber−1+1

## **Minimum Deposit**

Since deposits are split across blocksPerWindow=10blocksPerWindow=10 L1 blocks, bidders have to deposit at least 10 times the amount they want to bid for a single block.

In the case of autodeposit, the deposits would be locked for around 3 windows at a time. Therefore, the total amount locked would be 30 times the amount.

## **Withdrawal Time**

The earliest withdrawal time can be calculated as follows: the withdrawal start time plus 20 L1 blocks (which is 240 seconds or 4 minutes) and the oracle lag of 10 L1 blocks (which is 120 seconds or 2 minutes), totaling 360 seconds or 6 minutes. Therefore, the total time before funds can be withdrawn is approximately 30 blocks (6 minutes) from the initial deposit.

## **Deposit/Withdrawal Flow**

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/bidder-deposit.png)

This diagram illustrates the process and timeline of bidding, settlements, and withdrawals within mev-commit system, structured around a series of windows.

### **Diagram Description**

### **Timeline of Blocks**

- The horizontal axis represents a sequence of windows.
- Windows are labeled as **`n-2`**, **`n-1`**, **`n`** and **`n+1`**, indicating their position relative to the current window **`n`**.

### **Current Window**

- The “Current Window” is the interval within which bidding occurs.
- The window consists of 10 L1 blocks.

### **Bidding Phase**

- Bidding occurs in the current window, starting from the current block **`n`** and extending into the future blocks (**`n+1`**, etc.).
- The arrow labeled “Bidding” points to the right, indicating that bidding continues into future blocks.

### **Settlements Phase**

- Settlements happen after the bidding window closes.
- The arrow labeled “Settlements” points downward, showing the transition from the bidding phase to the settlement phase.

### **Withdrawals Phase**

- Withdrawals occur after settlements are completed.
- The arrow labeled “Withdrawals” points to the left, indicating the final phase where bidders can withdraw their remaining funds.

---

### **Bid Decay Mechanism**Learn about how bids decay in value in real time

In the mev-commit auction for transaction bundles, bidders submit their bids to providers and their goal is to receive a confirmation that the bundle they bid for will be included in the next block produced by the provider. Bidders aim to receive confirmation for their bundle as soon as possible since early confirmations tend to be more valuable to the bidders. However, providers may want to wait until the last moment to issue confirmations in order to build the most valuable block possible without missing out on any late bids.

Therefore, it’s essential to have a mechanism that encourages providers to confirm bids as early as possible. This is where a bid decay mechanism comes into play, which reduces the value of a bid based on the time elapsed since it was issued.

## **Mechanism Description**

Every bid has two timestamps attached to it: **(1)** a timestamp indicating the exact time of dispatch of the bid, and **(2)** an expiry timestamp, marking the moment when the decay for this bid reaches 100%—essentially, the point in time beyond which the bidder is unwilling to pay anything to a provider for a commitment.

The timestamp is specified in Unix milliseconds. For example, a timestamp of **`1633046400000`** represents **`October 1, 2021 00:00:00 GMT`**.

When a provider decides to commit to the bid, they must issue a commitment and also assign a “commitment timestamp” to it. This commitment is then sent to the mev-commit chain for inclusion. The mev-commit chain will include the commitment into the chain, however the commitment will only be considered valid if the commitment timestamp supplied by the provider is not “too old” in comparison to the block timestamp where the commitment was included, or more formally, their difference is within some time interval ΔΔ.

This time parameter ΔΔ is set to be 500500ms, and its goal is to account for the latency in message delivery among nodes and the discrepancy between the commitment and block timestamps. More precisely, for validation of a commitment it is required that tb−tc≤Δ*tb*−*tc*≤Δ, where tc*tc* denotes the commitment timestamp and tb*tb* denotes the timestamp of the block where the commitment was included. Note that even when tc>tb*tc*>_tb_, i.e., the commitment timestamp was set to be greater than the timestamp of the block that it was included, the commitment is still considered valid.

## **Computing the Bid Decay**

Once the commitment is included in the chain it can be publicly determined if the commitment is valid, and if so, what is the exact value that the bid has decayed.

The bid’s value decreases linearly from the moment it is issued until its expiry deadline is reached. Below we show a diagram of how providers can use the timestamps to first compute the proportion to which a commitment has decayed. Once the proportion has been computed the value of the bid can be decayed accordingly.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/bid-decay-proportion.png)

For example, if the decay proportion is 1/21/2 as in the example above, the bid’s value decays by 5050%.

In general, when a provider issues a commitment at time t*t* for a bid with amount bidAmtbidAmt, the bidder pays the provider the value v*v* computed as

v=bidAmt⋅decayEndTimestamp−tdecayEndTimestamp−decayStartTimestamp,

_v_

=bidAmt⋅decayEndTimestamp−decayStartTimestampdecayEndTimestamp−

_t_

,

constraint to 0≤v≤bidAmt0≤*v*≤bidAmt, i.e., the value v*v* paid is never more than bidAmtbidAmt.

## **Analysis of the Mechanism**

The security of the mechanism comes from the fact that the participating parties have conflicting incentives. In particular, we note that there is no incentive for the bidder to manipulate the choice of the bid’s timestamps; if the bidder includes a timestamp in the future, then the provider essentially gets less decay (i.e., the bidder pays more). If the bidder includes a timestamp that is too old, then the provider can choose to not commit as the decay is too high (then the bidder gets no commitment). Moreover, we note that this would have the exact same effect as the bidder changing the price of its bid prior to the submission of the bid. Similarly, the commitment timestamp set by the provider must not be too old, as otherwise, it won’t be valid when included in the mev-commit chain.

In many network-based systems, including our decay mechanism, faster connections often provide better opportunities, such as quicker access to information or response times. This situation is similar to high-frequency trading in financial markets, where traders with faster connections can outperform others. In our system, any advantage due to a faster connection is bounded by the parameter ΔΔ.

## **Properties of the Mechanism**

Our decay mechanism design achieves the following properties:

**1. Predictability of Decay:** The providers can *accurately compute* how much their decay will be for a commitment.

**2. Public Verifiability of Decay**: The decay mechanism offers public verifiability, as the decay amount can be calculated using the public timestamps from the bid and the commitment.

**3. L1 Synchrony Independent:** Our decay mechanism maintains independence from the L1 actual slot time, ensuring that the decay mechanism functions correctly regardless of whether the L1 block confirmation occurs more quickly or experiences delays.

**4. Just in time (JIT) Awareness of Bid:** JIT awareness of a bid ensures that the decay mechanism operates independently of the bid’s submission time within the network, meaning a bid can be sent at anytime during a slot and experience correct decay. This is achieved by specifying the onset of decay and its deadline directly within the bid’s structure, thus guaranteeing the mechanism functions as designed, irrespective of the bid’s dispatch time.

---

### **Chain Details**

The mev-commit chain is live on [**mainnet**](https://docs.primev.xyz/v1.1.0/developers/mainnet). To test and experiment, join the testnet and get familiar with its functionalities at the [**testnet**](https://docs.primev.xyz/v1.1.0/developers/testnet) section.

## **Design**

Mev-commit chain is currently built out as an Ethereum sidechain run with [**go-ethereum’s Clique proof-of-authority consensus mechanism**](https://geth.ethereum.org/docs/tools/clef/clique-signing). It’s not a generalized chain for everyone to launch dapps on, but only for specific execution service applications, such as preconfirmations, top of block, bottom of block, or other services.

Source code for the geth fork which runs the mev-commit chain can be found in the [**mev-commit-geth repo**](https://github.com/primev/mev-commit-geth).

## **Progressive decentralization**

Today, most or arguably all Ethereum scaling solutions rely on centralized bridging and sequencing. Mev-commit components rely on existing tech, and consequently inherit this property. However anyone can permissionlessly validate correct execution, and operation of chain infrastructure. Moreover, because the mev-commit p2p network is decentralized and commitments are cryptographic, actors can theoretically settle commitments without the mev-commit chain.

At this point of the network’s inception, Primev entities will run all validating infrastructure for the mev-commit chain. Correct and honest operation can be permissionlessly audited by spinning up a full node and connecting to the mev-commit chain as a peer. Over time we plan to have entities outside of Primev to become POA signers or bridge validators to progressively decentralize the centralized components of the system.

The mev-commit chain will continue to evolve. We have ongoing research into consensus algorithms we can employ to decentralize the mev-commit chain without compromising on speed. Open source scaling solutions that prove to be practical, decentralized, and meet security thresholds will be considered to decentralize the mev-commit chain.

## **POA geth nodes**

Primev currently maintains a mev-commit-geth bootnode which doesn’t participate in consensus, and a set of full-node POA signers that run consensus. These signers take turns proposing the next block by utilizing a waiting period.

The current target block period is 200ms, meaning about 60 mev-commit chain blocks will be committed for every Ethereum mainnet block. The block time will likely change as enhancements are added and chain state grows.

## **Fee Mechanism**

**Non-inflationary**: The fee mechanism on the mev-commit chain is non-inflationary, maintaining a strict 1:1 peg between sidechain ether and L1 escrowed ether. This is achieved through a variation of EIP-1559, where both the base and priority fee accumulate to a treasury account (preconf.eth address).

## **Smart Contracts**

Smart Contracts are deployed on the mev-commit chain to enable use cases, follow bid and commitment states, and invoke rewards or slashing as needed. Anyone can deploy contracts on the mev-commit chain, however there’ll be additional integration work needed with mev-commit off-chain components to fully enable the use case under the current design. Thus we first recommend getting in touch with the Primev team to enable a use case at this stage of the network.

Currently deployed contracts are designed as follows:

- A preconfirmation contract allows preconfirmation commitments to be stored and tracked on-chain.
- Two separate registry contracts exist to manage bidders and providers, both parties must stake ETH to participate. Rewards and/or slashing are managed by these contracts.
- An oracle contract receives L1 payloads from the oracle service. It currently operates by checking confirmed mainnet blocks.
- An block tracker contract which designed to track Ethereum blocks and their respective winners.

## **Oracle service**

The oracle service is an off-chain process that interacts with the oracle contract as needed. This service monitors and extracts the winning builder and corresponding transaction hash list from each L1 block, and submits this data to the oracle contract residing on the mev-commit chain.

This is a centralized oracle currently operated by Primev. We’re actively looking into decentralizing the oracle role through existing decentralized Oracle protocols and evaluating creating a service where this can be decentralized.

---

### **Differences Between Ethereum and mev-commit Chain**

## **Introduction**

Mev-commit chain is an Ethereum-compatible blockchain designed to provide faster transaction processing and lower fees. It aims to optimize the extraction of Maximal Extractable Value (mev) by utilizing a specialized architecture. This document highlights the key differences between Ethereum and mev-commit chain.

## **Overview**

The following table provides an overview of the key features and differences between Ethereum and mev-commit chain:

| **Feature**      | **Ethereum**                                                                                                             | **Mev-Commit Chain**                                                                                                                            |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Mempool          | Larger mempool size                                                                                                      | Smaller mempool size, transactions may be encrypted, limited chain mempool visibility due to fewer chain node operators                         |
| Validators       | Decentralized proof of stake system with a large number of validators                                                    | Centralized setup with only two validator nodes creating blocks in a round-robin fashion, allowing for faster consensus and block production    |
| Opcodes          | Supports Ethereum opcodes                                                                                                | Supports all Ethereum opcodes, ensuring compatibility with existing Ethereum smart contracts and tools                                          |
| Consensus        | Uses proof of stake consensus, prioritizing decentralization                                                             | Uses clique proof of authority consensus, where authorized validators take turns creating blocks, prioritizing performance and fast block times |
| Block time       | 12 seconds                                                                                                               | 200 milliseconds                                                                                                                                |
| Transaction Fees | Supports both legacy and EIP-1559 transactions, with base fee being burned and priority fee going to the proposer/signer | Supports both legacy and EIP-1559 transactions, with base fee directed to the protocol treasury and priority fee going to the proposer/signer   |

### **Transaction Fees**

Like Ethereum, mev-commit chain supports both legacy and EIP-1559 transactions, with a preference for EIP-1559.

The allocation of fees differs:

- The base fee is directed to the protocol treasury, instead of being burned.
- The priority fee goes to the proposer/signer, as in Ethereum.

### **Mempool**

Mev-commit chain’s mempool is smaller compared to Ethereum’s. While the mempool is public, transactions may be encrypted, and chain mempool visibility is limited due to the presence of only a few chain node operators. This reduces the potential for front-running and other mev-related activities.

### **Number of Validators**

Mev-commit chain currently operates with only two validator nodes that create blocks in a round-robin fashion. This centralized setup allows for faster consensus and block production. However, it also introduces a higher level of trust in the validators compared to Ethereum’s decentralized proof of stake system.

### **Opcodes**

Mev-commit chain supports all Ethereum opcodes, as it consists of Ethereum nodes. Opcodes are low-level instructions that define the operations a blockchain can perform. By supporting all Ethereum opcodes, mev-commit chain ensures compatibility with existing Ethereum smart contracts and tools.

### **Consensus**

Mainnet Ethereum uses proof of stake, while mev-commit chain currently uses clique proof of authority consensus. In clique proof of authority, a set of authorized validators take turns creating blocks. This consensus mechanism prioritizes performance and fast block times over decentralization.

## **Conclusion**

Mev-commit chain offers a specialized blockchain environment optimized for mev extraction. With faster block times, a different fee structure, and a centralized validator setup, mev-commit chain provides an alternative to Ethereum for use cases that prioritize speed and mev optimization.

---

### **Bridging Details**

# **Understanding Bridging Mechanisms**

The mev-commit chain utilizes a standard bridging mechanism to ensure a secure and efficient transfer of ETH between mainnet Ethereum and the mev-commit chain.

We envision mev-commit to eventually integrate with a multitude of interoperability protocols (think wormhole, layerzero, etc.). In the meantime Primev has implemented its own lock/mint bridging protocol as described below.

## **Lock/Mint Peg**

Native ETH on the mev-commit chain maintains a 1:1 peg with ETH on L1. The only way to mint ETH on the mev-commit chain is to lock an equivalent amount on L1. ETH can be burned on the mev-commit chain to release/receive an equivalent amount on L1.

## **Security**

There are inherent security assumptions in bridging ETH to the mev-commit chain. While these are similar to other bridge trust assumptions, we’ve listed them below:

- Liveness of the bridge relayer actor.
- POA signers that maintain mev-commit chain state.
- Correctness of Primev’s [**standard bridge protocol**](https://github.com/primev/mev-commit-bridge/tree/main/standard/bridge-v1) and integration into the mev-commit chain.

Our standard bridge implementation has been audited by Cantina. More details can be found [**here**](https://blog.primev.xyz/Battle-Testing-mev-commit-Key-Findings-from-Our-Spearbit-Security-Review-1436865efd6f8025bd6ce3824349821d).

## **Importance of Origin Chain Security**

**Selective Bridging**: Only bridges originating from Ethereum L1 should be allowed to mint native ETH on the mev-commit chain. This is to prevent the impact of compromised states on other chains affecting the mev-commit chain.

## **Bridge Contracts**

See **Bridge Contracts** section of [**contracts page**](https://docs.primev.xyz/v1.1.0/developers/contracts) to gain context on contracts necessary to enable bridging.

## **Relayer**

The main off-chain component of the bridge is the relayer. Primev currently operates the relayer, with open-sourced implementation [**here**](https://github.com/primev/mev-commit/tree/main/bridge/standard).

---

### **Rewards and Slashing**

The providers and validators that opt-in to the mev-commit protocol are incentivized to act honestly and follow the protocol. This honest behavior is enforced by a reward and slashing mechanism. Both the providers and the validators are required to stake or restake a certain amount of tokens to participate in the mev-commit protocol. The mechanism is designed to reward providers for fulfilling their commitments and to penalize them for breaking them. It also disincentivizes providers from issuing commitments that they cannot fulfill. Additionally, validators can be penalized if they fail to propose a block from mev-commit registered block builders on the L1 chain.

Validators have three methods to opt-in to mev-commit, as described in the [**validators section**](https://docs.primev.xyz/v1.1.0/get-started/validators). The staked (or restaked) tokens are used to secure the mev-commit protocol and to incentivize validators to include blocks built by mev-commit providers in the L1 chain. Crucially, if the validator acts maliciously on the mev-commit protocol they can be slashed and lose a portion of their staked (or restaked) tokens. Next, we discuss the rewards and slashing mechanisms for validators and providers in more detail.

The risk of getting slashed is very low for validators, unless they intentionally behave dishonestly. This has been confirmed by an [**independent report on the risk/reward profile of mev-commit by Chaos Labs**](https://governance.ether.fi/t/primev-symbiotic-risk-analysis/).

## **Validators/Proposers**

A validator that opts into mev-commit makes an implicit commitment to include a block from a mev-commit registered block builder in L1 whenever they become the proposer of the slot.

### **Rewards**

There are two categories of rewards for validators opting in to mev-commit:

1. Increased yield
2. [**Points**](https://docs.primev.xyz/v1.1.0/concepts/rewards-and-slashing/points)

The main reward for proposers opting in to mev-commit is increased yield by proposing a more valuable block, paid through the mev-boost auction. Upon proposing a block while opted-in to mev-commit, a proposer will receive all bid related value in the mev-commit network that is surfaced by the mev-boost auction embedded in the block they propose. In other words, proposers passively receive rewards from mev-commit by proposing more valuable blocks that include increased value from mev-commit bids. A proposer will almost always propose a more valuable block using mev-commit than without while mev-commit bids are present for its slot.

Using an example of a block worth 1 ETH and mev-commit bids worth 0.1 ETH, the diagram below depicts Validator Rewards with and without mev-commit:

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/validator-rewards.png)

An important observation here is that proposers opting in increases the credibility of the preconfs and consequently their value. Due to the increased preconf values, the providers have additional value to bid in the mev-boost auction, thus driving up the total revenue a proposer will get.

### **Slashing**

Validators are generally **not expected to be slashed** on mev-commit unless they act maliciously, as providers on mev-commit are the primary decision makers liable for any slashing. The only case for a proposer slash is acting maliciously or using an unsupported relay / validator sidecar misconfiguration. For missed blocks or self-built blocks, mev-commit does not slash proposers. We detail these cases below.

### **Missed Block**

A proposer can completely miss its slot and not include any block in L1. This can happen either due to network issues by the proposer, due to the relay not delivering the block’s contents on time, or due to chain reorgs. In any case, mev-commit does not slash the proposer for missing a block as the proposer does not profit from omitting a block and it is potentially out of their control.

### **Included Block Not Built by mev-commit Provider**

A proposer can include a block in L1 that was not produced by a mev-commit provider. This can happen for the following reasons:

1. The proposer includes a block from a builder that is not participating in the mev-commit protocol. This can be due to a malicious behavior by the proposer or due to the proposer using a relay that is not compatible with mev-commit (and thus delivering blocks not built by mev-commit providers).
2. The proposer includes a block that was built by itself.

Case (1) is considered non-compliant behavior and thus the proposer will be slashed from their stake the fixed amount of 1 ETH.

Case (2) should only happen very rarely when the value of the block it receives from the relay is too low, and mev-commit will not slash proposers in this case. However, due to the lack of a robust mechanism for builder attribution of a block in Ethereum’s PBS, we will monitor how often proposers choose to build their own blocks, and if needed we will revisit this decision to discourage misbehavior by the proposers.

Currently, the restaking case with Eigenlayer only allows the stake to be frozen for an undetermined period of time and not slashed permanently (i.e., burned). While the stake is frozen, the proposer is not able to participate in mev-commit. The proposer can pay a fee to unfreeze its stake. This is a limitation of the current Eigenlayer implementation, and it is expected to be resolved.

## **Providers**

There are four possible outcomes after a commitment is made by a provider and an Ethereum block is proposed:

1. The bid amount is rewarded to the provider for fulfilling the commitment.
2. The provider stake is slashed for breaking the commitment.
3. Nothing happens as neither the provider nor the bidder opened the commitment.

We discuss each case in more detail below.

### **Rewards**

Upon successfully fulfilling a commitment, a provider will be rewarded the bid amount, minus a 2% fee (this fee accumulates in the mev-commit protocol treasury). This reward is paid by the mev-commit oracle to the provider’s account after the corresponding slot is settled by the oracle according to the block included in L1.

### **Slashing for Broken Commitment**

Upon breaking a commitment, a provider will be slashed from their stake equal to the bid amount they committed to (taking into account the bid decay), including a 5% penalty fee. The principal slash amount will be transferred to the bidder for the broken commitment, and the penalty fee will be transferred to the mev-commit protocol treasury. If the provider does not have enough stake left to cover the entirety of the slashing penalty and the bid amount, the maximal amount of the bid amount that can be slashed will be slashed and given to the bidder. Any remaining funds in the provider’s stake will go towards maximally paying the 5% slashing penalty to the treasury. The precedence means the bid amount slashing that goes to the bidder will be prioritized first, and only after that will the treasury be compensated for as much of the 5% slashing penalty as possible.

### **Neutral Outcome**

The protocol does not take action on commitments that are not opened by the provider or the bidder. This happens if the commitment provider is not the execution provider for the corresponding winning block, in which case there is no point in opening the commitment.

## **Builder and Proposer Attribution**

We rely on the BLS key used to submit to the relay to do attribution and determine the block builder for a particular block.

---

### **mev-commit Points Program**

The **`mev-commit`** Points Program rewards validators who opt-in and remain actively opted-in. Points accrue over **6-month Seasons**, with each Season offering base points plus growing multipliers. All points will be visible on the [**Validator Dashboard**](https://validators.mev-commit.xyz/) like the screenshot below. Read more to learn how points are awarded and how to maximize your total.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/dashboard-points.png)

## **Quick Overview**

- **Immediate Reward:** Earn **1,000 points** per validator right when you opt in.
- **6-Month Seasons:** Completing an entire Season nets you up to **10,000 points** total in Season 1, and double for following seasons.
- **Multipliers:**
  - Season 1: base schedule (see table below).
  - Season 2 & 3: rewards are **2×** each month’s total.
- **Opt-Out Penalties:** If you opt out early during a season, you keep the **base points** for fully completed months but **lose** that month’s multiplier.

Stay opted in with as many validators through all seasons for the maximum multiplier bonus.

---

## **Monthly Accrual (Season 1)**

Below is the monthly schedule for Season 1, showing **cumulative** points if you remain opted in through each month:

| **Month** | **Total Points if Still Opted In at Month End** |
| --------- | ----------------------------------------------- |
| 1         | 1,000                                           |
| 2         | 1,270                                           |
| 3         | 1,530                                           |
| 4         | 1,800                                           |
| 5         | 2,070                                           |
| 6         | 2,330                                           |
| **Total** | **10,000**                                      |

- Points accrue **daily**, but the monthly multiplier is only **finalized** if you remain opted-in through each 6 month Season.
- **Season 2 & 3** double all monthly totals shown above (2x).

## **Points Chart**

Below is a visualization of your points over the planned 3 Seasons. Accrued points represent all points available at the end of a season. Solidified points represent points that will remain with your operator before a Season is over.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/points-chart.jpg)

## **Aggregated Points at Operator Level**

Your dashboard displays **one aggregate total** across all your opted-in validators. Operators can see total points and watch them grow daily.

## **Maximize Points via Partner Protocols**

You can earn additional or parallel rewards when using partner protocols alongside **`mev-commit`**:

- **EigenLayer:** Operators opted-in to the **`mev-commit AVS`** on EigenLayer may earn **`$eigen`** token rewards (based on EigenLayer’s policies).
- **Symbiotic, Mellow, SSV:** Opt-in validators using these protocols to earn points from them AND mev-commit. Points will be available on the Symbiotic dashboard as well.

If you participated in prior **testnet phases**, you may be eligible for extra **genesis points**. Please reach out to our team so we can verify your participation and make your bonus available.

---

## **Opt-Out Scenarios**

- **Before Month Ends**
  - You keep points from previous fully completed months.
  - You **forfeit** any partially accrued points for the current month.
- **Before 6 Months But After Some Full Months**
  - You keep **1,000 base points** for each fully completed month in Season 1, double for subsequent seasons.
  - You **lose** the monthly multiplier for those months.
  - Example: If you leave before the end of a Season, you only keep 1,000 for each completed month without the monthly multiplier.
- **Opting Out and Re-Opting In**
  - A **7-day cooldown** applies for each validator key if you opt out. If you have trouble with this, reach out to our team.
  - Rejoining resets you to Season 1 status.

---

## **Getting Started**

1. **Opt In**
   - Visit the [**Validator Dashboard**](https://validators.mev-commit.xyz/) to onboard.
2. **Stay In**
   - Maintain participation for all seasons to maximize multipliers.
3. **Explore Partner Integrations**
   - Symbiotic, Mellow, SSV, or supporting **`mev-commit AVS`** on EigenLayer for additional rewards.

Participating early and continuously strengthens the network, making each individual’s participation more valuable. Your yield goes up more by opting-in as many validators as you can.

That’s it! Maximize your **`mev-commit`** points and help make Ethereum FAST for everyone. Earn juicy yield AND points!

---

### **Oracle**

**The primary role of the oracle is to ensure that the provider carries through on their commitments.**

The oracle consists of two parts:

- A smart contract component [**here**](https://github.com/primev/mev-commit/blob/main/contracts/contracts/core/Oracle.sol).
- A microservice [**here**](https://github.com/primev/mev-commit/tree/main/oracle).

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/oracle-detailed-overview.png)

The oracle automates the verification of provider commitments and queries the L1 data source for transaction hashes and block extra data. It then cross-references these with commitments logged in the commitments contract, and then verifies adherence using the oracle contract. If a commitment is satisfied, the oracle contract triggers a reward to the provider using the bidder contract; if not, it slashes the provider by interacting with the provider contract.

## **Prior to Oracle Engagement**

Before the oracle can be engaged according to the protocol’s intended sequence of events, several preliminary actions must be taken:

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/oracle-before.png)

**1a.** Simultaneously, the bidder issues an encrypted bid via the mev-commit peer-to-peer network.

_After the bidder’s actions, the provider proceeds to:_

**2a.** Retrieve the encrypted bid from the mev-commit network.

**2b.** Issue an encrypted commitment for the transaction mentioned in the bid.

## **Oracle Happy Path Flow**

When a bid for a transaction (txnj) is circulated through the mev-commit p2p network, and the provider has made an encrypted commitment and then opened it after the L1 block was created, the oracle is activated to verify whether the provider has honored this commitment.

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/oracle.png)

The process is as follows:

1. The provider assembles the complete L1 block, incorporating txnj, to which it previously committed. **Note: If the provider doesn’t get selected to construct the L1 block, the oracle flow does not get triggered.**
2. The oracle microservice fetches the block from the L1 chain and verifies the presence of txnj.
3. Upon confirmation that txnj is included, the microservice notifies the oracle smart contract of the commitment’s fulfillment.
4. The oracle smart contract then initiates the transfer of funds from the bidder’s deposited balance to the provider’s account.

## **Oracle Slashing Path**

In the event that a provider fails to include a committed transaction (txnj) in the L1 block, the oracle slashing path is initiated to penalize the provider for the breach of commitment. This process is outlined below:

![](https://mintlify.s3.us-west-1.amazonaws.com/primev-24/v1.1.0/images/oracle-non-happy.png)

1. The provider is expected to produce an L1 block that includes the committed transaction (txnj). However, if the provider does not include txnj, the protocol moves to the slashing phase.
2. The oracle microservice retrieves the block from the L1 chain and searches for txnj. If the transaction is not found, it triggers the next step.
3. The oracle communicates that txnj was not seen in the oracle contract.
4. The oracle contract, upon receiving this information, initiates the slashing procedure. This involves penalizing the provider by triggering a slash event, which results in the forfeiture of the stake held by the provider contract as a guarantee of honest behavior.
5. The confiscated stake is subsequently allocated to the bidder as compensation for the provider’s failure to include the committed transaction, thereby ensuring that the bidder is recompensed for the provider’s breach of trust.

---

### **Validator considerations**

### **Trust Assumptions**

Opting into the mev-commit protocol signals from a validator that they:

- Trust correctness of execution from the mev-commit chain. See [**mev-commit chain**](https://docs.primev.xyz/v1.1.0/concepts/mev-commit-chain/chain-details) for more information.
- Trust correctness of slashing transactions residing from the Primev operated [**mev-commit-oracle**](https://github.com/primev/mev-commit/tree/main/oracle) service.
- Trust at least one mev-commit opted in relay. [**View the list of supported relays here**](https://docs.primev.xyz/v1.1.0/get-started/validators/validator-guide#supporting-relays).
- Attest they will follow the rules of the protocol given the above trust assumptions. This currently entails *only* proposing blocks that come from a mev-commit opted in relay.

### **Risks**

While mev-commit is generally not set up to slash validators, validators opting into the mev-commit protocol should be aware of the following risks:

- **Trusted Relay block delivery:** Relays could break your trust and communicate blocks that do not abide by existing commitments. This would lead to slashing of the validator.

### **Future plans**

While mev-commit AVS is passive and doesn’t require operators to run any software today, Primev is researching means to decentralize centralized components of the mev-commit stack. Stay tuned for more updates on this.
