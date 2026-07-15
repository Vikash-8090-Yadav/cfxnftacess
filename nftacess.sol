// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTSubscription is ERC721 {

    uint256 public tokenId;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant DURATION = 30 days;

    mapping(uint256 => uint256) public expiry;

    constructor() ERC721("Subscription NFT", "SUB") {}

    function subscribe() external payable {
        require(msg.value == PRICE, "Wrong payment");

        tokenId++;
        _mint(msg.sender, tokenId);

        expiry[tokenId] = block.timestamp + DURATION;
    }

    function renew(uint256 _tokenId) external payable {
        require(ownerOf(_tokenId) == msg.sender, "Not owner");
        require(msg.value == PRICE, "Wrong payment");

        if (expiry[_tokenId] < block.timestamp) {
            expiry[_tokenId] = block.timestamp + DURATION;
        } else {
            expiry[_tokenId] += DURATION;
        }
    }

    function isActive(uint256 _tokenId) external view returns (bool) {
        return expiry[_tokenId] > block.timestamp;
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
