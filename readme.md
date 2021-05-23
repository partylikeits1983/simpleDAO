#### Simple DAO solidity smart contract

A smart contract that functions as a decentralized autonomous organization. This is in development (*i.e.* not extensively tested for deploying on the Ethereum mainnet). It has been tested using [Remix](https://remix.ethereum.org).

----
## Basic schema of what the DAO does.

<p align="center">
   <img src="/doc/schema.png">
</p>

#### Basic instructions to run:
1) Open [Remix](https://remix.ethereum.org) and deploy the vending machine solidity contract first and then the simpleDAO contract. You can import this repo into the Remix IDE directly or simply copy and paste the code.

2) Since solidity is a statically typed programming language you must compile it before deploying the smart contract. 

<p align="center">
   <img src="/doc/sc1.png">
</p>

3) Copy and paste the address of the vending machine into the simpleDAO constructor.

4) Specify how long members will be allowed to vote (seconds)

5) add in name of proposals: ["buy_cupcakes", "no_cupcakes"]


<p align="center">
   <img src="/doc/sc2.png">
</p>

6) Only the chairperson can give the right to vote in the DAO to other addresses.

7) If the majority of the DAO members who voted selected "buy_cupcakes", then the DAO
will send 1 ether to the digital vending machine and in return the DAO will recieve one cupcake.


----


This code is essentially a conglomeration of functions of a few solidity code examples from the documentation that I liked. If you like this tutorial code you can send me some ETH at: 

