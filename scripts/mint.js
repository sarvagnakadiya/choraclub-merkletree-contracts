const { ethers } = require("hardhat");

async function main() {
  console.log("Minting a NFT...");

  const contractAddress = "0xF6fd87A08054Ea4c01B06DcFE6F1464a9a708DF3"; // Replace with the actual contract address

  // Connect to the contract
  const contract = await ethers.getContractAt("ChoraClub", contractAddress);

  const mintTx = await contract.mint(
    "0x97861976283e6901b407D1e217B72c4007D9F64D",
    "abc-xyz",
    1,
    "ipfs://bafyreih3xxrb5k7zb2bhaqnjrdjzvmq6eh7csj3nq3yly5u3lssi4tdvly/metadata.json",
    "0x16",
    ["0xdc065fa866e34be7a1c32a9b59c7a20dcf1f1bd9ebb703412ffedcbcfd36bc99"]
  );
  console.log(mintTx);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
