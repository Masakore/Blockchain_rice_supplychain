# Blockchain_rice_supplychain
For Udacity blockchain developer course supplychain project

This repository containts an Ethereum DApp that demonstrates a Supply Chain flow between a Seller and Buyer. The user story is similar to any commonly used supply chain process. A Seller can add items to the inventory system stored in the blockchain. A Buyer can purchase such items from the inventory system. Additionally a Seller can mark an item as Shipped, and similarly a Buyer can mark an item as Received.

The DApp User Interface when running should look like...

![Product overview](images/product_overview.jpg?raw=true)
![Farm details](images/farm_details.jpg?raw=true)
![Product details](images/product_details.jpg?raw=true)
![Transaction history](images/tx_history.jpg?raw=true)

## Design
### Activity diagram
![Activity diagram](design/udacity_rice_supplychain_activity_diagram.jpg?raw=true)

### Sequence diagram
![Sequence diagram](design/udacity_rice_supplychain_sequence_diagram.jpg?raw=true)

### State diagram
![State diagram](design/udacity_rice_supplychain_state_diagram.jpg?raw=true)

### Class diagram
![Class diagram](design/udacity_rice_supplychain_class_diagram.jpg?raw=true)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Please make sure you've already installed ganache-cli, Truffle and enabled MetaMask extension in your browser.

```
Give examples (to be clarified)
```

### Installing

A step by step series of examples that tell you have to get a development env running

Clone this repository:

```
git clone https://github.com/Masakore/Blockchain_rice_supplychain/tree/master
```

Change directory to ```Blockchain_rice_supplychain``` folder and install all requisite npm packages (as listed in ```package.json```):

```
cd Blockchain_rice_supplychain
npm install
```

Launch Ganache:

```
ganache-cli -m "spirit supply whale amount human item harsh scare congress discover talent hamster"
```

In a separate terminal window, Compile smart contracts:

```
truffle compile
```

This will create the smart contract artifacts in folder ```build\contracts```.

Migrate smart contracts to the locally running blockchain, ganache-cli:

```
truffle migrate
```

Test smart contracts:

```
truffle test
```

All tests should pass.

In a separate terminal window, launch the DApp:

```
npm run dev
```

## Built With

* [Ethereum](https://www.ethereum.org/) - Ethereum is a decentralized platform that runs smart contracts
* [IPFS](https://ipfs.io/) - IPFS is the Distributed Web | A peer-to-peer hypermedia protocol
to make the web faster, safer, and more open.
* [Truffle Framework](http://truffleframework.com/) - Truffle is the most popular development framework for Ethereum with a mission to make your life a whole lot easier.

## Acknowledgments

* Solidity
* Ganache-cli
* Truffle
* IPFS
