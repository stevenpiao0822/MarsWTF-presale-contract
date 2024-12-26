// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Collection
 * @author Steven Leal
 * @notice Collection contract
 */
contract Collection is ERC721 {
    string public description;
    uint256 public tokenNumber;
    mapping(uint256 => string) private nftURIPath; // Mapping to store NFT URI paths
    address public feeToken;
    uint256 public mintFee;
    mapping(address => uint256) creators;
    address public devTeam;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _description,
        address _feeToken,
        uint256 _mintFee,
        address _devTeam
    ) ERC721(_name, _symbol) {
        description = _description;
        feeToken = _feeToken;
        mintFee = _mintFee;
        devTeam = _devTeam;
    }
}
