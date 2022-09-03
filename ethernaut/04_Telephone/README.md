# Telephone

# Problem Statement
```
Claim ownership of the contract below to complete this level.
Things that might help
- See the Help page above, section "Beyond the console"
```

# Solution
Note that in the `changeOwner` function, the check is:<br>
```
if (tx.origin != msg.sender) {...}
```
The key piece of knowledge is knowing the definition of `tx.origin`. `tx.origin` is the address of the original transactions. In the case of creating a smart contract, the smart contract will have a `tx.origin` of the externally owned account (EOA), whereas an EOA always has a `tx.origin` of its own address.
With this knowledge, all we have to do to gain ownership of the contract is to create a smart contract that has the ability to call the `Telephone` contract's `changeOwner` method.
You can see the implementation at `TelephoneSolution.sol`.

We've completed this lesson!

# Take Aways
- Never use `tx.origin` as an authorization check. Use `msg.sender`.
