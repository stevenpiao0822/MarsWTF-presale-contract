// SPDX-License-Identifier: MIT
/**
 *  Submitted for verification at basescan.org on 2024-03-20
 *
 * 888b      888       888      88888888b       c8888b           888        88  8888888888  8888888888
 *  8888    8888    88     88    88      88   88      88          88        88      88       88
 *  88 88  88 88   88       88   88      88   88                  88        88      88       88   88
 *  88  8888  88   88 88888 88   88 8888Y       Y8888b            88        88      88       8888888
 *  88        88   88       88   88     88            88          88   88   88      88       88   88
 *  88        88   88       88   88      88   88      88           88 8  8 88       88       88
 * 888        88   88       88   88      88     Y8888Y               88  88         88       88
 *
 *
 *                           Welcome to MarsWTF.
 *
 *  It's MarsWTF.  On Base.  And he's Based.  Like Super Based!
 *  So... MarsWTF!
 *  Excellent, huh?
 *
 *  MarsWTF is a cryptocurrency token on the, well, Base Chain.
 *  It is led by a super based incubation team armed with super based ambitions on bringing the project to the highest heights of success.
 *  It's focused on community building, stable growth through strategic promotional advancements and an open-ended ecosystem where each and every holder will have a voice in charting the course of the token.
 *
 *  As we've said, it's really super based!
 *
 *  We got the goods.  Let's go change the culture!
 *  https://marscoin.wtf
 **/
pragma solidity ^0.8.19;

library SafeMath {
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0xdead));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IUniswapRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}

interface IUniswapFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract MarsWTF is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address public _uniswapPair;
    uint256 public _walletMAX;

    function setWalletMax(uint8 percentage) public onlyOwner {
        _walletMAX = (totalSupply() * percentage) / 100;
    }

    function SetUniswapV3PairAddress(address uniswappairv3) public onlyOwner {
        _uniswapPair = uniswappairv3;
    }

    constructor() {
        _name = unicode"MarsWTF";
        _symbol = unicode"MarsWTF";
        _decimals = 18;

        _totalSupply = 10000000000 * 10 ** _decimals;

        _walletMAX = (_totalSupply * 2) / 100; //set walletMax as 2% of totalSupply

        address receiver = msg.sender;
        _balances[receiver] = _totalSupply;
        emit Transfer(address(0), receiver, _totalSupply);
    }
}
