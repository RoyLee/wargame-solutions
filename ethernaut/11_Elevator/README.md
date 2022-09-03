# Elevator

# Problem Statement
```
This elevator won't let you reach the top of your building. Right?
Things that might help:
- Sometimes solidity is not good at keeping promises.
- This Elevator expects to be used from a Building.
```

# Solution
Check the current `Elevator` state:
```
await contract.top() // false
Number(await contract.floor()) // 0
```
Create an `ElevatorSolution` contract that adheres to the `isFloor` interface and can return different results. This will be called by the `Elevator` `goTo` function. You can see this contract at `ElevatorSolution.sol`.

Next, call the `ElevatorSolution`'s `callElevator` function which will call the `Elevator` `goTo` function which will also call back to that `ElevatorSolution` `isFloor` function:
```
const data = web3.eth.abi.encodeFunctionSignature("callElevator()")
await web3.eth.sendTransaction({ to: "0xYOUR_NEW_DEPLOYED_CONTRACT_ADDRESS", from: player, data: data })
```
Now, see that the `Elevator` state has changed:
```
await contract.top() // true
Number(await contract.floor()) // 1
```

We've completed this lesson!

# Key Learnings
- Because the `isFloor` function does not have `view` or `pure` modifiers, then state changes can change resulting in different function return results.
- Though even with the `view` or `pure` modifiers, a function can be implemented such that it returns differeent results. For example, the function can base the return result on `gasleft()`.
- Take care when working with contracts that call functions from another contract's interface. additional layers of abstraction can introduce security issues.
