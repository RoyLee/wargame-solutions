# Privacy

# Problem Statement
```
The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:
- Understanding how storage works
- Understanding how parameter parsing works
- Understanding how casting works

Tips:
Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.
```

# Solution

## Part 1: Which storage slots are being used?
Looking at the `Privacy.sol` code, the solution is to call the `unlock` function with the correct `_key` which is stored in the `data[2]` variable in the contract. Since nothing on the blockchain is private, we are able to use `web3` library's `getStorageAt` to get the value. Lets first understand which slot the value of `data[2]` is located by looking at the `Privacy` contract's variables with the knowledge that each slot has a size of 32 bytes:
```
bool public locked = true; // 1 bytes so stored in slot 0
uint256 public ID = block.timestamp; // 256 bits equates to 32 bytes so too large to be stored in slot 0 so occupies the entirety of slot 1
uint8 private flattening = 10; // 1 byte so stored in slot 2
uint8 private denomination = 255; // 1 byte so stored in slot 2 as well
uint16 private awkwardness = uint16(now); // 2 bytes so stored in slot 2 as well
bytes32[3] private data; // every array element is 32 bytes so this array takes up slots 3,4,5. We are looking for data[2] so that is slot 5
```
Great. Now we know the key is located in slot 5 so lets get it:
```
const keyHex = await web3.eth.getStorageAt(contract.address, 5, console.log)
// results in something like this: 0xZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
```
A couple of things:
- the `unlock` method takes a `bytes16` type for the `_key`
- `bytes` are stored in big [endian format](https://en.wikipedia.org/wiki/Endianness) so its left to right
- the value stored at slot 5 is hexidecimal and is 32 bytes so it is 64 characters (excluding the prefix `0x`)
- 2 hex = 1 bytes
So this means all we need to make it `bytes16` is to cut the current bytes 64 in half + 2 for the `0x` so 34 total from left to right as it is big endian:
```
const keyBytes16 = keyHex.slice(0,34)
```
We've found the key! Now just run `unlock`:
```
await contract.unlock(keyBytes16)
```

We've completed this lesson!

# Key Learnings
- Nothing on the ethereum blockchain is truly hidden.
