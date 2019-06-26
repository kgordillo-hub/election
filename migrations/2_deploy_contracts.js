var Obras = artifacts.require("./AuditoriaObras.sol");

module.exports = function(deployer) {
  deployer.deploy(Obras);
};