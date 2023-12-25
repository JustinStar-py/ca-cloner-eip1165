require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "testnet",
  networks: {
    localhost: {
        url: "http://127.0.0.1:8545",
        accounts: [process.env.LOCALHOST_ACC,]
      },
      hardhat: {
      },
      testnet: {
        url: "https://aged-floral-cloud.bsc-testnet.quiknode.pro/1ca68f0cd986a967e81678b1c02105f4588e60ae/",
        // url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
        chainId: 97,
        gasPrice: 20000000000,
        accounts: [process.env.BSC_ACC,]
      },
      mainnet: {
          url: "https://bsc-dataseed.binance.org/",
          chainId: 56,
          gasPrice: 20000000000,
          accounts: [process.env.BSC_ACC,]
      },
      ethereum: {
        url: "https://www.noderpc.xyz/rpc-mainnet/public",
        chainId: 1,
        accounts: [process.env.ETH_ACC,]
      },
      baseGoerli: {
        url: "https://powerful-methodical-uranium.base-goerli.discover.quiknode.pro/a7be3c5b9e1234c06a8d4b0b866fc8c9ca6a154f/",
        chainId: 84531,
        gasPrice: 20000000000,
        accounts: [process.env.BSC_ACC,]
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://bscscan.com/
    apiKey: process.env.BSCSCAN_API
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true
      }}
   }
};