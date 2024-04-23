const { ethers, upgrades } = require("hardhat");

async function main() {
  console.log("Deploying ChoraClub Upgradable contract WITH ERC-1155...");

  // Deploy the upgradeable contract
  const ChoraClub = await ethers.getContractFactory("ChoraClub");
  const choraClub = await upgrades.deployProxy(ChoraClub, [
    "0x24d9694b7460cb82af1f4a6a37967f5aac0a6d65122f2f8b8dfaca203cb6dcf5",
  ]);

  console.log("Proxy of ChoraClub ERC-1155 deployed to:", choraClub.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
