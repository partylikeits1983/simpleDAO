import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("VendingMachine Unit Tests", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deploy() {
    const [owner, otherAccount] = await ethers.getSigners();
    const VendingMachine = await ethers.getContractFactory("VendingMachine");
    const machine = await VendingMachine.deploy();

    return { machine, owner, otherAccount };
  }

  describe("Deployment", function () {

    it("Should get owner", async function () {
      const { machine } = await loadFixture(deploy);

      let owner = await machine.owner();

      expect(owner).to.equal(owner);
    });

    it("Should machine balance", async function () {
        const { machine } = await loadFixture(deploy);
  
        let balance = await machine.cupcakeBalances(machine.address);
  
        expect(balance).to.equal(100);
    });
  
    it("Should be able to refill", async function () {
        const { machine } = await loadFixture(deploy);

        let amount = 100;
  
        await machine.refill(amount);

        let balance = await machine.cupcakeBalances(machine.address);
  
        expect(balance).to.equal(200);
    });
  
    it("Should be able to purchase", async function () {
        const { machine, otherAccount } = await loadFixture(deploy);

        let amount = 1;

        let options = {value: ethers.utils.parseEther("1.0")}
  
        await machine.connect(otherAccount).purchase(amount, options);

        let balance = await machine.cupcakeBalances(otherAccount.address);
  
        expect(balance).to.equal(1);
    });
  });
});
