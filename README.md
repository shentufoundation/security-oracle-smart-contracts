# CertiK Security Oracle Smart Contracts

Decentralized real-time auditing for your smart contracts.

## Usage

Follow the following example to integrate with Security Oracle smart contract on Binance Smart Chain, the smart contract address is [0xE7F15597B7594E1516952001f57d022bA799b479](https://bscscan.com/address/0xE7F15597B7594E1516952001f57d022bA799b479).

Currently we don't have Ethereum version yet due to the high gas fee. If you want to have it please [submit an issue](https://github.com/certikfoundation/security-oracle-smart-contracts/issues/new) in current repo to let us know.

For complicated integrations we can check [DeFiExample](contracts/DeFiExample.sol) for a reference.

```
interface SecurityOracle {
  function getSecurityScore(
    address contractAddress,
    string calldata functionSignature
  ) external view returns (uint8);
}

contract MinimalExample {
  function secureCall() public {
    address securityOracleAddress = address(0xE7F15597B7594E1516952001f57d022bA799b479);

    address targetAddress = address(0x1234567);
    string functionSignature = "getPrice(string)";

    uint8 score = SecurityOracle(securityOracleAddress).getSecurityScore(
      targetAddress,
      functionSignature
    );

    // build your own check
    require(score > 100, "revert due to high security risk");

    ...proceed to call targetAddress/function
  }
}
```

## Development

### Prerequisite

```
yarn install
```

### Interactive Debugging

```
yarn deploy

yarn console
```

### Test

```
yarn test
```

## Production

```
TRUFFLE_PRIVATE_KEY="<wallet-key>" TRUFFLE_RPC="<rpc-endpoint>" yarn deploy --network production
```

Note that truffle commands like `truffle migrate`/`truffle deploy`/etc would also require the environment variables.
