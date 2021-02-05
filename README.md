# zkDAI

zkDAI is the prototype stablecoin cryptocurrency that uses so-called "zero knowledge proofs" to ensure completely anonymous transactions over the blockchain. When using standard cryptocurrencies, such as Bitcoin, everyone can easily determine from which address how many BTC were sent to which receiving address via the [Bitcoin Blockexplorer](https://www.blockchain.com/de/explorer). To encrypt these publicly visible parameters, zkDAI uses zkSNARKS (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) proofs. They are sent along with the transaction, being encrypted with a Sha256 hash function, to prove, via a special smart contract, that the contents of the transaction actually match the expected parameters. To create these proofs as well as the smart contracts we used [ZoKrates](https://zokrates.github.io), a tool specifically designed for Zero Knowledge interactions on the Ethereum blockchain. More about this in our scientific paper about the project. Since our project is not to be tested with any real money, we run all transactions through the Ropsten testnet, for which you can easily get test ETH as well as DAI via a so-called [faucets](https://faucet.ropsten.be/). For the implementation of the project, we mostly used a [hackathon project](https://github.com/atvanguard/ethsingapore-zk-dai) of a Singaporean developer, respectively improved it, since it was no longer executable.
 

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


