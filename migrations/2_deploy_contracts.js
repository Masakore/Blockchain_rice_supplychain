// migrating the appropriate contracts
var FarmerRole = artifacts.require("../contracts/AccessControl/Farmer.sol");
var InspectorRole = artifacts.require("../contracts/AccessControl/Inspector.sol");
var DistributorRole = artifacts.require("../contracts/AccessControl/Distributor.sol");
var RetailerRole = artifacts.require("../contracts/AccessControl/Retailer.sol");
var ConsumerRole = artifacts.require("../contracts/AccessControl/Consumer.sol");
// TODO After commeting out Ownable contract, successfully start test. But don't know why
// var Ownable = artifacts.require("../contracts/Core/Ownable.sol");
var SupplyChain = artifacts.require("../contracts/Core/SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(FarmerRole);
  deployer.deploy(InspectorRole);
  deployer.deploy(DistributorRole);
  deployer.deploy(RetailerRole);
  deployer.deploy(ConsumerRole);
  // deployer.deploy(Ownable);
  deployer.deploy(SupplyChain);
};