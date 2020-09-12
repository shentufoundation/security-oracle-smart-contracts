# CertiK Security Oracle Smart Contracts

Decentralized real-time auditing for your smart contracts.

## Usage

Follow the following example to integrate. For complicated integrations we can check [DeFiExample](contracts/DeFiexample.sol) for a reference.

```
interface SecurityOracle {
  function getSecurityScore(
    address contractAddress,
    string calldata functionSignature
  ) external view returns (uint8);
}

contract MinimalExample {
  function secureCall() public {
    address securityOracleAddress = address(0x97f24e544c19280ec319f29de751e95b1d8c05e2#code);

    address targetAddress = address(0xfa308d59067470487C38Eaf4d586EA21F1b0032b);
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
