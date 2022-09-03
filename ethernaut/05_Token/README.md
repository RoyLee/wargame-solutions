# Token

# Problem Statement
```
The goal of this level is for you to hack the basic token contract below.
You are given 20 tokens to start with and you will beat the level if you somehow manage to get
your hands on any additional tokens. Preferably a very large amount of tokens.
Things that might help:
- What is an odometer?
```

# Solution
Looking at the `Token.sol` contract, you can see an underflow security hole is located in the
`transfer` contract.
this vulnerability will not exist.<br>
```
require(balances[msg.sender] - _value >= 0);
```
If we send a `_value` that underflows our balance, then we can get as many tokens as we want.<br>
```
Number(await contract.balanceOf(player))
```
Note that your EOA only has `20` tokens<br>

Because of this you can send to the `transfer` function with the value of `21` to bypass the `require` check.
This `21` will also trigger the overflow in this part of the code:
```
balances[msg.sender] -= _value;
```
Thus, will increase your EOA's balance of 2**256-1

Now run:
```
await contract.transfer('0x0000000000000000000000000000000000000000', 21)
```

We've completed this lesson!

# Key Learnings
- Make sure to use Solidity 0.8 as [any overflow or underflow will result in a revert](https://docs.soliditylang.org/en/v0.8.5/080-breaking-changes.html?highlight=underflow#silent-changes-of-the-semantics).
- For pre-0.8 contracts, [OpenZeppelin SafeMath](https://docs.openzeppelin.com/contracts/4.x/api/utils#SafeMath) can be used.
