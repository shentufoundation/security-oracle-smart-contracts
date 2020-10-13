// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CertiKSecurityOracle.sol";
import "../contracts/CertiKSecurityOracleProxy.sol";

contract TestProxy {
  CertiKSecurityOracle so;
  CertiKSecurityOracleProxy proxy;

  function beforeEach() public {
    so = new CertiKSecurityOracle();

    proxy = new CertiKSecurityOracleProxy(address(so));
  }

  function getMyNumber() public pure returns (uint256) {
    return 999;
  }

  function testProxy() public {
    uint256 proxyScore = uint256(
      CertiKSecurityOracle(proxy.getProxyAddress()).defaultScore()
    );

    uint256 directScore = uint256(so.defaultScore());

    Assert.equal(proxyScore, directScore, "proxy failed");
  }

  function testUpgradeOracleAddress() public {
    Assert.equal(
      proxy.currentOracleAddress(),
      address(so),
      "address was not right"
    );

    proxy.upgradeOracleAddress(address(this));

    Assert.equal(
      proxy.currentOracleAddress(),
      address(this),
      "address was not upgraded"
    );

    Assert.equal(
      TestProxy(proxy.getProxyAddress()).getMyNumber(),
      999,
      "behavior was not upgraded"
    );
  }
}
