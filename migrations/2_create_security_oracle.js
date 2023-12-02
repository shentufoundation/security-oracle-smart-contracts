const CertiKSecurityOracle = artifacts.require("CertiKSecurityOracle");

module.exports = async function(deployer, network, accounts) {
  try {
    await deployer.deploy(CertiKSecurityOracle,
      {
        from: accounts[0]
      }
    );

    
  } catch (e) {
    console.log("Error deploy", e);
  }
};
