// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OnChainNFT is ERC721 {

    uint256 tokenID;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
                    mint(msg.sender);
    }

    function mint(address _to) public returns(uint256) {
        tokenID++;
        _safeMint(_to, tokenID);

        return tokenID;
    }

    function genSVG() internal pure returns (string memory) {
    string memory svg = 
        "<svg width='500' height='500' xmlns='http://www.w3.org/2000/svg'>"
        "<rect width='100%' height='100%' fill='#E0E0E0'/>"
        "<circle cx='250' cy='250' r='150' fill='#1E90FF'/>"
        "<text x='50%' y='55%' font-family='Arial' font-size='30' fill='#FFFFFF' text-anchor='middle'>"
        "onChainNFT"
        "</text>"
        "</svg>";

    return Base64.encode(bytes(svg)); // OpenSea Compatibility: OpenSea expects the image field to be Base64-encoded, which was missing in the initial implementation.
}

function tokenURI(uint256 tokenId) public pure override returns (string memory) {
    string memory dataURI = string(
        abi.encodePacked(
            '{',
                '"name": "onChain NFT #', Strings.toString(tokenId), '",',
                '"description": "A simple on-ChainNFT",',
                '"image": "data:image/svg+xml;base64,', genSVG(), '"',
            '}'
        )
    );

    return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(dataURI))));
}

}

