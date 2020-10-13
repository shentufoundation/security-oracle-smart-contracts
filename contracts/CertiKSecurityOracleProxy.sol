// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./openzeppelin/AccessControl.sol";
import "./openzeppelin/Proxy.sol";

contract CertiKSecurityOracleProxy is Proxy, AccessControl {
  address public currentOracleAddress;

  constructor(address oracleAddress) public {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    currentOracleAddress = oracleAddress;

    // initialize state
    (bool success, ) = currentOracleAddress.delegatecall(
      abi.encodeWithSignature("initialize()")
    );
    require(success, "failed to initialize");
  }

  modifier onlyAdmin() {
    require(isAdmin(msg.sender), "restricted to administrator");
    _;
  }

  function isAdmin(address account)
    public virtual view returns (bool)
  {
    return hasRole(DEFAULT_ADMIN_ROLE, account);
  }

  function _implementation() internal view override returns (address) {
    return currentOracleAddress;
  }

  function upgradeOracleAddress(address oracleAddress) public onlyAdmin {
    currentOracleAddress = oracleAddress;
  }

  function getProxyAddress() public view returns (address) {
    return address(this);
  }
}
