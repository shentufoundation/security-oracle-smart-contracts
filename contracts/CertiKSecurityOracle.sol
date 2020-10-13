// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./openzeppelin/AccessControl.sol";

contract CertiKSecurityOracle is AccessControl {
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
  // set permitted contribuer role
  bytes32 public constant CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");

  constructor() public {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    initialize();
  }


  modifier onlyAdminList() {
    require(isContributor(msg.sender) || isAdmin(msg.sender), "restricted to contributer and administrator");
    _;
  }

  modifier onlyAdmin() {
    require(isAdmin(msg.sender), "restricted to administrator");
    _;
  }


  function isContributor(address account)
    public virtual view returns (bool)
  {
    return hasRole(CONTRIBUTOR_ROLE, account);
  }  


  function isAdmin(address account)
    public virtual view returns (bool)
  {
    return hasRole(DEFAULT_ADMIN_ROLE, account);
  }


  function addContributor(address account) public virtual onlyAdmin {
    grantRole(CONTRIBUTOR_ROLE, account);
  }


  function revokeContributor(address account) public virtual onlyAdmin {
    revokeRole(CONTRIBUTOR_ROLE, account);
  }



  function _getSecurityScore(address contractAddress, bytes4 functionSignature)
    internal
    view
    returns (uint8)
  {
    Result memory result = _results[contractAddress][functionSignature];

    if (result.expiration > block.timestamp) {
      return result.score;
    } else {
      return defaultScore;
    }
  }

  function getSecurityScoreBytes4(address contractAddress, bytes4 functionSignature)
    public
    view
    returns (uint8)
  {
    require(contractAddress != address(0), "address should not be 0x0");
    require(
      functionSignature != bytes4(0),
      "signature bytes4(0) was reserved for special purposes, if your function signature conflicted with this value please consider to rename the function to avoid the conflict"
    );

    return _getSecurityScore(contractAddress, functionSignature);
  }

  function getSecurityScore(
    address contractAddress,
    string memory functionSignature
  ) public view returns (uint8) {
    return
      getSecurityScoreBytes4(
        contractAddress,
        bytes4(keccak256(abi.encodePacked(functionSignature)))
      );
  }

  function getSecurityScore(address contractAddress)
    public
    view
    returns (uint8)
  {
    require(contractAddress != address(0), "address should not be 0x0");
    return _getSecurityScore(contractAddress, bytes4(0));
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
      scores[i] = getSecurityScoreBytes4(addresses[i], functionSignatures[i]);
    }

    return scores;
  }

  function pushResult(
    address contractAddress,
    bytes4 functionSignature,
    uint8 score,
    uint248 expiration
  ) public onlyAdminList {
    require(
      contractAddress != address(0),
      "contract address should not be 0x0"
    );
    
    _results[contractAddress][functionSignature] = Result(score, expiration);

    emit ResultUpdate(contractAddress, functionSignature, score, expiration);
  }

  function batchPushResult(
    address[] memory contractAddresses,
    bytes4[] memory functionSignatures,
    uint8[] memory scores,
    uint248[] memory expirations
  ) public onlyAdminList {
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

  function initialize() public onlyAdmin {
    defaultScore = 128;

    emit Init(defaultScore);
  }

  function updateDefaultScore(uint8 score) public onlyAdmin {
    defaultScore = score;

    emit DefaultScoreChanged(score);
  }
}
