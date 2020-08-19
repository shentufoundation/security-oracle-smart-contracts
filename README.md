# CertiK Security Oracle Smart Contracts

Decentralized real-time auditing for your smart contracts.

## Usage

1. Copy the [contracts](./contracts) directory into `contracts/certik` in your project folder.

2. Follow the minimal example to integrate:

```
import "./certik/CertiKSecurityOracle.sol";

contract MinimalExample {
  function secureCall() public {
    address securityOracleAddress = 0x152E88111e7C8f51fbdBbF1723B330a330117CAf;

    address targetAddress = 0xfa308d59067470487C38Eaf4d586EA21F1b0032b;
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
