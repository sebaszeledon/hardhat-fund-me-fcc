const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai"); //11:23:0000000


describe("FundMe", async function () {
    let fundMe;
    let deployer;
    let mockV3Aggregator;
    const sendValue = "1000000000000000000"; //1 eth ethers.utils.parseEther("1") ethers.parseEther('0.03')
    beforeEach(async function () {
        //deploy our FundMe contract
        //using Hardhat-deploy
        //const accounts = await ethers.getSigners();
        //const accountZero = accounts[0];
        deployer = (await getNamedAccounts()).deployer;
        const contracts = await deployments.fixture(["all"]);
        const signer = await ethers.getSigner(deployer);
        const fundMeAddress = contracts["FundMe"].address;
        fundMe = await ethers.getContractAt("FundMe", fundMeAddress, signer);
        mockV3Aggregator = contracts["MockV3Aggregator"];
    });
    describe("constructor", async function () {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.priceFeed();
            assert.equal(response, mockV3Aggregator.address);
        });
    });

    describe("fund", async function() {
        it("Fails if you don't send enough ETH", async function () {
            await expect(fundMe.fund()).to.be.revertedWith("Didn't sent enough!");
        });
        it("Updated the amount funded data structure", async function (){
            await fundMe.fund({ value : sendValue });
            const response = await fundMe.addressToAmountFunded(deployer);
            assert.equal(response.toString(), sendValue.toString());
        });
        it("Add funder to array of funders", async function (){
            await fundMe.fund({ value : sendValue });
            const funder = await fundMe.funders(0);
            assert.equal(funder, deployer);//11:24:57
        });
    });


});