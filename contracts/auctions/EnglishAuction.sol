// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnglishAuction {
    address public seller;
    address public nftContract;
    uint256 public tokenId;
    uint256 public initPrice;
    uint256 public currentPrice;
    bool public finishedState;
    uint256 public startTime;
    uint256 public period;
    uint256 public endTime;
    address public feeToken;
    mapping(address => uint256) public balance;
    address public marketplace;
    address public winner;
    uint256 public marketFee;

    constructor(
        address _seller,
        address _nftContract,
        uint256 _tokenId,
        uint256 _initPrice,
        uint256 _period,
        address _feeToken,
        uint256 _marketFee
    ) {
        seller = _seller;
        nftContract = _nftContract;
        tokenId = _tokenId;
        initPrice = currentPrice = _initPrice;
        period = _period;
        startTime = block.timestamp;
        endTime = startTime + period;
        feeToken = _feeToken;
        marketplace = msg.sender;
        marketFee = _marketFee;
        require(IERC721(nftContract).ownerOf(tokenId) == seller, "Not owner");
    }

    function bidEnglishAuction(uint256 price) external {
        require(!finishedState, "ALready sold out");
        require(price > currentPrice, "Lower price");
        SafeERC20.safeTransferFrom(
            IERC20(feeToken),
            msg.sender,
            address(this),
            price
        );
        if (currentPrice != initPrice) balance[winner] += currentPrice;
        winner = msg.sender;
        currentPrice = price;
    }

    function endEnglishAuction() external {
        require(!finishedState, "ALready sold out");
        require(msg.sender == seller, "Only seller can call this function");
        uint256 marketFeeAmount = (currentPrice * marketFee) / 100;
        uint256 sellerAmount = currentPrice - marketFeeAmount;
        SafeERC20.safeTransfer(IERC20(feeToken), marketplace, marketFeeAmount);
        SafeERC20.safeTransfer(IERC20(feeToken), seller, sellerAmount);
        IERC721(nftContract).transferFrom(seller, winner, tokenId);
        finishedState = true;
        endTime = block.timestamp;
    }

    function withdraw() external {
        uint256 amount = balance[msg.sender];
        require(amount > 0, "No amount to withdraw");
        balance[msg.sender] = 0;
        SafeERC20.safeTransfer(IERC20(feeToken), msg.sender, amount);
    }
}
