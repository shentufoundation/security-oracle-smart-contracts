// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./openzeppelin/Ownable.sol";

contract CertiKSecurityOracle is Ownable {
  event Init(uint8 defaultScore);
  event ResultUpdate(
    address indexed target,
    bytes4 functionSignature,
    uint8 score,
    uint248 expiration
  );
  event BatchResultUpdate(uint256 length);
  event DefaultScoreChanged(uint8 score);

  struct Result {
    uint8 score;
    uint248 expiration;
  }

  // stores pushed results
  mapping(address => mapping(bytes4 => Result)) private _results;
  // score to return when we don't have results available
  uint8 public defaultScore;

  constructor() public {
    initialize();
  }

  function getSecurityScore(
      address contractAddress,
      bytes4 functionSignature
    ) public view returns (uint8) {
    require(contractAddress != address(0), "address should not be 0x0");
    Result memory result = _results[contractAddress][functionSignature];

    if (result.expiration > block.timestamp) {
      return result.score;
    } else {
      return defaultScore;
    }
  }

  function getSecurityScore(
    address contractAddress,
    string memory functionSignature
  ) public view returns (uint8) {
    return
      getSecurityScore(
        contractAddress,
        bytes4(keccak256(abi.encodePacked(functionSignature)))
      );
  }

  function getSecurityScore(address contractAddress) public view returns (uint8) {
    return getSecurityScore(contractAddress, 0);
  }

  function getSecurityScores(
    address[] memory addresses,
    bytes4[] memory functionSignatures
  ) public view returns (uint8[] memory) {
    require(
      functionSignatures.length == addresses.length,
      "the length of addresses and functionSignatures must be the same"
    );

    uint256 len = addresses.length;

    uint8[] memory scores = new uint8[](len);

    for (uint256 i = 0; i < len; i++) {
      scores[i] = getSecurityScore(addresses[i], functionSignatures[i]);
    }

    return scores;
  }

  function pushResult(
    address contractAddress,
    bytes4 functionSignature,
    uint8 score,
    uint248 expiration
  ) public onlyOwner {
    require(contractAddress != address(0), "contract address should not be 0x0");
    _results[contractAddress][functionSignature] = Result(score, expiration);

    emit ResultUpdate(contractAddress, functionSignature, score, expiration);
  }

  function batchPushResult(
    address[] memory contractAddresses,
    bytes4[] memory functionSignatures,
    uint8[] memory scores,
    uint248[] memory expirations
  ) public onlyOwner {
    require(
      contractAddresses.length == functionSignatures.length &&
        functionSignatures.length == scores.length &&
        scores.length == expirations.length,
      "request parameters length should be exactly the same"
    );

    uint256 len = contractAddresses.length;

    for (uint256 i = 0; i < len; i++) {
      pushResult(
        contractAddresses[i],
        functionSignatures[i],
        scores[i],
        expirations[i]
      );
    }

    emit BatchResultUpdate(len);
  }

  function initialize() public onlyOwner {
    defaultScore = 128;

    emit Init(defaultScore);
  }

  function updateDefaultScore(uint8 score) public onlyOwner {
    defaultScore = score;

    emit DefaultScoreChanged(score);
  }
}
