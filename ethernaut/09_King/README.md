# King

# Problem Statement
```
The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD

Such a fun game. Your goal is to break it.

When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.
```

# Solution
Note in the `receive` method:
```
king.transfer(msg.value);
king = msg.sender;
```
With the goal of disallowing the instance from reclaiming the level we have to not allow the `king = msg.sender` to happen.
We can only do this in this contract by making sure `king.transfer(msg.value)` never fully completes.
So all we have to do is to create a smart contract that has a `receive` method itself that always fails.

Check the current king
```
await contract._king()
```

Create the contract that will be used to replace the current king (`KingSolution.sol`).
After deployment run the `run` method of this newly deployed contract.
Next, verify your contract is the current king:
```
await contract._king()
```
You have now won because the instance can never retake kingship.

We've completed this lesson!


# Key Learnings
- If your smart contract makes a call to an external contract's functions make sure to handle failed transactions.
