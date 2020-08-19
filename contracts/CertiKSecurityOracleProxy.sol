// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./openzeppelin/Ownable.sol";
import "./openzeppelin/Proxy.sol";

contract CertiKSecurityOracleProxy is Proxy, Ownable {
  address public _currentOracleAddress;

  constructor(address oracleAddress) public {
    _currentOracleAddress = oracleAddress;

    // initialize state
    (bool success, ) = _currentOracleAddress.delegatecall(
      abi.encodeWithSignature("initialize()")
    );
    require(success, "failed to initialize");
  }

  function _implementation() internal view returns (address) {
    return _currentOracleAddress;
  }

  function upgradeOracleAddress(address oracleAddress) public onlyOwner {
    _currentOracleAddress = oracleAddress;
  }

  function getProxyAddress() public view returns (address) {
    return address(this);
  }
}
