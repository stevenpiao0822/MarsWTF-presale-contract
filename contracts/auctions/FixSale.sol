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
}
