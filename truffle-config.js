var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "inspire staff omit remain spirit regular allow reflect capable wasp tray topple";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    develop: {
      port: 8545
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/85e9a467fa6a418b8621bd82b6db68f4")
      },
      network_id: 3,
      gas: 4000000      //make sure this gas allocation isn't over 4M, which is the max
  }
  }
};
