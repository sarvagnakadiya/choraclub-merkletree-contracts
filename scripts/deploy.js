const { ethers, upgrades } = require("hardhat");

async function main() {
  console.log("Deploying ChoraClub Upgradable contract...");

  // Deploy the upgradeable contract
  const ChoraClub = await ethers.getContractFactory("ChoraClub");
  const choraClub = await upgrades.deployProxy(ChoraClub, [
    "0x2d0233393a8c6ed12d0ab075c1d5b5732f76e114b64d35dbd7ae3984954b84b3",
  ]);

  console.log("Proxy of ChoraClub deployed to:", choraClub.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
