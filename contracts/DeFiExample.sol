// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./CertiKSecurityOracle.sol";

contract DeFiExample {
  event Score(uint8 score);
  event Success(address addr, bytes4 sig);

  address private _securityOracleAddress;

  constructor(address securityOracleAddress) public {
    _securityOracleAddress = securityOracleAddress;
  }

  function callGetSecurityScore(address addr, bytes4 sig) public {
    uint8 score = CertiKSecurityOracle(_securityOracleAddress).getSecurityScore(addr, sig);

    emit Score(score);

    require(score > 100, "revert due to high security risk");

    emit Success(addr, sig);
  }

  function callGetSecurityScores() public {
    address[] memory addresses = new address[](2);
    bytes4[] memory functionSignatures = new bytes4[](2);

    addresses[0] = msg.sender;
    functionSignatures[0] = bytes4(
      keccak256(abi.encodePacked("getPrice(string)"))
    );

    addresses[1] = msg.sender;
    functionSignatures[1] = bytes4(
      keccak256(abi.encodePacked("getPrice2(string)"))
    );

    uint8[] memory scores = CertiKSecurityOracle(_securityOracleAddress)
      .getSecurityScores(addresses, functionSignatures);

    for (uint256 i = 0; i < scores.length; i++) {
      require(scores[i] > 100, "failed security check");
    }
  }
}
