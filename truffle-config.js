const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    production: {
      provider: () => {
        const privateKey = process.env.TRUFFLE_PRIVATE_KEY;

        if (!privateKey) {
          
          process.exit(1);
        }

        const rpc = process.env.TRUFFLE_RPC;

        if (!rpc) {
          
          process.exit(1);
        }

        return new HDWalletProvider(privateKey, rpc);
      },
      network_id: "*"
    }
  },
  compilers: {
    solc: {
       version: "0.6.12"
    }
  }
};
