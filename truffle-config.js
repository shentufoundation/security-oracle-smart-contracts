const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    bsc: {
      provider: () => {
        const privateKey = process.env.TRUFFLE_PRIVATE_KEY;

        if (!privateKey) {
          console.log("missing env var TRUFFLE_PRIVATE_KEY");
          process.exit(1);
        }

        return new HDWalletProvider(
          privateKey,
          "https://data-seed-prebsc-1-s1.binance.org:8545/"
        );
      },
      network_id: "*"
    }
  }
};
