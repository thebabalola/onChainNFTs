import { ethers } from "hardhat";
import { ContractTransactionReceipt, EventLog } from "ethers";

async function deployOnChainNFT() {
  console.log("Deploying OnChainNFT contract...");
  
  // Get the deployer's address
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  // Deploy the OnChainNFT contract
  const OnChainNFT = await ethers.getContractFactory("OnChainNFT");
  const onChainNFT = await OnChainNFT.deploy(deployer.address);
  
  // Wait for deployment
  await onChainNFT.waitForDeployment();
  const onChainNFTAddress = await onChainNFT.getAddress();
  
  console.log("OnChainNFT deployed to:", onChainNFTAddress);
  
  // Verify contract details
  console.log("NFT Name:", await onChainNFT.name());
  console.log("NFT Symbol:", await onChainNFT.symbol());
  
  // Mint a test NFT to the deployer
  console.log("\nMinting a test NFT to deployer...");
  const mintTx = await onChainNFT.safeMint(deployer.address);
  const receipt = await mintTx.wait();
  
  // Handle null receipt case
  if (!receipt) {
    console.log("Transaction receipt is null. The transaction may not have been mined yet.");
    return {
      onChainNFTAddress,
      deployerAddress: deployer.address
    };
  }
  
  // Find the tokenId from the transfer event
  let tokenId = 0;
  for (const log of receipt.logs) {
    // Check if the log is an EventLog (which has a parsed fragment and args)
    if ('args' in log && log.fragment && log.fragment.name === 'Transfer') {
      // It's a Transfer event, extract the tokenId
      tokenId = log.args[2]; // TokenId is the third argument in Transfer events
      break;
    }
  }
  
  console.log(`Successfully minted NFT #${tokenId} to ${deployer.address}`);
  
  // Generate and display token URI
  const tokenURI = await onChainNFT.getTokenURI(tokenId);
  console.log("\nToken URI data:");
  console.log(tokenURI);
  
  // Extract just the base64 part of the data URI
  const base64Data = tokenURI.split(",")[1];
  const decodedData = Buffer.from(base64Data, "base64").toString();
  console.log("\nDecoded metadata:");
  console.log(decodedData);
  
  console.log("\nDeployment complete!");
  
  return {
    onChainNFTAddress,
    deployerAddress: deployer.address,
    tokenId
  };
}

// Execute the deployment
deployOnChainNFT()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment failed:", error);
    process.exit(1);
  });