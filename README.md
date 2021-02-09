# zkDAI

zkDAI is the prototype stablecoin cryptocurrency that uses so-called "zero knowledge proofs" to ensure completely anonymous transactions over the blockchain. When using standard cryptocurrencies, such as Bitcoin, everyone can easily determine from which address how many BTC were sent to which receiving address via the [Bitcoin Blockexplorer](https://www.blockchain.com/de/explorer). To encrypt these publicly visible parameters, zkDAI uses zkSNARKS (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) proofs. They are sent along with the transaction, being encrypted with a Sha256 hash function, to prove, via a special smart contract, that the contents of the transaction actually match the expected parameters. To create these proofs as well as the smart contracts we used [ZoKrates](https://zokrates.github.io), a tool specifically designed for Zero Knowledge interactions on the Ethereum blockchain. More about this in our scientific paper about the project. Since our project is not to be tested with any real money, we run all transactions through the Ropsten testnet, for which you can easily get test ETH as well as DAI via a so-called [faucets](https://faucet.ropsten.be/). For the implementation of the project, we mostly used a [hackathon project](https://github.com/atvanguard/ethsingapore-zk-dai) of a Singaporean developer, respectively improved it, since it was no longer executable.
 

## Prerequisities

- Install [Docker](https://docs.docker.com/get-docker/) on your system 
- Clone this repository
- Have node.js installed
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

To deploy the verifier.sol as well as SecretNote.sol and ERC20Interface.sol, go to https://remix.ethereum.org/ and upload the files there. Select the 0.6.1 compiler to compile the three contracts. Now head to the "Deploy & run transactions" tab and deploy verifier.sol and SecretNote.sol to Ropsten. You will need a MetaMask account with some test ETH to "pay" for the deployment.

To now generate the proof of a transaction with ZoKrates, open zokcmd.js and replace the addresses and values on the very bottom of the file (line 55-60) with your desired values and addresses. Then execute zokcmd.js, using:

```node zokcmd.js```

The yielded output are the parameters, that can now be used to generate a proof with ZoKrates. So go back to your terminal window where the shell from the ZoKrates Docker container is running, paste the parameters you just generated there and execute the command. After the process has finished, execute:

```zokrates generate-proof```

ZoKrates will generate a proof.json file, which you need to copy back to your machine like we did earlier (docker cp...).  
While this happens, head back to the Remix browser IDE and open the link to the ropsten block explorer, where you can see the details about the SecretNote contract deployment. You can find the terminal at the bottom of the page. It should look something like this:

```
creation of SecretNote pending...
https://ropsten.etherscan.io/tx/0x73804485f53349e51919a612d9e584028f41e7ac94b3080509a
``` 

When on the Ropsten blockexplorer page, look for the parameter "To:", which reveals the address to which the SecretNote contract was deployed. Copy that address.
Now go to the cloned project and search for "SETUP_ADDRESS" and change the address at every found occurence to the address of your SecretNote contract. 
You can now launch the frontend with:

```
sudo npm run build
sudo npm install -g serve
sudo serve -s build
```

The frontend will be available at localhost:5000. Try to hit the "Connect with MetaMask" button. If that does not work, click the icon of the MetaMask browser extension (top right corner), select your desired account, click the three little dots on the top right, select connected sites and connect to site manually. Enter localhost:5000 and hit connect. You should now be able to see the frontend, separated in "Your Cash" and "Cash Pool".




From this point on, we unfortunately got stuck because the entire user interaction frontend built by the Singapore developer is no longer functional. Another problem is that the SecretNote.sol contract has to be updated because the structure of the function "verifyTx()" in the parent contract "verifier.sol" has changed. At the moment, you can get a hashed note on the chain, but not the proof of it yet.

## Next steps

To execute a zkDAI transaction, it is necessary to find a way to get a hashed transaction ( Sha256(sender address, value) ) together with the associated proof onto the Ropsten blockchain via the SecretNote.sol contract. For this, SecretNote.sol needs to be adapted to the verifier.sol exported by ZoKrates and, if necessary, a frontend for user interaction needs to be created.    
