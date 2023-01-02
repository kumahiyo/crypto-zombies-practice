var CryptoZombies = artifacts.require("./cryptozombies.sol");
module.exports = function(deployer) {
  deployer.deploy(CryptoZombies);
};