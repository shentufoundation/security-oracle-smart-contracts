const CertiKSecurityOracle = artifacts.require("CertiKSecurityOracle");
const CertiKSecurityOracleProxy = artifacts.require("CertiKSecurityOracleProxy");

module.exports = async function(deployer, network, accounts) {
  try {
    await deployer.deploy(CertiKSecurityOracleProxy,
      CertiKSecurityOracle.address,
      {
        from: accounts[1]
      }
    );

    console.log("CertiKSecurityOracleProxy deployed");
  } catch (e) {
    console.log("Error deploy", e);
  }
};
