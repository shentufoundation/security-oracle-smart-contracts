// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "truffle/Assert.sol";
import "../contracts/CertiKSecurityOracle.sol";

contract TestSecurityOracle {
  CertiKSecurityOracle so;
  uint256 constant DEFAULT_SCORE = 128;

  function beforeEach() public {
    so = new CertiKSecurityOracle();
  }

  function testDefaultScore() public {
    uint256 score = uint256(so.defaultScore());

    Assert.equal(score, DEFAULT_SCORE, "initial default score wasn't expected");
  }

  function testUpdateDefaultScore() public {
    so.updateDefaultScore(0);

    uint256 score = uint256(so.defaultScore());

    Assert.equal(score, 0, "updated default score wasn't expected");
  }

  function testGetSecurityScoreResultMissing() public {
    uint256 score = uint256(
      so.getSecurityScoreBytes4(
        msg.sender,
        bytes4(keccak256(abi.encodePacked("getPrice(string)")))
      )
    );

    Assert.equal(
      score,
      DEFAULT_SCORE,
      "get security score for result missing case wasn't expected"
    );
  }

  function testGetSecurityScoreStringParameter() public {
    uint256 score = uint256(
      so.getSecurityScore(msg.sender, "getPrice(string)")
    );

    Assert.equal(
      score,
      DEFAULT_SCORE,
      "get security score for string parameter case wasn't expected"
    );
  }

  function testGetSecurityScoreContractAddressOnly() public {
    uint256 score = uint256(so.getSecurityScore(msg.sender));

    Assert.equal(
      score,
      DEFAULT_SCORE,
      "get security score for contract address only case wasn't expected"
    );
  }

  function testPushResultResultAvailable() public {
    uint256 newScore = 100;

    so.pushResult(
      msg.sender,
      bytes4(keccak256(abi.encodePacked("getPrice(string)"))),
      uint8(newScore),
      uint248(block.timestamp) + 3600
    );

    uint256 score = uint256(
      so.getSecurityScoreBytes4(
        msg.sender,
        bytes4(keccak256(abi.encodePacked("getPrice(string)")))
      )
    );

    Assert.equal(
      score,
      newScore,
      "get security score for result available case wasn't expected"
    );
  }

  function testPushResultResultExpired() public {
    uint256 newScore = 100;

    so.pushResult(
      msg.sender,
      bytes4(keccak256(abi.encodePacked("getPrice(string)"))),
      uint8(newScore),
      uint248(block.timestamp) - 1
    );

    uint256 score = uint256(
      so.getSecurityScoreBytes4(
        msg.sender,
        bytes4(keccak256(abi.encodePacked("getPrice(string)")))
      )
    );

    Assert.equal(
      score,
      DEFAULT_SCORE,
      "get security score for result expired case wasn't expected"
    );
  }

  function testBatchPushResult() public {
    uint256 newScore = 100;

    address[] memory contractAddresses = new address[](2);
    bytes4[] memory functionSignatures = new bytes4[](2);
    uint8[] memory scores = new uint8[](2);
    uint248[] memory expirations = new uint248[](2);

    contractAddresses[0] = msg.sender;
    functionSignatures[0] = (bytes4(keccak256(abi.encodePacked("func1()"))));
    scores[0] = (uint8(newScore));
    expirations[0] = (uint248(block.timestamp) + 3600);

    contractAddresses[1] = msg.sender;
    functionSignatures[1] = (bytes4(keccak256(abi.encodePacked("func2()"))));
    scores[1] = (uint8(newScore));
    expirations[1] = (uint248(block.timestamp) + 3600);

    so.batchPushResult(
      contractAddresses,
      functionSignatures,
      scores,
      expirations
    );

    uint256 func1Score = uint256(
      so.getSecurityScoreBytes4(
        msg.sender,
        bytes4(keccak256(abi.encodePacked("func1()")))
      )
    );

    Assert.equal(
      func1Score,
      newScore,
      "batch push result does not work as expected"
    );

    uint256 func2Score = uint256(
      so.getSecurityScoreBytes4(
        msg.sender,
        bytes4(keccak256(abi.encodePacked("func2()")))
      )
    );

    Assert.equal(
      func2Score,
      newScore,
      "batch push result does not work as expected"
    );
  }

  function testGetSecurityScores() public {
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

    uint8[] memory scores = so.getSecurityScores(addresses, functionSignatures);

    for (uint256 i = 0; i < scores.length; i++) {
      Assert.equal(
        scores[i],
        DEFAULT_SCORE,
        "get security scores wasn't expected"
      );
    }
  }
}
