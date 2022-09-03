# Force

# Problem Statement
```
Some contracts will simply not take your money ¯\_(ツ)_/¯
The goal of this level is to make the balance of the contract greater than zero.
Things that might help:
- Fallback methods
- Sometimes the best way to attack a contract is with another contract.
- See the Help page above, section "Beyond the console"
```

# Solution
The way to solve this is to know:
- One forceful way to give ether to another contract is to have a smart contract
 run `selfdestruct` and send the ether to a destination address

So just create a contract with a `selfdestruct` method directed towards the `Force` instance address.
Also make sure to send ether to this new contract.
Run the method with the `selfdestruct` method and it will end up in the `Force` smart contract

We've completed this lesson!

# Key Learnings
- For a smart contract to be able to receive ether on construction / deploy it has to have `payable`.
- Because any contract can receive ether via an external `selfdestruct` it is bad practice to use 
this statement in contract code: `address(this).balance == 0`.
