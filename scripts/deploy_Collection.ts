// Importing necessary functionalities from the Hardhat package.
import { ethers } from "hardhat";

async function main() {
  // Retrieve the first signer, typically the default account in Hardhat, to use as the deployer.
  const [deployer] = await ethers.getSigners();
  // const instanceMyToken = await ethers.deployContract("MarsWTF");
  // await instanceMyToken.waitForDeployment()
  // const MyToken_Address = await instanceMyToken.getAddress();
  // console.log(`MyToken is deployed. ${MyToken_Address}`);
  const instanceCollection = await ethers.deployContract("Collection", [
    "MarsWTF",
    "MarsWTF",
    "Welcome to the future",
    "0x5C2A60632BeaEb5aeF7F0D82088FC620BEC5b376",
    0,
    "0xC6d5F7B1fD65acab579C942799B24699Fc1D0125",
  ]);
  await instanceCollection.waitForDeployment();
  const Collection_address = await instanceCollection.getAddress();
  console.log(`Collection is deployed. ${Collection_address}`);
}