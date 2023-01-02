var ZombieHelper = artifacts.require("./zombiehelper.sol");
module.exports = function(deployer) {
  deployer.deploy(ZombieHelper);
};