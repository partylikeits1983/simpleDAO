#### Simple DAO solidity smart contract

A smart contract that functions as a decentralized autonomous organization. This is in development (*i.e.* not extensively tested for deploying on the Ethereum mainnet). It has been tested using [Remix](https://remix.ethereum.org).

----
<p align="center">
   <img src="/doc/Animated GIF-source.gif">
</p>

#### Basic instructions to run:
1) Open [Remix](https://remix.ethereum.org) and deploy the vending machine solidity contract first and then the simpleDAO contract. 

2) Copy and paste the address of the vending machine into the simpleDAO constructor.

3) Specify how long members will be allowed to vote (seconds)

4) add in name of proposals: ["buy_cupcakes", "no_cupcakes"]

5) Only the chairperson can give the right to vote in the DAO to other addresses.

6) If the majority of the DAO members who voted selected "buy_cupcakes", then the DAO
will send 1 ether to the digital vending machine and in return the DAO will recieve one cupcake.

