// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract FixSale {
    address public seller;
    address public nftContract;
    uint256 public tokenId;
    uint256 public currentPrice;
    bool public finishedState;
    uint256 public startTime;
    uint256 public endTime;
    address public feeToken;
    address public marketplace;
    address public buyer;
    uint256 public marketFee;

    constructor(
        address _seller,
        address _nftContract,
        uint256 _tokenId,
        uint256 _initPrice,
        address _feeToken,
        uint256 _marketFee
    ) {
        seller = _seller;
        nftContract = _nftContract;
        tokenId = _tokenId;
        currentPrice = _initPrice;
        startTime = block.timestamp;
        feeToken = _feeToken;
        marketplace = msg.sender;
        marketFee = _marketFee;
        require(IERC721(nftContract).ownerOf(tokenId) == seller, "Not owner");
    }

    function buyFixedSale() external {
        require(!finishedState, "ALready sold out");
        uint256 marketFeeAmount = (currentPrice * marketFee) / 100;
        uint256 sellerAmount = currentPrice - marketFeeAmount;
        SafeERC20.safeTransferFrom(
            IERC20(feeToken),
            msg.sender,
            marketplace,
            marketFeeAmount
        );
        SafeERC20.safeTransferFrom(
            IERC20(feeToken),
            msg.sender,
            seller,
            sellerAmount
        );
        IERC721(nftContract).transferFrom(seller, msg.sender, tokenId);
        buyer = msg.sender;
        endTime = block.timestamp;
        finishedState = true;
    }
}
