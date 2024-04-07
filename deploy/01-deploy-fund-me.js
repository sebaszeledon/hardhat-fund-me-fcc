// function deployFunc() {
//     console.log("Hi!");
// }
// module.exports.default = deployFunc;

const { network } = require("hardhat");

// module.exports = async (hre) => {
//     const { getNamedAccounts, deployments } = hre;
// }

module.exports = async ( { getNamedAccounts, deployments } ) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;
}