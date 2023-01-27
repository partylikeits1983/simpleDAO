import { time, loadFixture,  } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network, } from "hardhat";

describe("VendingMachine Unit Tests", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deploy() {
    const [deployer, account1, account2, account3] = await ethers.getSigners();

    const VendingMachine = await ethers.getContractFactory("VendingMachine");
    const machine = await VendingMachine.deploy();

    const proposals = ['buy_cupcake', 'no_cupcakes']

    const SimpleDAO = await ethers.getContractFactory("simpleDAO");
    const dao = await SimpleDAO.deploy(machine.address, 86400, proposals);

    for (let i = 1; i<4; i++) {
        let voters = await ethers.getSigners();
        await dao.giveRightToVote(voters[i].address);
    }

    return { dao, machine, deployer, account1, account2, account3 };
  }

  describe("Deployment", function () {

    it("Should check machine address", async function () {
      const { dao, machine } = await loadFixture(deploy);

      let machineAddr = await dao.VendingMachineAddress();

      expect(machineAddr).to.equal(machine.address);
    });


    it("Should revert on double vote", async function () {
        const { dao, account1, account2, account3 } = await loadFixture(deploy);

        const yes = 0;

        await dao.connect(account1).vote(yes);
        await expect(dao.connect(account1).vote(yes)).to.be.reverted;
    });


    it("Should vote", async function () {
        const { dao, account1, account2, account3 } = await loadFixture(deploy);

        const yes = 0;
        const no = 1;

        let amountPayable = {value: ethers.utils.parseEther("0.5")};

        await dao.connect(account1).DepositEth(amountPayable);
        await dao.connect(account2).DepositEth(amountPayable);

        await dao.connect(account1).vote(yes);
        await dao.connect(account2).vote(yes);
        await dao.connect(account3).vote(no);

  
        // change time
        await ethers.provider.send("evm_increaseTime", [(24 * 60 * 60) + 60]);
        await network.provider.send("evm_mine");


        await dao.countVote();
        let decision = await dao.decision();

        expect(decision).to.equal(0);

        await dao.EndVote();

        let cupcakeBalance = await dao.checkCupCakeBalance();

        expect(cupcakeBalance).to.equal(1);

        console.log("cupcake balance: ", cupcakeBalance);
    });
  });
});
