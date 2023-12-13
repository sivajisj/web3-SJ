## Foundry

# this is a crowd sourcing Application!
**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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


SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/WH4VCblvDcg5UVZD1e1hm3iSLuzKLey0
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/LXWF-CSl2dhCKXNmPMG2cBPuvCQt5CDx
ETHERSCAN_API_KEY=QAVQRX7DQI1I9X7B693RTBHE6ZPRWN9QFF
PRIVATE_KEY=d37675f3689f6e0407a28466ec0c4d9bc8bc3892418d1ea5c3f570dffef83efe