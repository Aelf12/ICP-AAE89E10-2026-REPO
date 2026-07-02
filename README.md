## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
# Decentralized Staking Smart Contract

This project was developed and deployed as part of the InternCareerPath program (Intern ID: ICP-AAE89E10-2026). It features a robust, decentralized staking mechanism allowing users to lock tokens and earn yield.

## Deployment Details
The smart contract has been successfully compiled, tested, and broadcasted to the live test network.

* **Network:** Ethereum Sepolia Testnet (Chain ID: 11155111)
* **Framework:** Foundry / Solidity `^0.8.33`
* **Staking Contract Address:** `0xAB9F64Fff7CC373D77C1E52C4BC75190DDbcBfB9`
* **Status:** Verified on Etherscan

## Security & Architecture
* **Deployment Security:** Deployed using local environment variables and Foundry's encrypted keystore infrastructure to ensure strict private key security.
* **Testing:** Contract state and logic were heavily simulated prior to deployment using Forge scripts and local EVM environments.

## Local Setup & Verification
To interact with the deployed contract locally, ensure you have Foundry installed. 

1. Clone the repository.
2. Install dependencies:
   ```bash
   forge install
3. Build the project to verify compilation
   ```bash
   forge build
