import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
// import EnglishABI from './abi/englishAuction.json';
// import DutchABI from './abi/dutchAuction.json';
// import FixedABI from './abi/fixSale.json';

let FeeToken: any;
let FeeTokenAddress: any;
let Collection: any;
let CollectionAddress: any;
let Marketplace: any;
let MarketplaceAddress: any;
let owner: any;
let devTeam: any;
let creator1: any;
let creator2: any;
let creator3: any;
let buyer1: any;
let buyer2: any;
let buyer3: any;
const percentForSeller: number = 85;
const mintFee: string = "10";
const marketFee: number = 0;
const listFee: string = "0";

describe("Create Initial Contracts of all types", function () {
    it("get accounts", async function () {
        [owner, devTeam, creator1, creator2, creator3, buyer1, buyer2, buyer3] =
            await ethers.getSigners();
        console.log("\tAccount address\t", await owner.getAddress());
    });
    it("should deploy FeeToken Contract", async function () {
        const instanceFeeToken = await ethers.getContractFactory("MarsWTF");
        FeeToken = await instanceFeeToken.deploy();
        FeeTokenAddress = await FeeToken.getAddress();
        console.log("\tFeeToken Contract deployed at:", FeeTokenAddress);
    });
    it("should deploy Collection Contract", async function () {
        const instanceCollection = await ethers.getContractFactory("Collection");
        Collection = await instanceCollection.deploy("MarsWTF", "MarsWTF", "Its for MarsWTF", FeeTokenAddress, ethers.parseEther(mintFee), devTeam);
        CollectionAddress = await Collection.getAddress();
        console.log("\tCollection Contract deployed at:", CollectionAddress);
    });
    it("should deploy Marketplace Contract", async function () {
        const instanceMarketplace = await ethers.getContractFactory("Marketplace");
        Marketplace = await instanceMarketplace.deploy(devTeam, FeeTokenAddress, marketFee, ethers.parseEther(listFee));
        MarketplaceAddress = await Marketplace.getAddress();
        console.log("\tMarketplace Contract deployed at:", MarketplaceAddress);
    });
});