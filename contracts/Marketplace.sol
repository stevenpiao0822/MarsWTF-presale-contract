// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {EnglishAuction} from "./auctions/EnglishAuction.sol";
import {DutchAuction} from "./auctions/DutchAuction.sol";
import {FixSale} from "./auctions/FixSale.sol";

contract Marketplace {
    // State variables
    address public owner; // Address of the contract owner
    address public devTeam;
    address public feeToken;
    uint256 public marketFee;
    uint256 public listFee;
    address[] public englishAuctions;
    address[] public dutchAuctions;
    address[] public fixSales;
    // Modifier to restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(
        address _devTeam,
        address _feeToken,
        uint256 _marketFee,
        uint256 _listFee
    ) payable {
        owner = msg.sender;
        devTeam = _devTeam;
        feeToken = _feeToken;
        marketFee = _marketFee;
        listFee = _listFee;
    }
}
