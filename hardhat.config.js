require("@nomicfoundation/hardhat-toolbox");
// require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config({ path: __dirname + "/.env" });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: process.env.RPC_URL_MUMBAI,
      accounts: [process.env.PRIVATE_KEY],
    },
    optimismSepolia: {
      url: process.env.RPC_URL_OPTIMISM_SEPOLIA,
      accounts: [process.env.PRIVATE_KEY],
    },
    arbitrumSepolia: {
      url: process.env.RPC_URL_ARBITRUM_SEPOLIA,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
    customChains: [
      {
        network: "arbitrumSepolia",
        chainId: 421614,
        urls: {
          apiURL: "https://api-sepolia.arbiscan.io/api",
          browserURL: "https://sepolia.arbiscan.io/",
        },
      },
    ],
  },
  sourcify: {
    enabled: false,
  },
};
