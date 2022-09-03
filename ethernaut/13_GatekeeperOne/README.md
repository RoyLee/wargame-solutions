# Gatekeeper One

# Problem Statement
```
Make it past the gatekeeper and register as an entrant to pass this level.

Things that might help:
Remember what We've learned from the Telephone and Token levels.
You can learn more about the special function gasleft(), in Solidity's documentation (see here and here).
```

# Solution

There are 3 gates enforced through `modifier`s in this problem.

## Part 1: Gate One

```
modifier gateOne() {
  require(msg.sender != tx.origin);
  _;
}
```
This one is easy. Just make sure the caller/sender to the `GatekeeperOne` contract functions are made by a smart contract. This way the `msg.sender` will never be the `tx.origin`.

## Part 2: Gate Two
```
modifier gateTwo() {
  require(gasleft().mod(8191) == 0);
  _;
}
```
Brute Force using a for loop to iterate though the 8191 possibilities to figure out the correct gas to send to pass this gate.<br>
Because `GatekeeperOne`'s `gateOne` and `gateTwo` do not provide reasons in their `require` statements and `gateThree` does proide reasons, we can use a `try...catch` block to emit the gas info when a reason is given. This will only happen when the code reaches `gateThree` and fails any of the `require` statements. You can see the implementation in the `GatekeeperOneSolution` `determineGateTwoGas` function.<br>
After this is run using `Remix` preferrably because their event logging is easy to read.

## Part 3: Gate Three
```
modifier gateThree(bytes8 _gateKey) {
    require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
    require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
    require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
  _;
}
```
Figure out how many bytes are in a hex:
```
8 bytes = ? hex
8 bytes = 8 * 8 bits = 64 bits
64 bits = ? hex
1 hex = ? bits
1 hex has 16 possibilities
? bits has 16 possibilities
2**0 = 1
2**1 = 2
2**2 = 4
2**3 = 16
4 bits = 1 hex
8 bits = 2 hex
8 bits = 1 byte = 2 hex
8 bytes = 8 bytes * 8 bits = 64 bits = 64 bits / 4 = 16 hex

1 hex = 32 bits
8 bytes = 16 hex
1 hex = 4 bytes
the input parameter _gateKey is 8 bytes so it will need to look like this: 0xXXXXXXXXXXXXXXXX
```
### Require 1: require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)));
```
don't pay too much attention to the uint just note here we are cutting in half the right side
0xXXXXXXXX == 0xXXXX
to make them equal we need to set the first half to be all 0's using a bit mask
0xXXXXXXXX -> 0x0000XXXX
now this will pass:
0x0000XXXX == 0xXXXX
```
### Require 2: require(uint32(uint64(_gateKey)) != uint64(_gateKey));
```
from part 1:
0x00000000XXXXXXXX
since we are comparing against a smaller object on the left side compared to the right
we can put additional data in the larger side to make things not equal
we can modify any of the 0's so lets just do the first bit and make it a 1
0x00000000XXXXXXXX -> 0x10000000XXXXXXXX
now this will pass:
0xXXXXXXXX != 0x10000000XXXXXXXX
```
### Require 3: require(uint32(uint64(_gateKey)) == uint16(tx.origin));
```
from part 2:
0x10000000XXXXXXXX
we just need to get our deployed attack smart contract's EOA address
uint16(tx.origin) means a uint with 16 bytes
we know that 1 hex = 4 bytes
since the uint is 16 bytes that means we need the tx.origin of 4 hex slots as shown here as H:
0x10000000XXXXHHHH
you can just copy and paste the last 4 of your deployer address
```

We've completed this lesson!

# Key Learnings
- Try not to use `gasleft()` in `require` statements because they can be easily brute forced.

