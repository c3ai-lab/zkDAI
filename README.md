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

zkDAI is the prototype stablecoin cryptocurrency that uses so-called "zero knowledge proofs" to ensure completely anonymous transactions over the blockchain. When using standard cryptocurrencies, such as Bitcoin, everyone can easily determine from which address how many BTC were sent to which receiving address via the [Bitcoin Blockexplorer](https://www.blockchain.com/de/explorer). To encrypt these publicly visible parameters, zkDAI uses zkSNARKS (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) proofs. They are sent along with the transaction, being encrypted with a Sha256 hash function, to prove, via a special smart contract, that the contents of the transaction actually match the expected parameters. To create these proofs as well as the smart contracts we used [ZoKrates](https://zokrates.github.io), a tool specifically designed for Zero Knowledge interactions on the Ethereum blockchain. Since our project is not to be tested with any real money, we run all transactions through the Ropsten testnet, for which you can easily get test ETH via a so-called [faucet](https://faucet.ropsten.be/).
More about this in our scientific paper about the project. 

## Prerequisities

- Install [Docker](https://docs.docker.com/get-docker/) on your system 
- Clone this repository
- Create a [MetaMask](https://metamask.io/) account

## Setup

The first step is to compile the code inside zk-circuit.zok, which holds the logic for a zero knowledge proof on a blockchain transaction. To do this, simple run

```docker run -ti zokrates/zokrates /bin/bash```

which should start a shell inside the ZoKrates Docker container. Now you have to copy the zk-circuit.zok file into the container.

```docker cp path/of/your/local/zk-circuit.zok zokrates:/home/zokrates/```

Then, inside the ZoKrates container, run:

```zokrates compile -i zk-circuit.zok``` and afterwards:

```zokrates setup```

This will generate the proofing and the verification key, which will be used later.
To create the smart contract that will later approve Zero Knowledge transactions on the blockchain run the following command.

```zokrates export-verifier```

You should now see a newly generated file called verifier.sol. That is the contract which we now want to deploy on the Ropsten testnet. In order to do this, however, we first need to copy it back out of the Docker container.

```docker cp zokrates:/home/zokrates/verifier.sol your/desired/destination/verifier.sol```


