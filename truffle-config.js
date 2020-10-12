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
          console.log("missing env var TRUFFLE_PRIVATE_KEY");
          process.exit(1);
        }

        const rpc = process.env.TRUFFLE_RPC;

        if (!rpc) {
          console.log("missing env var TRUFFLE_RPC");
          process.exit(1);
        }

        return new HDWalletProvider(privateKey, rpc);
      },
      network_id: "*"
    }
  },
  compilers: {
    solc: {
       version: "0.5.17"
    }
  }
};
