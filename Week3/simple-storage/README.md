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
## Deployment Info (Week 3)

The `SimpleStorage` contract has been successfully compiled and deployed to the Ethereum Sepolia Testnet using the Foundry toolchain.

- **Contract Address:** `0x0e7005cC7C319893bf3C8cB7561667C320f33590`
- **Deployment Tx Hash:** `0xc486e55702c33b09b621271ac1a07d2dd29353046c209b9453f3bda8c7efcdf6`
- **Network:** Sepolia Testnet
- **Tools Used:** Forge, Cast

### Interaction Example
To call the view function from the CLI:
\`\`\`bash
cast call 0x0e7005cC7C319893bf3C8cB7561667C320f33590 "getMessage()(string)" --rpc-url <YOUR_SEPOLIA_RPC_URL>
\`\`\`