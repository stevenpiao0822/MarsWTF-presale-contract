// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
// mainnet usdc address 0xdAC17F958D2ee523a2206206994597C13D831ec7

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

// address constant MAINNET_USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d; // USDC address in BSC
// address constant MAINNET_USDC = 0x16227D60f7a0e586C66B005219dfc887D13C9531; // USDC address in BSC Testnet
address constant MAINNET_USDC = 0xA1f5aE420cCAAadA3ddF121afA72E22483b538B9; // USDC address in Sepolia Testnet

// address constant MAINNET_TOKEN = 0x5DFADeacc8239edBDa5598AEEd615d18F6825dE9; // Token Address in BSC
// address constant MAINNET_TOKEN = 0x69C9A6ccb9d07276e960eC7eD05e46ea815eD579; // Token Address in BSC Testnet
address constant MAINNET_TOKEN = 0x5C2A60632BeaEb5aeF7F0D82088FC620BEC5b376; // Token Address in Sepolia Testnet

// mainnet router
// address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
//     0x10ED43C718714eb63d5aA57B78B54704E256024E
// );

// BSC testnet router
// address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
//     0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
// );

// Sepolia testnet router
address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
    0x8cFe327CEc66d1C090Dd72bd0FF11d690C33a2Eb
);

contract Presale is Ownable {
    bool public presaleStarted;
    uint public startTimeStamp; // presale start time
    uint public endTimeStamp; // presale endtime
    uint256 public fundsRaised; // funds raised by presale
    uint256 public soldAmount;
    uint256 public presaleAmount = 10 ** (8 + 18);
    uint256 public INITIAL_TOKEN_PRICE = 14; //0.000014
    mapping(address => uint256) balanceOf;
    IUniswapV2Router02 public router =
        IUniswapV2Router02(address(PANCAKESWAPV2_ROUTER_ADDRESS));

    IERC20 usdc = IERC20(MAINNET_USDC); // USDC contract address
    IERC20 token = IERC20(MAINNET_TOKEN);

    receive() external payable {}

    constructor() Ownable(msg.sender) {
        fundsRaised = 0;
        presaleStarted = false;
    }

    /**
     * @dev extend presale period
     */
    function updateEndTimeStamp(uint256 _endTimeStamp) public onlyOwner {
        require(
            block.timestamp < _endTimeStamp,
            "Update endtime in the future"
        );
        endTimeStamp = _endTimeStamp;
    }

    /**
     * @dev get current token price for presale
     * @return uint256
     */
    function getCurrentTokenPrice() public view returns (uint256) {
        uint256 currentStep = soldAmount / (5 * 10 ** (6 + 18));
        uint256 tokenPrice = INITIAL_TOKEN_PRICE + currentStep * 20;
        return tokenPrice;
    }

    function setInitialTokenPrice(uint256 _initialTokenPrice) public onlyOwner {
        INITIAL_TOKEN_PRICE = _initialTokenPrice;
    }

    /**
     * @dev start the presale
     */
    function startPresale(uint256 _endTimeStamp) public onlyOwner {
        require(
            block.timestamp < _endTimeStamp,
            "Update endtime in the future"
        );
        require(
            token.balanceOf(address(this)) >= presaleAmount,
            "Token not charged fully"
        );
        require(presaleStarted == false, "Already started");
        startTimeStamp = block.timestamp;
        endTimeStamp = _endTimeStamp;
        presaleStarted = true;
    }
    /**
     * @dev calculate remaining time for presale
     * @return uint256
     */
    function calculateRemainingTime() public view returns (uint256) {
        require(block.timestamp < endTimeStamp, "Presale is ended");
        return (endTimeStamp - block.timestamp);
    }

    /**
     * @dev purchase mars token using USDC
     */
    function buyTokenWithUSDC(uint256 _usdcAmount) external {
        if (block.timestamp >= endTimeStamp) presaleStarted = false;
        require(block.timestamp > startTimeStamp, "Presale is not started");
        require(presaleStarted == true, "Presale is ended");
        require(0 < _usdcAmount, "Unavailable amount of token to buy");

        uint256 currentTokenPrice = getCurrentTokenPrice();
        uint256 _tokenAmount = (_usdcAmount * 10 ** 6) / currentTokenPrice;

        fundsRaised = fundsRaised + _usdcAmount;
        usdc.transferFrom(msg.sender, address(this), _usdcAmount);
        balanceOf[msg.sender] += _tokenAmount;
        soldAmount += _tokenAmount;
    }

    /**
     * @dev purchase mars token using ETH
     */
    function buyTokenWithETH() external payable {
        if (block.timestamp >= endTimeStamp) presaleStarted = false;
        require(block.timestamp > startTimeStamp, "Presale is not started");
        require(presaleStarted == true, "Presale is ended");
        require(msg.value > 0, "Unavailable amount of token to buy");

        address WETH = router.WETH();
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = MAINNET_USDC;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(0, path, address(this), block.timestamp + 15 minutes);
        uint256 usdAmount = amounts[1];

        uint256 currentTokenPrice = getCurrentTokenPrice();
        uint256 tokenAmount = (usdAmount * 10 ** 6) / currentTokenPrice;
        fundsRaised += usdAmount;
        balanceOf[msg.sender] += tokenAmount;
        soldAmount += tokenAmount;
    }

    /**
     * @dev get hardcap for presale
     * @return hardcap
     */
    function getHardcap() public view returns (uint256) {
        uint256 _hardcap = 0;
        for (uint256 i = 0; i < 20; i++) {
            _hardcap +=
                ((INITIAL_TOKEN_PRICE + i * 20) * (5 * 10 ** 6)) /
                (10 ** 6);
        }
        return _hardcap;
    }

    /**
     * @dev get total token amount for presale
     * @return
     */
    function sale() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    /**
     * @dev get mars balance for address
     * @return
     */
    function marsBalance(address _account) external view returns (uint256) {
        return token.balanceOf(_account);
    }

    /**
     * @dev get usdc balance for address
     * @return
     */
    function usdcBalance(address _account) external view returns (uint256) {
        return usdc.balanceOf(_account);
    }

    /**
     * @dev get current step index
     * @return uint256
     */
    function getCurrentStep() external view returns (uint256) {
        return soldAmount / (5 * 10 ** (6 + 18));
    }

    /**
     * @dev get purchase available mars token amount by ETH
     * @param _amount Eth amount
     * @return
     */
    function buyEstimationWithEth(
        uint256 _amount
    ) public view returns (uint256) {
        uint256 currentTokenPrice = getCurrentTokenPrice();
        address WETH = router.WETH();
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = MAINNET_USDC;
        uint256[] memory _usdcAmount = router.getAmountsOut(_amount, path);
        uint256 tokenAmount = (_usdcAmount[1] * 10 ** 6) / currentTokenPrice;
        return tokenAmount;
    }

    /**
     * @dev get purchase available mars token amount by USDC
     * @param _amount usdc amount
     * @return
     */
    function buyEstimationWithUsdc(
        uint256 _amount
    ) public view returns (uint256) {
        uint256 currentTokenPrice = getCurrentTokenPrice();
        return (_amount * 10 ** 6) / currentTokenPrice;
    }

    /**
     *@dev returns estimated amount of token and eth
     *@param _amount token amount
     */
    function estimateWithToken(
        uint256 _amount
    ) public view returns (uint256[] memory) {
        uint256 currentTokenPrice = getCurrentTokenPrice();
        uint256[] memory outAmounts = new uint256[](2);
        outAmounts[0] = (_amount * currentTokenPrice) / (10 ** 6);
        address WETH = router.WETH();
        address[] memory path = new address[](2);
        path[1] = WETH;
        path[0] = MAINNET_USDC;
        uint256[] memory _ethAmount = router.getAmountsOut(_amount, path);
        outAmounts[1] = _ethAmount[1];
        return outAmounts;
    }

    /**
     * @dev withdraw fundsRaised to dev wallet
     */
    function withdraw(address _to) public payable onlyOwner {
        usdc.transfer(_to, usdc.balanceOf(address(this)));
    }

    /**
     * @dev claim mars tokens after presale is finished
     */
    function claim() external {
        require(block.timestamp > endTimeStamp, "presale did not finished");
        require(balanceOf[msg.sender] > 0, "No balane to claim");
        uint256 amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        token.transfer(msg.sender, amount);
    }
    function transferOwnership(
        address newOwner
    ) public virtual override onlyOwner {
        super.transferOwnership(newOwner);
    }
}
