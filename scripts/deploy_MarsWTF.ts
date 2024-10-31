// Importing necessary functionalities from the Hardhat package.
import { ethers } from 'hardhat'

async function main() {
    console.log("Deploying MarsWTF and USDC...");
    // Retrieve the first signer, typically the default account in Hardhat, to use as the deployer.
    const [deployer] = await ethers.getSigners();
    const instanceMarsWTF = await ethers.deployContract("MarsWTF");
    await instanceMarsWTF.waitForDeployment()
    const MarsWTF_Address = await instanceMarsWTF.getAddress();
    console.log(`MarsWTF is deployed. ${MarsWTF_Address}`);
    const instanceUSDC = await ethers.deployContract("USDCToken");
    await instanceUSDC.waitForDeployment()
    const USDC_Address = await instanceUSDC.getAddress();
    console.log(`USDC is deployed. ${USDC_Address}`);
}

// This pattern allows the use of async/await throughout and ensures that errors are caught and handled properly.
main().catch(error => {
    console.error(error)
    process.exitCode = 1
})