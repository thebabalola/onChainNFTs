// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

using Strings for uint256; 

contract OnChainNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner)
        ERC721("onChainNFT", "OCN")
        Ownable(initialOwner)
    {}

    function safeMint(address to) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        return tokenId;
    }

    function generateNFT(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            "<svg width='500' height='500' xmlns='http://www.w3.org/2000/svg'>"
            "<rect width='100%' height='100%' fill='#E0E0E0'/>"
            "<circle cx='250' cy='250' r='150' fill='#1E90FF'/>"
            "<text x='50%' y='55%' font-family='Arial' font-size='30' fill='#FFFFFF' text-anchor='middle'>"
            "onChainNFT"
            "</text>"
            "</svg>"
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "onChain NFT ', tokenId.toString(), '",',
                '"description": "A simple on-ChainNFT",',
                '"image": "', generateNFT(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
}
