var Safemath = artifacts.require("./safemath.sol");
module.exports = function(deployer) {
  deployer.deploy(Safemath);
};