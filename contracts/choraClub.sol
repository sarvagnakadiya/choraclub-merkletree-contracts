// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ChoraClubOld is Initializable, ERC721Upgradeable ,ERC721URIStorageUpgradeable, ERC721PausableUpgradeable, OwnableUpgradeable, ERC721BurnableUpgradeable, UUPSUpgradeable {
    uint256 private _nextTokenId;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    bytes32 public merkleRoot;

    function initialize(bytes32 _merkleRoot) initializer public {
        __ERC721_init("MyToken", "MTK");
        __ERC721Pausable_init();
        __Ownable_init(msg.sender);
        __ERC721Burnable_init();
        __UUPSUpgradeable_init();
        merkleRoot = _merkleRoot;
    }

    function setMerkleRoot(bytes32 _merkleRoot)public onlyOwner{
        merkleRoot = _merkleRoot;
    }

    function verifyRoot(bytes32[] calldata _merkleProof) public view returns (bool){
        return (MerkleProof.verifyCalldata(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))));
    }

    modifier onlyMinters(bytes32[] calldata _merkleProof) {
        require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))),"not Minter");
        _;
    }
    
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri, bytes32[] calldata _merkleProof) public onlyMinters(_merkleProof) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721Upgradeable, ERC721PausableUpgradeable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
}
