# Denial

# Problem Statement
```
This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, and the transaction is of 1M gas or less) you will win this level.
```

# Solution
Note that any external call can change the partner:
```
function setWithdrawPartner(address _partner) public {
    partner = _partner;
}
```
Note these lines in the `Denial` `withdraw` contract:
```
partner.call{value:amountToSend}("");
owner.transfer(amountToSend);
```
With the goal in mind of denying the owner from withdrawing funds when they call `withdraw()`,
a possible way to do this is to change the `partner` to a smart contract of your making and
in the `receive`/`fallback` method use all of the gas when the `partner.call` is called so
it never reaches the `owner.transfer` line.<br>
Using all the gas instead of `revert` or `require` because these will revert the `parter.call`
but the rest of the `withdraw` function's code will still run. Consuming all the gas will for
sure not allow the `owner.transfer` call to be run.

See the `DenialSolution.sol` file for the smart contract that will be the new `partner`<br>

We've completed this lesson!

# Key Learnings
- Be very careful when dealing with external smart contract `receive`/`fallback` calls.
- If you still need to use the `call` function, make sure to specify a specific gas to prevent this attack.
- Make sure to follow the [checks-effects-interactions](http://solidity.readthedocs.io/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern)
pattern when making external smart contract calls.
