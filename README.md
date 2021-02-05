# zkDAI
A project where we will analyze ways to anonymize crypto currency (such as xDAI) transactions using zero knowledge proofs.

## 1. Step: Understanding smart contracts

To enter the world of crypto-currencies, we have designed our own Smart Contract in Solidity as a first step. 
Our newly invented currency is called "FlensCoin". 
With the help of the [Solidity-IDE "Remix"](https://remix.ethereum.org/) you can test our created contract (flenscoin.sol).
For testing on a test network you will need to install the [MetaMask Chrome extension](metamask.io) which allows using several testing networks.

## 2. Step: Setting up a test environment for a fork of xDAI

To get in touch with the implementation of a zero knowledge supported crypto currency, we will try to set up our own test network which can be accessed via MetaMask. As soon as our fork of xDAI is up and running on this network, the next will be implementing zero knowledge transactions.

## 3. Step: Set up [zkDAI project created by ETHSingapore](https://github.com/atvanguard/ethsingapore-zk-dai)

As part of a hackathon, ETHSingapore created an application to perform Zero Knowledge DAI transactions on the Ropsten test network. We will try to get the code working for us.


# zkDAI

zkDAI is the prototype stablecoin cryptocurrency that uses so-called "zero knowledge proofs" to ensure completely anonymous transactions over the blockchain. When using standard cryptocurrencies, such as Bitcoin, everyone can easily determine from which address how many BTC were sent to which receiving address via the [Bitcoin Blockexplorer](https://www.blockchain.com/de/explorer). To encrypt these publicly visible parameters, zkDAI uses zkSNARKS (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) proofs. They are sent along with the transaction, being encrypted with a Sha256 hash function, to prove, via a special smart contract, that the contents of the transaction actually match the expected parameters. More about this in our scientific paper about the project. 

