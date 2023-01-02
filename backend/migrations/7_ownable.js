var Ownable = artifacts.require("./ownable.sol");
module.exports = function(deployer) {
  deployer.deploy(Ownable);
};