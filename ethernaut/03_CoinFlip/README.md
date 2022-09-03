# CoinFlip

# Problem Statement
```
This is a coin flipping game where you need to build up your winning streak by guessing the outcome
of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct
outcome 10 times in a row.
Things that might help
- See the Help page above, section "Beyond the console"
```

# Solution
Since we have the Coinflip source code we know how the coinflip calculation is generated. All we need
to do is to replicate the code in our attack contract, and send in the correct guess each time.

Get the available functions to call:
```
contract.abi
```
Get the current consecutive wins:
```
Number(await contract.consecutiveWins())
```
Generate the code to replicate the coin flip logic in a new "attack" contract. This is implemeted in the
`CoinFlipSolution.sol` file.<br>
Deploy that contract.<br>
Run the `flip` method 10 times.<br>
You should now see 10 here:
```
Number(await contract.consecutiveWins())
```

We've completed this lesson!

# Key Learnings
- Be careful when implementing "randomness". The calculation can be discovered and hacked by attackers.
