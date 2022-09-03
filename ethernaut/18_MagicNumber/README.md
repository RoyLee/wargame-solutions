# Magic Number

# Problem Statement
```
To solve this level, you only need to provide the Ethernaut with a Solver, a contract that responds to whatIsTheMeaningOfLife() with the right number.

Easy right? Well... there's a catch.

The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 opcodes at most.

Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.

Good luck!
```

# Solution
We need to create a contract and that contract has to be small at only 10 opcodes. We'll need to generate the contract via raw EVM bytecode.

## Step 1: Determine Necessary Opcodes
Our goal is to create a contract that looks like the following using raw EVM bytecode:
```
contract MagicNumSolution {
  function whatIsTheMeaningOfLife() pure external returns(uint) {
    return 42;
  }
}
```
Generate the function that will will return the value 42:
```
PUSH1 42 // PUSH1: opcode to place 1 byte item on stack. In this case 42.
PUSH1 0  // location 0
MSTORE   // MSTORE: opcode to store in memory that takes 2 parameters
         // parameter 1: offset: which is the pushed location 0
         // parameter 2: value: which is the pushed value 42
PUSH1 32 // this is the byte size of the returning value which is the
         // enture slot we are storing right now so 32 bytes
PUSH1 0  // this is the offset which is 0 because our value is stored in
         // location 0 from our previous MSTORE
RETURN   // RETURN: opcode to halt execution and return
         // parameter 1: offset of individual slot: start at 0
         // parameter 2: length: how many bytes are used in the slot which
         //                      is 32 bytes
```
Now that we have our opcodes we need to covert the opcode and the decimal values to hexidecimal:
```
PUSH1 42 -> 0x60 0x2a -> 602a // PUSH1 == 0x60 and we can remove the 0x in the beginning.
PUSH1 0  -> 6000
MSTORE   -> 0x52 -> 52
PUSH1 32 -> 6020
PUSH1 0  -> 6000
RETURN   -> 0xf3 -> f3
```
The combined value is: 602a60005260206000f3
Generate the runtime code that will run our code:
```
PUSH10 602A60005260206000f3 // PUSH10 because we are pushing a 10 byte item
PUSH1 0 // location 0
MSTORE
PUSH1 10
PUSH 22 // 22 because the slot is 32 bytes and we've used 10
RETURN
```
Convert opcodes to hexidecimal
```
PUSH10 602a60005260206000f3 -> 0x69 602a60005260206000f3 -> 69602a60005260206000f3
PUSH1 0 -> 6900
MSTORE -> 52
PUSH1 10 -> 0x60 0x0a -> 600a
PUSH1 22 -> 0x60 0x16 -> 6016
RETURN -> f3
```
The combined value is: 69602a60005260206000f3600052600a6016f3<br>
Next, go back to the chrome console and run the following to deploy the new contract:
```
const byteCode = `69602a60005260206000f3600052600a6016f3`;
const tx = await web3.eth.sendTransaction({
  from: player,
  data: byteCode,
})
```
Go to the etherscan page for this contract and click on the contract button to see something like this: 0x602a60005260206000f3 . If you count, you'll see its 20 characters and each opcode is 2 characters (1 byte) so it is 10 opcodes in total.<br>
Check if my new contract returns 42. Can call either of these:
```
parseInt(await web3.eth.call({ to: tx.contractAddress, data: '0x' }))
parseInt(await web3.eth.call({ to: tx.contractAddress, data: '0x602a60005260206000f3' }))
```
Run the `MagicNumSolution`'s `setSolver` to solve the lesson:
```
await contract.setSolver(tx.contractAddress)
```
We've completed this lesson!

# Key Learnings
- There are multiple ways to deploy a smart contract to the Ethereum blockchain.
