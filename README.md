# CertiK Security Oracle Smart Contracts

Decentralized real-time auditing for your smart contracts.

## Usage

1. Copy the [contracts](./contracts) directory into `contracts/certik` in your project folder.

2. Follow the minimal example to integrate:

```
import "./certik/CertiKSecurityOracle.sol";

contract MinimalExample {
  function secureCall() public {
    address securityOracleAddress = address(0x97f24e544c19280ec319f29de751e95b1d8c05e2#code);

    address targetAddress = address(0xfa308d59067470487C38Eaf4d586EA21F1b0032b);
    string functionSignature = "getPrice(string)";

    uint8 score = CertiKSecurityOracle(securityOracleAddress).getSecurityScore(
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
