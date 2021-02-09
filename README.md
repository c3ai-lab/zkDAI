# zkDAI

zkDAI is the prototype stablecoin cryptocurrency that uses so-called "zero knowledge proofs" to ensure completely anonymous transactions over the blockchain. When using standard cryptocurrencies, such as Bitcoin, everyone can easily determine from which address how many BTC were sent to which receiving address via the [Bitcoin Blockexplorer](https://www.blockchain.com/de/explorer). To encrypt these publicly visible parameters, zkDAI uses zkSNARKS (Zero-Knowledge Succinct Non-Interactive Argument of Knowledge) proofs. They are sent along with the transaction, being encrypted with a Sha256 hash function, to prove, via a special smart contract, that the contents of the transaction actually match the expected parameters. To create these proofs as well as the smart contracts we used [ZoKrates](https://zokrates.github.io), a tool specifically designed for Zero Knowledge interactions on the Ethereum blockchain. More about this in our scientific paper about the project. Since our project is not to be tested with any real money, we run all transactions through the Ropsten testnet, for which you can easily get test ETH as well as DAI via a so-called [faucets](https://faucet.ropsten.be/). For the implementation of the project, we mostly used a [hackathon project](https://github.com/atvanguard/ethsingapore-zk-dai) of a Singaporean developer, respectively improved it, since it was no longer executable.
 

## Prerequisities

- Install [Docker](https://docs.docker.com/get-docker/) on your system 
- Clone this repository
- Have node.js installed
- Create a [MetaMask](https://metamask.io/) account

## Setup on MacOS

The first step is to compile the code inside zk-circuit.zok, which holds the logic for a zero knowledge proof on a blockchain transaction. To do this, simple run

```
docker run -ti zokrates/zokrates /bin/bash
```

which should start a shell inside the ZoKrates Docker container. Now you have to copy the zk-circuit.zok file into the container.

```
docker cp path/of/your/local/zk-circuit.zok zokrates:/home/zokrates/
```

Then, inside the ZoKrates container, run:

```
zokrates compile -i zk-circuit.zok
``` 
and afterwards:

```
zokrates setup
```

This will generate the proofing and the verification key, which will be used later.
To create the smart contract that will later approve Zero Knowledge transactions on the blockchain run the following command.

```
zokrates export-verifier
```

You should now see a newly generated file called verifier.sol. That is the contract which we now want to deploy on the Ropsten testnet. In order to do this, however, we first need to copy it back out of the Docker container.

```
docker cp zokrates:/home/zokrates/verifier.sol your/desired/destination/verifier.sol
```

To deploy the verifier.sol as well as SecretNote.sol and ERC20Interface.sol, go to https://remix.ethereum.org/ and upload the files there. Select the 0.6.1 compiler to compile the three contracts. Now head to the "Deploy & run transactions" tab and deploy verifier.sol and SecretNote.sol to Ropsten. You will need a MetaMask account with some test ETH to "pay" for the deployment.

To now generate the proof of a transaction with ZoKrates, open zokcmd.js and replace the addresses and values on the very bottom of the file (line 55-60) with your desired values and addresses. Then execute zokcmd.js, using:

```
node zokcmd.js
```

The yielded output are the parameters, that can now be used to generate a proof with ZoKrates. So go back to your terminal window where the shell from the ZoKrates Docker container is running, paste the parameters you just generated there and execute the command. After the process has finished, execute:

```
zokrates generate-proof
```

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

The frontend will be available at localhost:5000. Try to hit the "Connect with MetaMask" button. If that does not work, click the icon of the MetaMask browser extension (top right corner), select your desired account, click the three little dots on the top right, select connected sites and connect to site manually. Enter localhost:5000 and hit connect. You should now be able to see the frontend, separated in "Your Cash" and "Cash Pool". Your cash shows any transactions, that are validated and ready to be claimed. Cash pool shows every transaction on the SecretNote (of course only hashed values, that nobody can make sense of).

The workflow to now send some zkDAI to another address is the following:

1. Click the "Pay with Tokens" button on the top of the page, this should open a kyber widget were you can swap ETH into DAI which will be send to the SecretNote contract. By the time of writing, the amount which will be send is hardcoded to 5 (e.g. in zokcmd.js). This has to be refined to be dynamic in the future. But for now, just buy DAI for about 0.003 ETH (~5,13 DAI). After confirming, you should now see the 5 Token inside the "Your Cash" area.

2. Head back to your terminal session running in the directory of your project and execute
```
cd ethereum
truffle exec scripts/transferNote.js
```
Unfortunately, this is still very buggy and is not working reliably. This is the main thing, that has to be fixed in the future.

3. When now checking the Ropsten block explorer, you will find that all the transactions details have been hidden by the zero knowledge method. As the sender you will now see the "change" of the transaction being ready to be claimed by you in the "Your Cash" overview. Below, in the "Cash Pool" area, some more hashed strings appeared. They represent the transaction you just made.

4. The receiver should now also have the possibility to claim the value that has been send to him. For testing purposes, we recommend to use two MetaMask accounts to simply switch between them and receive the transfer from your 1. account with your 2. account.

And that is it! You just sent your very first zero knowledge crypto transaction! :)

## Setup with Ubuntu VirtualBox

WIP

## Next steps

As already described, the transfer process is unfortunately still very error-prone and not yet truly dynamic. So the next steps should be to improve the scripts and to automate the general flow of the setup more and more. Tools like [truffle](https://www.trufflesuite.com/docs/truffle/reference/configuration) can be very helpful in deploying the contracts, for example.   
