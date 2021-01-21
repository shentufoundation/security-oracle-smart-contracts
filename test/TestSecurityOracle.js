const SecurityOracle = artifacts.require("CertiKSecurityOracle");

async function tryCatch(promise, message) {
  const PREFIX = "VM Exception while processing transaction: ";

  try {
    await promise;
    throw null;
  } catch (error) {
    assert(error, "Expected an error but did not get one");
    assert(
      error.message.indexOf(PREFIX + message) !== -1,
      "Expected an error containing '" +
        PREFIX +
        message +
        "' but got '" +
        error.message +
        "' instead"
    );
  }
}

contract("SecurityOracle", () => {
  let so;

  before(async function () {
    so = await SecurityOracle.new();
  });

  it("should proceed for contract address only call", async function () {
    await so.getSecurityScore("0xc06Ca4a7DaEB0D1601Bb47297d9Fd170f231D872");
  });

  it("should revert if contract address is 0", async function () {
    await tryCatch(
      so.getSecurityScore("0x0000000000000000000000000000000000000000"),
      "revert"
    );
  });

  it("should proceed for contract address and non 0 function signature call", async function () {
    await so.getSecurityScoreBytes4(
      "0xc06Ca4a7DaEB0D1601Bb47297d9Fd170f231D872",
      [0, 0, 0, 1]
    );
  });

  it("should revert if function signature is 0", async function () {
    await tryCatch(
      so.getSecurityScoreBytes4("0xc06Ca4a7DaEB0D1601Bb47297d9Fd170f231D872", [
        0,
        0,
        0,
        0,
      ]),
      "revert"
    );
  });
});
