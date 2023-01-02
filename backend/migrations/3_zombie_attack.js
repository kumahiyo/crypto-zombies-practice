var ZombieAttack = artifacts.require("./zombieattack.sol");
module.exports = function(deployer) {
  deployer.deploy(ZombieAttack);
};