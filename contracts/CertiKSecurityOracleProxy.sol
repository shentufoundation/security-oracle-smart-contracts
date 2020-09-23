// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.6.0;

import "./openzeppelin/Ownable.sol";
import "./openzeppelin/Proxy.sol";

contract CertiKSecurityOracleProxy is Proxy, Ownable {
  address public currentOracleAddress;

  constructor(address oracleAddress) public {
    currentOracleAddress = oracleAddress;

    // initialize state
    (bool success, ) = currentOracleAddress.delegatecall(
      abi.encodeWithSignature("initialize()")
    );
    require(success, "failed to initialize");
  }

  function _implementation() internal view returns (address) {
    return currentOracleAddress;
  }

  function upgradeOracleAddress(address oracleAddress) public onlyOwner {
    currentOracleAddress = oracleAddress;
  }

  function getProxyAddress() public view returns (address) {
    return address(this);
  }
}
