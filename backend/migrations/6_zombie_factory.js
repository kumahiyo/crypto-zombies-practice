var ZombieFactory = artifacts.require("./zombiefactory.sol");
module.exports = function(deployer) {
  deployer.deploy(ZombieFactory);
};