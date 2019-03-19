// migrating the appropriate contracts
var FarmerRole = artifacts.require("../contracts/AccessControl/Farmer.sol");
var InspectorRole = artifacts.require("../contracts/AccessControl/Inspector.sol");
var DistributorRole = artifacts.require("../contracts/AccessControl/Distributor.sol");
var RetailerRole = artifacts.require("../contracts/AccessControl/Retailer.sol");
var ConsumerRole = artifacts.require("../contracts/AccessControl/Consumer.sol");
/* Embedded Library: If a smart contract is consuming a library which have only internal functions than EVM simply embeds library into the contract. 
Instead of using delegate call to call a function, it simply uses JUMP statement(normal method call). 
There is no need to separately deploy library in this scenario.
 */
// this is library: var Ownable = artifacts.require("../contracts/Core/Ownable.sol");

var SupplyChain = artifacts.require("../contracts/Base/SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(FarmerRole);
  deployer.deploy(InspectorRole);
  deployer.deploy(DistributorRole);
  deployer.deploy(RetailerRole);
  deployer.deploy(ConsumerRole);
  // deployer.deploy(Ownable);
  deployer.deploy(SupplyChain);
};