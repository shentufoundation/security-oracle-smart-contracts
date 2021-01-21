// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface SecurityOracle {
  function getSecurityScore(address contractAddress)
    external
    view
    returns (uint8);

  function getSecurityScore(
    address contractAddress,
    string calldata functionSignature
  ) external view returns (uint8);

  function getSecurityScoreBytes4(
    address contractAddress,
    bytes4 functionSignature
  ) external view returns (uint8);

  function getSecurityScores(
    address[] calldata addresses,
    bytes4[] calldata functionSignatures
  ) external view returns (uint8[] memory);
}

contract DeFiExample {
  event Score(uint8 score);
  event SuccessBytes4(address addr, bytes4 sig);
  event SuccessString(address addr, string sig);

  address private _securityOracleAddress;

  constructor(address securityOracleAddress) public {
    _securityOracleAddress = securityOracleAddress;
  }

  function callGetSecurityScore(address addr, string memory sig) public {
    uint8 score = SecurityOracle(_securityOracleAddress).getSecurityScore(
      addr,
      sig
    );

    emit Score(score);

    require(score > 100, "revert due to high security risk");

    emit SuccessString(addr, sig);
  }

  function callGetSecurityScoreBytes4(address addr, bytes4 sig) public {
    uint8 score = SecurityOracle(_securityOracleAddress).getSecurityScoreBytes4(
      addr,
      sig
    );

    emit Score(score);

    require(score > 100, "revert due to high security risk");

    emit SuccessBytes4(addr, sig);
  }

  function callGetSecurityScores() public view {
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

    uint8[] memory scores = SecurityOracle(_securityOracleAddress)
      .getSecurityScores(addresses, functionSignatures);

    for (uint256 i = 0; i < scores.length; i++) {
      require(scores[i] > 100, "failed security check");
    }
  }
}
