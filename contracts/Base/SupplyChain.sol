pragma solidity ^0.4.24;

import "../AccessControl/Farmer.sol";
import "../AccessControl/Inspector.sol";
import "../AccessControl/Distributor.sol";
import "../AccessControl/Retailer.sol";
import "../AccessControl/Consumer.sol";
import "../Core/Ownable.sol";

//TODO update diagrams later
contract SupplyChain is Farmer, Inspector, Distributor, Retailer, Consumer, Ownable {

  // Universal Product Code (UPC)
  uint upc;

  // Stock Keeping Unit(SKU)
  uint sku;

  // Map the UPC to an Item
  mapping (uint => Item) items;

  // Map the UPC to an array of TxHash
  mapping (uint => string[]) itemsHistory;

  enum State
  {
    Harvested, // 0
    Processed, // 1
    Inspected, // 2
    Packed,    // 3
    ForSale,   // 4
    Sold,      // 5
    Shipped,   // 6
    Received,  // 7
    Purchased  // 8
  }

  State constant defaultState = State.Harvested;

  struct Item {
    uint sku;
    uint upc;
    address ownerID;
    address originFarmerID;
    string originFarmerName;
    string originFarmInformation;
    string originFarmLatitude;
    string originFarmLongitude;
    uint productID;  // Procudt ID potentially a combination of upc + sku
    string productNotes;
    uint productPrice;
    State itemState;
    address inspectorID;
    address distributorID;
    address retailerID;
    address consumerID;
  }

  event Harvested(uint upc);
  event Processed(uint upc);
  event Inspected(uint upc);
  event Packed(uint upc);
  event ForSale(uint upc);
  event Sold(uint upc);
  event Shipped(uint upc);
  event Received(uint upc);
  event Purchased(uint upc);

	modifier onlyOwner() {
		isOwner();
	  _;
	}

	modifier onlyFarmer() {
		isFarmer(msg.sender);
		_;
	}

	modifier onlyInspector() {
		isInspector(msg.sender);
		_;
	}

	modifier onlyDistributor() {
		isDistributor(msg.sender);
		_;
	}

  modifier paidEnough(uint _price) {
    require(msg.value >= _price);
    _;
  }

  modifier checkValue(uint _upc) {
    _;
    uint _price = items[_upc].productPrice;
    uint amountToReturn = msg.value - _price;
    items[_upc].consumerID.transfer(amountToReturn);
  }

  modifier harvested(uint _upc) {
    require(items[_upc].itemState == State.Harvested);
    _;
  }

  modifier processed(uint _upc) {
    require(items[_upc].itemState == State.Processed);
    _;
  }

  modifier inspected(uint _upc) {
    require(items[_upc].itemState == State.Inspected);
    _;
  }

  modifier packed(uint _upc) {
    require(items[_upc].itemState == State.Packed);
    _;
  }

  modifier forSale(uint _upc) {
    require(items[_upc].itemState == State.ForSale);
    _;
  }

  modifier sold(uint _upc) {
    require(items[_upc].itemState == State.Sold);
    _;
  }

  modifier shipped(uint _upc) {
    require(items[_upc].itemState == State.Shipped);
    _;
  }

  modifier received(uint _upc) {
    require(items[_upc].itemState == State.Received);
    _;
  }

  constructor() public payable {
    sku = 1;
    upc = 1;
  }

	function getOwner() public view returns (address)
	{
		return owner();
	}

  function kill() public
  onlyOwner
  {
    selfdestruct(msg.sender);
  }

  function harvestItem(uint _upc, address _originFarmerID, string _originFarmerName, string _originFarmInformation, string _originFarmLatitude, string _originFarmLongitude, string _productNotes) public
  {
    Item memory item = Item
    (
      {
        sku: sku,
        upc: _upc,
        ownerID: _originFarmerID,
        originFarmerID: _originFarmerID,
        originFarmerName: _originFarmerName,
        originFarmInformation: _originFarmInformation,
        originFarmLatitude: _originFarmLatitude,
        originFarmLongitude: _originFarmLongitude,
        productID: _upc + sku,
        productNotes: _productNotes,
        productPrice: 0,
        itemState: defaultState,
        distributorID: 0,
        inspectorID: 0,
        retailerID: 0,
        consumerID: 0
      }
    );

    transferOwnership(_originFarmerID);
    items[_upc] = item;
    sku = sku + 1;
    emit Harvested(_upc);
  }

  function processItem(uint _upc) public
  harvested(_upc)
  onlyFarmer
  {
    items[_upc].itemState = State.Processed;
    emit Processed(_upc);
  }

  function inspectItem(uint _upc) public
  processed(_upc)
  onlyInspector
  {
    items[_upc].inspectorID = msg.sender;
    items[_upc].itemState = State.Inspected;
    emit Inspected(_upc);
  }

	function packItem(uint _upc) public
	inspected(_upc)
	onlyFarmer
	{
		items[_upc].itemState = State.Packed;
		emit Packed(_upc);
	}

	function sellItem(uint _upc, uint _price) public
	packed(_upc)
	onlyFarmer
	{
    items[_upc].productPrice = _price;
		items[_upc].itemState = State.ForSale;
		emit ForSale(_upc);
	}

	function buyItem(uint _upc) public
	forSale(_upc)
  paidEnough(items[_upc].productPrice)
  checkValue(_upc)
	{
		transferOwnership(msg.sender);
		items[_upc].ownerID = getOwner();
		items[_upc].distributorID = msg.sender;
    items[_upc].itemState = State.Sold;
		emit Sold(_upc);
	}

  function shipItem(uint _upc) public
  sold(_upc)
  onlyDistributor
  {
    items[_upc].itemState = State.Shipped;
    emit Shipped(_upc);
  }

	function receiveItem(uint _upc) public
	shipped(_upc)
	{
		items[_upc].retailerID = msg.sender;
		items[_upc].itemState = State.Received;
		emit Received(_upc);
	}

	function purchaseItem(uint _upc) public
	received(_upc)
	{
		transferOwnership(msg.sender);
		items[_upc].ownerID = getOwner();
		items[_upc].consumerID = msg.sender;
		items[_upc].itemState = State.Purchased;
		emit Purchased(_upc);
	}

	function fetchItemBufferOne(uint _upc) public view returns
	(
		uint itemSKU,
		uint itemUPC,
		address ownerID,
		address originFarmerID,
		string originFarmerName,
		string originFarmInformation,
		string originFarmLatitude,
		string originFarmLongitude
	)
	{
		itemSKU = items[_upc].sku;
		itemUPC = items[_upc].upc;
		ownerID = items[_upc].ownerID;
		originFarmerID = items[_upc].originFarmerID;
		originFarmerName = items[_upc].originFarmerName;
		originFarmInformation = items[_upc].originFarmInformation;
		originFarmLatitude = items[_upc].originFarmLatitude;
		originFarmLongitude = items[_upc].originFarmLongitude;

		return
		(
			itemSKU,
			itemUPC,
			ownerID,
			originFarmerID,
			originFarmerName,
			originFarmInformation,
			originFarmLatitude,
			originFarmLongitude
		);
	}

	function fetchItemBufferTwo(uint _upc) public view returns
	(
		uint itemSKU,
		uint itemUPC,
		uint productID,
		string productNotes,
		uint productPrice,
		State itemState,
		address distributorID,
		address inspectorID,
		address retailerID,
		address consumerID
	)
	{
		itemSKU = items[_upc].sku;
		itemUPC = items[_upc].upc;
		productID = items[_upc].productID;
		productNotes = items[_upc].productNotes;
		productPrice = items[_upc].productPrice;
		itemState = items[_upc].itemState;
		distributorID = items[_upc].distributorID;
		inspectorID = items[_upc].inspectorID;
		retailerID = items[_upc].retailerID;
		consumerID = items[_upc].consumerID;

		return
		(
			itemSKU,
			itemUPC,
			productID,
			productNotes,
			productPrice,
			itemState,
			distributorID,
			inspectorID,
			retailerID,
			consumerID
		);
	}
}
