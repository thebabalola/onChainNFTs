import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import hre from "hardhat";
import { expect } from "chai";

describe("OnChainNFT", () => {
    async function nftFixture() {
        const [owner, addr1] = await hre.ethers.getSigners();
        
        const tokenFactory = await hre.ethers.getContractFactory("OnChainNFT");
        const token = await tokenFactory.deploy("OnChainNFT", "OCN");

        // await token.deployed();
        return { owner, addr1, token };
    }

    describe("Deployment", () => {
        it("should deploy the contract with correct parameters", async () => {
            const { owner, token } = await loadFixture(nftFixture);
            const uri = await token.tokenURI(1);
            console.log(uri)
        })
    })
});
