pragma solidity ^0.4.24;

//TODO update diagrams later
contract SupplyChain {

  address owner;

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
    string originFarmName;
    string originFarmInformation;
    string originFarmLatitude;
    string originFarmLongitude;
    uint productID;  // Procudt ID potentially a combination of upc + sku
    string productNotes;
    string productPrice;
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
    require(msg.sender == owner);
    _;
  }

  modifier verifyCaller(address _address) {
    require(msg.sender == _address);
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
    owner = msg.sender;
    sku = 1;
    upc = 1;
  }

  function kill() public
  onlyOwner()
  {
    //TODO research this method later
    selfdestruct(owner)
  }

  function harvestItem(uint _upc, address _originFarmerID, string _originFarmName, string _originFarmInformation, string _originFarmLatitude, string _originFarmLongitude, string _productNotes, address _inspectorID) public
  {
    Item item = Item
    (
      {
        sku: sku,
        upc: _upc,
        ownerID: owner,
        originFarmerID: _originFarmerID,
        originFarmName: _originFarmName,
        originFarmLatitude: _originFarmLatitude,
        originFarmLongitude: _originFarmLongitude,
        productID: _upc + sku,
        productNotes: _productNotes,
        itemState: State.Harvested
        inspectorID: _inspectorID
      }
    );

    items[_upc] = item;
    sku = sku + 1;
    emit Harvested(_upc);
  }

  function processItem(uint _upc) public
  harvested(_upc)
  verifyCaller(items[_upc].originFarmerID)
  {
    items[_upc].itemState = State.Processed;
    emit ProcessedItem(_upc);
  }

  function inspectItem(uint _upc) public
  processed(_upc)
  verifyCaller(items[_upc].inspectorID) public
  {
    items[_upc].inspectorID = _inspectorID;
    items[_upc].itemState = State.Inspected;
    emit Inspected(_upc);
  }

	function packItem(uint _upc) public
	inspected(_upc)
	verifyCaller(items[_upc].originFarmerID) public
	{
		items[_upc].itemState = State.Packed;
		emit Packed(_upc);
	}

	function sellItem(uint _upc, uint _price) public
	packed(_upc)
	verifyCaller(items[_upc].originFarmerID)
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
		items[_upc].owner = msg.sender;
		items[_upc].distributorID = msg.sender;
    items[_upc].itemState = State.Sold;
		emit Sold(_upc);
	}

  function shipItem(uint _upc) public
  sold(_upc)
  verifyCaller(items[_upc].distributorID)
  {
    items[_upc].itemState = State.Shipped;
    emit Shipped(_upc);
  }


	function receiveItem(uint _upc) public
	shipped(_upc)
	{
		items[_upc].owner = msg.sender;
		items[_upc].retailerID = msg.sender;
		items[_upc].itemState = State.Received;
		emit Received(_upc);
	}

	function purchaseItem(uint _upc) public
	received(_upc)
	{
		items[_upc].owner = msg.sender;
		items[_upc].consumerID = msg.sender;
		items[_upc].itemState = State.Purchased;
		emit Purchased(_upc);
	}

}
