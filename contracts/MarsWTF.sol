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