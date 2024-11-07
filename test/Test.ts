import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import EnglishABI from './abi/englishAuction.json';
import DutchABI from './abi/dutchAuction.json';
import FixedABI from './abi/fixSale.json';

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
describe("Send FeeToken to buyers", async function () {
    it("start distributing FeeToken", async function () {
        await FeeToken.transfer(buyer1.address, ethers.parseEther("1000"));
        await FeeToken.transfer(buyer2.address, ethers.parseEther("1000"));
        await FeeToken.transfer(buyer3.address, ethers.parseEther("1000"));
        expect(await FeeToken.balanceOf(buyer1.address)).to.equal(ethers.parseEther("1000"));
        expect(await FeeToken.balanceOf(buyer2.address)).to.equal(ethers.parseEther("1000"));
        expect(await FeeToken.balanceOf(buyer3.address)).to.equal(ethers.parseEther("1000"));
    })
})
const tokenURI_1: string = "firstToken";
const tokenURI_2: string = "secondToken";
const tokenURI_3: string = "thirdToken";
describe("Mint NFT", async function () {
  it("creator1 mint new NFT", async function () {
    await Collection.connect(creator1).mint(tokenURI_1);
    expect(await Collection.ownerOf(0)).equal(creator1);
  })
  it("creator2 mint new NFT", async function () {
    await Collection.connect(creator2).mint(tokenURI_2);
    expect(await Collection.ownerOf(1)).equal(creator2);
  })
  it("creator3 mint new NFT", async function () {
    await Collection.connect(creator3).mint(tokenURI_3);
    expect(await Collection.ownerOf(2)).equal(creator3);
  })
  it("error if creator1 mint second NFT before total NFT Number is 1000", async function(){
    await expect(Collection.connect(creator1).mint("DisableMint")).to.be.revertedWith("Invalid minter")
  })
});

let englishAuctionContract: any;
let englishAuctionContractAddress: any;
let dutchAuctionContract: any;
let dutchAuctionContractAddress: any;
let fixSaleContract: any;
let fixSaleContractAddress: any;
describe("open English Auctions", async function(){
  it("creator1 open English Auction", async function(){
    await Marketplace.connect(creator1).openEnglishAuction(CollectionAddress, 0, ethers.parseEther("1"), 3600);
    const englishAuctionNumber = await Marketplace.englishAuctionLength();
    console.log("englishAuctionNumber", englishAuctionNumber);
    englishAuctionContractAddress = await Marketplace.englishAuctions(Number(englishAuctionNumber) - 1);
    console.log("englishAuctionContractAddress", englishAuctionContractAddress);
    englishAuctionContract = new ethers.Contract(
      englishAuctionContractAddress,
      EnglishABI,
      ethers.provider
    );
    await Collection.connect(creator1).approve(englishAuctionContractAddress, 0);

  })
  it("creator2 open Dutch Auction", async function(){
    await Marketplace.connect(creator2).openDutchAuction(CollectionAddress, 1, ethers.parseEther("1"), 7200, ethers.parseEther("0.3"));
    const dutchAuctionNumber = await Marketplace.dutchAuctionLength();
    console.log("dutchAuctionNumber", dutchAuctionNumber);
    dutchAuctionContractAddress = await Marketplace.dutchAuctions(Number(dutchAuctionNumber) - 1);
    console.log("dutchAuctionContractAddress", dutchAuctionContractAddress);
    dutchAuctionContract = new ethers.Contract(
      dutchAuctionContractAddress,
      DutchABI,
      ethers.provider
    );
    await Collection.connect(creator2).approve(dutchAuctionContractAddress, 1);

  })
  it("creator3 open FixSale", async function(){
    await Marketplace.connect(creator3).openFixSale(CollectionAddress, 2, ethers.parseEther("1"));
    const fixSaleNumber = await Marketplace.fixSaleLength();
    console.log("fixSaleNumber", fixSaleNumber);
    fixSaleContractAddress = await Marketplace.fixSales(Number(fixSaleNumber) - 1);
    console.log("fixSaleContractAddress", fixSaleContractAddress);
    fixSaleContract = new ethers.Contract(
      fixSaleContractAddress,
      FixedABI,
      ethers.provider
    );
    await Collection.connect(creator3).approve(fixSaleContractAddress, 2);

  })
})