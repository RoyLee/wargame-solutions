# GoodSamaritan

# Problem Statement
```
This instance represents a Good Samaritan that is wealthy and ready to donate some coins to anyone requesting it.

Would you be able to drain all the balance from his Wallet?

Things that might help:
- Solidity Custom Errors
```

# Solution
First get the `Coin` and `Wallet` addresses and store them in a variable for use later:
```
const coinAddress = await contract.coin()
const walletAddress = await contract.wallet()
```
Validate that the `Wallet` has coins:
```
const coinAbi = [
   {
      "constant":false,
      "inputs":[
         {
            "name":"",
            "type":"address"
         }
      ],
      "name":"balances",
      "outputs":[
         {
            "name":"",
            "type":"uint256"
         }
      ],
      "payable":false,
      "stateMutability":"public",
      "type":"function"
   }
]
const coinContract = new web3.eth.Contract(coinAbi, coinAddress)
await coinContract.methods.balances(walletAddress).call()
// returns '1000000'
```
Check the `Wallet` `owner`:
```
const walletAbi = [
   {
      "constant":false,
      "inputs":[],
      "name":"owner",
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
]
const walletContract = new web3.eth.Contract(walletAbi, walletAddress)
await walletContract.methods.owner().call()
// returns the instance address
```
Lets look at the 2 `external` functions that might allow us to drain all of the tokens. Calling `Coin`'s `transfer` method directly doesn't seem to do anything for us. Lets look at t `GoodSamaritan`'s `requestDonation` function.
Notice these lines in that function:
```
if (keccak256(abi.encodeWithSignature("NotEnoughBalance()")) == keccak256(err)) {
    // send the coins left
    wallet.transferRemainder(msg.sender);
...
```
Also note this is the `requestDonation`'s call flow:
```
GoodSamaritan requestDonation() -> Wallet donate10() ->  Coin transfer() -> Calling contract's notify()
```
Now notice this in the `Coin` contract's `transfer` function:
```
INotifyable(dest_).notify(amount_);
```
We have found our attack vector. We can implement a `notify` method in our attack contract to bubble up the same `NotEnoughBalance` error to trigger `GoodSamaritan` contract's `wallet.transferRemaining(msg.sender)`.<br>
You can see in the implementation in `GoodSamaritanSolution.sol`.

We've completed this lesson!

# Key Learnings
- Know how error bubbling works.
- Don't use `require` checks based on errors unless you know what you are doing.


