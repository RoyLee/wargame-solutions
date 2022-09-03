# Reentrancy

# Problem Statement
```
The goal of this level is for you to steal all the funds from the contract.

Things that might help:
- Untrusted contracts can execute code where you least expect it.
- Fallback methods
- Throw/revert bubbling
- Sometimes the best way to attack a contract is with another contract.
- See the Help page above, section "Beyond the console"
```

# Solution

Note the re-entrancy exploit in the `withdraw` function:
```
(bool result,) = msg.sender.call{value:_amount}("");
```
If `msg.sender` is a smart contract, it will call the `receive` or `fallback` functions. In a malicious contract these functions can have custom code to recall the `Reentrace` contract's `withdraw` over and over again until the contract has no more ether.

So the rough plan is:

Create malicious smart contract (`ReentranceSolution.sol`) with the following functions:
- fallback: handle any `call` to it and will call the `Reentrance` `withdraw` function
- callWithdraw: calls reentrancy withdraw method with 0.0001 eth
- callDonate: to donate 0.0001 eth
- destroyMe: self destructs to your EOA

Use [Remix](https://remix.ethereum.org/) here because calling the functions of the `ReentranceSolution` contract would otherwise be tedious.

Deploy the new smart contract with 0.0002 (200000000000000 wei in Remix interface) ether

Notice the starting balances:
```
const solutionBalance = await web3.eth.getBalance("0xYOUR_DEPLOYED_SOLUTION_CONTRACT_ADDRESS")
web3.utils.fromWei(solutionBalance)
'0.0002'

const contractBalance = await web3.eth.getBalance(contract.address)
web3.utils.fromWei(contractBalance)
'0.001'
```

Call callDonate

Call callWithdraw

Notice the new balances:
```
const solutionBalance = await web3.eth.getBalance("0xYOUR_DEPLOYED_SOLUTION_CONTRACT_ADDRESS")
web3.utils.fromWei(solutionBalance)
'0.0012'

const contractBalance = await web3.eth.getBalance(contract.address)
web3.utils.fromWei(contractBalance)
'0'
```

Call destroyMe to get your ether plus the extra `Reentrance` ether back to your EOA

We've completed this lesson!

# Key Learnings
- Make sure to research the Checks Effects Interactions (CEI) pattern to prevent reentrancy attacks.
- Always assume that the receiver of the funds you are sending can be another contract, not just a regular externally owned account (EOA) address.
