const { deployments, network, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai");
const { developmentChains } = require("../../helper-hardhat-config");

developmentChains.includes(network.name)
    ? describe.skip
    : describe("FundMe", async function () {
    let fundMe;
    let deployer;
    const sendValue = "0100000000000000000"; //1 eth ethers.utils.parseEther("1") ethers.parseEther('0.03')
    beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        const contracts = await deployments.fixture(["all"]);
        const signer = await ethers.getSigner(deployer);
        const fundMeAddress = contracts["FundMe"].address;
        fundMe = await ethers.getContractAt("FundMe", fundMeAddress, signer);
    });
    it("allows people to fund and withdraw", async function () {
        const fundTxResponse = await fundMe.fund({ value: sendValue });
        await fundTxResponse.wait(1);
        const withdrawTxResponse = await fundMe.withdraw();
        await withdrawTxResponse.wait(1);

        const endingFundMeBalance = await ethers.provider.getBalance(fundMe.getAddress());

        console.log(
            endingFundMeBalance.toString() +
                " should equal 0, running assert equal..."
        )
        assert.equal(endingFundMeBalance.toString(), "0")
    })
});