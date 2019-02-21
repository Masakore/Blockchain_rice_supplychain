pragma solidity ^0.4.0;

import "./Roles.sol";

contract Inspector {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event InspectorAdded(address indexed account);
  event InspectorRemoved(address indexed account);

  // Define a struct 'Inspectors' by inheriting from 'Roles' library, struct Role
  Roles.Role private inspectors;

  // In the constructor make the address that deploys this contract the 1st Inspector
  constructor() public {
    _addInspector(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyInspector() {
    require(isInspector(msg.sender))
    _;
  }

  // Define a function 'isInspector' to check this role
  function isInspector(address account) public view returns (bool) {
    return inspector.has(account);
  }

  // Define a function 'addInspector' that adds this role
  function addInspector(address account) public onlyInspector {
    _addInspector(account);
  }

  // Define a function 'renounceInspector' to renounce this role
  function renounceInspector() public {
    _removeInspector(msg.sender);
  }

  // Define an internal function '_addInspector' to add this role, called by 'addInspector'
  function _addInspector(address account) internal {
    inspectors.add(account);
    emit InspectorAdded(account);
  }

  // Define an internal function '_removeInspector' to remove this role, called by 'removeInspector'
  function _removeInspector(address account) internal {
    inspectors.remove(account);
    emit InspectorRemoved(account);
  }
}
