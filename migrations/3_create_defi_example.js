const CertiKSecurityOracle = artifacts.require("CertiKSecurityOracle");
const DeFiExample = artifacts.require("DeFiExample");

module.exports = async function (deployer, network, accounts) {
  if (network === "development" || network === "test") {
    try {
      await deployer.deploy(
        DeFiExample,
        CertiKSecurityOracle.address,
        {
          from: accounts[0]
        }
      );

      console.log("DeFiExample deployed");
    } catch (e) {
      console.log("Error deploy", e);
    }
  }
};
