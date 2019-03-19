var HDWalletProvider = require('truffle-hdwallet-provider');
var mnemonic = 'beach cram loud shine notable purpose also peace beauty either either strong';
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/0586b503c35246f6a57bb3bf32f63ba8')
      },
      network_id: 4,
      gas: 4500000,
      gasPrice: 10000000000
    }
  }
};