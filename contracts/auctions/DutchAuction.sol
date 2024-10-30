// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract DutchAuction {
    address public seller;
    address public nftContract;
    uint256 public tokenId;
    uint256 public initPrice;
    uint256 public reducingRate;
    bool public finishedState;
    uint256 public startTime;
    uint256 public period;
    uint256 public endTime;
    address public feeToken;
    address public marketplace;
    address public buyer;
    uint256 public marketFee;
    constructor(address _seller, address _nftContract, uint256 _tokenId, uint256 _initPrice,
        uint256 _period, uint256 _reducingRate, address _feeToken, uint256 _marketFee){
        seller = _seller;
        nftContract = _nftContract;
        tokenId = _tokenId;
        initPrice = _initPrice;
        period = _period;
        startTime = block.timestamp;
        endTime = startTime + period;
        reducingRate = _reducingRate;
        feeToken = _feeToken;
        marketplace = msg.sender;
        marketFee = _marketFee;
        require(IERC721(nftContract).ownerOf(tokenId) == seller, "Not owner");
        require((reducingRate * period / 3600) < initPrice, "Invalid auction infor");
    }

    function getDutchAuctionPrice() public view returns(uint256){
        require(!finishedState, "ALready sold out");
        return initPrice - reducingRate * ((block.timestamp - startTime) / 3600);
    }

    function buyDutchAuction() external{
        require(!finishedState, "ALready sold out");
        uint256 currentPrice = getDutchAuctionPrice();
        uint256 marketFeeAmount = (currentPrice * marketFee) / 100;
        uint256 sellerAmount = currentPrice - marketFeeAmount;
        SafeERC20.safeTransferFrom(IERC20(feeToken), msg.sender, marketplace, marketFeeAmount);
        SafeERC20.safeTransferFrom(IERC20(feeToken), msg.sender, seller, sellerAmount);
        IERC721(nftContract).transferFrom(seller, msg.sender, tokenId);
        endTime = block.timestamp;
        finishedState = true;
        buyer = msg.sender;
    }
}