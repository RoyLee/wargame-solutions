# Gatekeeper Two

# Problem Statement
```
This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

Things that might help:
Remember what We've learned from getting past the first gatekeeper - the first gate is the same.
The assembly keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. See here for more information. The extcodesize call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the yellow paper.
The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation (see here). The Coin Flip level is also a good place to start when approaching this challenge.
```

# Solution

## Part 1: Gate One

```
modifier gateOne() {
  require(msg.sender != tx.origin);
  _;
}
```
This one is easy. Just make sure the caller/sender to the `GatekeeperTwo` contract functions are made by a smart contract. This way the `msg.sender` will never be the `tx.origin`.

## Part 2: Gate Two
```
modifier gateTwo() {
  uint x;
  assembly { x := extcodesize(caller()) }
  require(x == 0);
  _;
}
```
What is `extcodesize(...)`? It runs the EXTCODESIZE opcode. This returns the storage size of the code on an address. The `require` ensures that it is of size 0. How can we make tthis possible? This can be solved if the code lives in the attacking smart contract's contstructor because a contract's constructor code is run first before storage utilized.

## Part 3: Gate Three
```
modifier gateThree(bytes8 _gateKey) {
  require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
  _;
}
```
We can solve this `require` using algebra:
```
uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1
```
Represented by `x`, `key`, and `y`:
```
x ^ key = y
```
Lets solve for `key`:
```
x ^ x ^ key = x ^ y
key = x^ y
Which can been seen as:
require( a ^ b == c);
```
An example of how this can be solved is:
```
1010 ^ 1111 == 0101
   a ^    b ==    c
          ^ we are solving for this because that is the _key
```
To get b you just do this:
```
1111 == 0101 ^ 1010
   b ==    c ^    a
```
Which is what we do here:
```
bool success,) =  _address.call.gas(100000)(abi.encodeWithSignature("enter(bytes8)", _key));
```

The contract solution is at `GatekeeperTwoSolution.sol`.

We've completed this lesson!

# Key Learnings
- Using `extcodesize` as a modifier `require` can be circumvented by a smart contract running calls in their `constructor`.
