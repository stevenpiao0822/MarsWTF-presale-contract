# MarsWTF Presale Contract 

## Overview
The MarsWTF presale contract implements a token presale mechanism with specific features and security measures.

## Key Features

### Presale Parameters
- Fixed presale rate
- Minimum and maximum contribution limits
- Hardcap implementation
- Whitelist functionality
- Time-based presale phases

### Security Measures
1. Ownership controls
2. Emergency withdrawal functions
3. Anti-bot mechanisms
4. Contribution tracking
5. Whitelist verification

### Functions Breakdown

#### User Functions
- `participate()`: Allows users to participate in presale
- `claimTokens()`: Enables token claiming after presale
- `getUserContribution()`: Checks user's contribution amount

#### Admin Functions
- `setWhitelist()`: Manages whitelist entries
- `withdrawFunds()`: Allows fund withdrawal by owner
- `setPresaleStatus()`: Controls presale state
- `emergencyWithdraw()`: Emergency fund recovery

## Technical Specifications

### Dependencies
- OpenZeppelin Contracts
- Chainlink Price Feeds

### Networks
- BSC Mainnet
- BSC Testnet

## Usage Instructions

### For Users
1. Get whitelisted
2. Send BNB within contribution limits
3. Claim tokens after presale ends

### For Admins
1. Deploy contract
2. Set presale parameters
3. Manage whitelist
4. Control presale phases

## Security Considerations
- Rate manipulation protection
- Overflow checks
- Access control implementation
- Reentrancy guards

## Testing
Run tests using:

```bash
npx hardhat test
```

## Deployment
Deploy to BSC using:

```bash
npx hardhat run scripts/deploy.js --network bsc
```

## License
This project is licensed under the MIT License.
