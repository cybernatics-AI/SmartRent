# SmartRent: Decentralized Property Rental Smart Contract

## Table of Contents
1. Introduction
2. Features
3. Technologies Used
4. Getting Started
   Prerequisites
   Installation
5. Contract Overview
6. Usage
7. Function Details
8. Security Considerations
9. Testing
10. Deployment
11. Contributing
12. License
13. Contact
## Introduction

SmartRent is a decentralized application (dApp) built on the Stacks blockchain, designed to revolutionize the property rental market. It provides a trustless platform for property owners and tenants to engage in rental agreements, manage payments, and handle disputes without intermediaries.

## Features

- Decentralized property listing and rental
- Secure payment handling with escrow
- Automated lease management
- User rating system for both tenants and property owners
- Property availability toggling
- Lease extension capabilities
- Platform fee management

## Technologies Used

- Clarity: The smart contract programming language for Stacks
- Stacks Blockchain: The underlying blockchain technology
- Clarinet: Development and testing framework for Clarity smart contracts

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- [Stacks Wallet](https://www.hiro.so/wallet)

### Installation

1. Clone the repository:
2. Navigate to the project directory.
3. Install dependencies (if any):
   ```
   npm install
   ```

## Contract Overview

The SmartRent contract consists of several key components:

1. Property Management: Listing, updating, and managing property details
2. Rental Process: Handling the rental transaction and lease management
3. User Ratings: Allowing users to rate each other after transactions
4. Admin Functions: Contract initialization and fee management

## Usage

### For Property Owners

1. List a property using the `add-property` function
2. Update property details with `update-property`
3. Toggle property availability using `toggle-property-availability`
4. End a lease with `end-lease` when the term is complete

### For Tenants

1. Rent a property using the `rent-property` function
2. Extend a lease with `extend-lease` if needed
3. Rate the property/owner after the lease ends using `rate-property`

## Function Details

- `initialize`: Set up the contract with initial parameters
- `add-property`: List a new property for rent
- `update-property`: Modify existing property details
- `toggle-property-availability`: Change the availability status of a property
- `rent-property`: Initiate a rental agreement for a property
- `end-lease`: Terminate a lease agreement
- `extend-lease`: Lengthen the duration of an existing lease
- `rate-property`: Provide a rating for a property after a rental period
- `rate-user`: Rate another user (tenant or owner) after a transaction
- `verify-user`: Admin function to verify a user's account
- `update-platform-fee`: Admin function to adjust the platform fee percentage
- `update-escrow-address`: Admin function to change the escrow address

## Security Considerations

- The contract includes various checks and balances to ensure secure operations
- Input validation is performed on all public functions
- Only the contract owner can perform certain administrative actions
- Funds are held in escrow to protect both parties in a transaction

## Testing

To run the test suite:

```
clarinet test
```

Ensure all tests pass before deploying or making changes to the contract.

## Deployment

1. Build the contract:
   ```
   clarinet build
   ```
2. Deploy to testnet or mainnet using the Stacks CLI or a wallet interface.

## Contributing

We welcome contributions to the SmartRent project. Please follow these steps:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your fork
5. Submit a pull request


## Contact

For questions or support, please open an issue in the GitHub repository or contact the maintainers at dev.triggerfish@gmail.com