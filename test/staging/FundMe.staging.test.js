const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai");
const { developmentChains } = require("../../helper-hardhat-config");


describe("FundMe", async function () {
    let fundMe;
    let deployer;
    const sendValue = "1000000000000000000"; //1 eth ethers.utils.parseEther("1") ethers.parseEther('0.03')
    beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        const contracts = await deployments.fixture(["all"]);
        const signer = await ethers.getSigner(deployer);
        const fundMeAddress = contracts["FundMe"].address;
        fundMe = await ethers.getContractAt("FundMe", fundMeAddress, signer);
    });
});