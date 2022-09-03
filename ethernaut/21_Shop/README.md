# Shop

# Problem Statement
```
Сan you get the item from the shop for less than the price asked?
Things that might help:
- Shop expects to be used from a Buyer
- Understanding restrictions of view functions
```

# Solution
Notice the `_buyer.price()` is called twice here. Once to check and another to set:
```
function buy() public {
  Buyer _buyer = Buyer(msg.sender);

  if (_buyer.price() >= price && !isSold) {
    isSold = true;
    price = _buyer.price();
  }
}
```
Since we know what the `Buyer` interface is and we know the buyer is `msg.sender` we can have the `_buyer.price()` method return different results. Usually the `view` type in the `price()` method interface should signal that the data cannot be changed but this can be circumvented in two ways:
1) Using assembly code
2) Using an interface.
We'll implement the solution with an interface in the `ShopSolution.sol` file.<br>

We've completed this lesson!

# Key Learnings
- Be cautious anytime a contract calls a contract that the `msg.sender` can specify.
