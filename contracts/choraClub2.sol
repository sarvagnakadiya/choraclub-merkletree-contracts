// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract ChoraClub is Initializable, ERC1155Upgradeable,ERC1155URIStorageUpgradeable, OwnableUpgradeable, ERC1155PausableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // Have to override this foe ERC1155URIStorageUpgradeable
    function uri(uint256 tokenId) public view override(ERC1155Upgradeable, ERC1155URIStorageUpgradeable) returns (string memory) {
        return ERC1155URIStorageUpgradeable.uri(tokenId);
    }

    function uriFromMeetingId(string memory _meetingId) public view returns(string memory){
        uint256 tokenId = uint256(keccak256(abi.encodePacked(_meetingId)));
        return ERC1155URIStorageUpgradeable.uri(tokenId);
    }

    bytes32 public merkleRoot;

    function initialize(bytes32 _merkleRoot) initializer public {
        // base URI
        __ERC1155_init("https://ipfs.io/ipfs/bafkreidyzbxeaqeb3r6q4cwjnqwgx7mgrdvic2bgmloisf2vw7pyqdckwu");
        __Ownable_init(msg.sender);
        __ERC1155Pausable_init();
        __ERC1155Supply_init();
        __UUPSUpgradeable_init();
        merkleRoot = _merkleRoot;
    }

    // https://ipfs.io/ipfs/bafkreidyzbxeaqeb3r6q4cwjnqwgx7mgrdvic2bgmloisf2vw7pyqdckwu

    function setMerkleRoot(bytes32 _merkleRoot)public onlyOwner{
        merkleRoot = _merkleRoot;
    }

    function verifyRoot(bytes32[] calldata _merkleProof) public view returns (bool){
        return (MerkleProof.verifyCalldata(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))));
    }

    modifier onlyMinters(bytes32[] calldata _merkleProof) {
        require(MerkleProof.verifyCalldata(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))),"not Minter");
        _;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, string memory meetingId, uint256 amount,string memory newuri, bytes memory data, bytes32[] calldata _merkleProof)
        public
        onlyMinters(_merkleProof)
        returns(uint256)
    {
        uint256 id = uint256(keccak256(abi.encodePacked(meetingId)));
        _mint(account, id, amount, data);
        // ERC1155URIStorageUpgradeable's _setURI
        _setURI(id, newuri);
        return id;
    }

    function convert(string memory _meetingId)public pure returns(uint256){
        return uint256(keccak256(abi.encodePacked(_meetingId)));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155Upgradeable, ERC1155PausableUpgradeable, ERC1155SupplyUpgradeable)
    {
        super._update(from, to, ids, values);
    }
}
