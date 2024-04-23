const fs = require("fs");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const ownerAddresses = require("../ownerAddresses.json");

// File path for storing and reading ownerAddresses

async function createMerkleTree() {
  // Try to read ownerAddresses from the JSON file

  const leafNodes = ownerAddresses.map((addr) => keccak256(addr));

  // Create a Merkle tree
  const merkleTree = new MerkleTree(leafNodes, keccak256, {
    sortLeaves: true,
    sortPairs: true,
  });

  // Get the Merkle root
  const merkleRoot = merkleTree.getRoot().toString("hex");
  console.log("Merkle Root:", merkleRoot);

  const hexPrrof = merkleTree.getHexProof(
    keccak256("0x97861976283e6901b407D1e217B72c4007D9F64D")
  );

  console.log(hexPrrof);

  console.log(
    merkleTree.verify(
      hexPrrof,
      keccak256("0x97861976283e6901b407D1e217B72c4007D9F64D"),
      merkleRoot
    )
  );
}

createMerkleTree();
