# Donation

# Problem Statement
### Description
```
Donate to Bob Smith!
Bob Smith is a name you can trust! He stands for your values! He cares about what you care about!
The other candidates only cares about their own constituents. Boo!

Support Bob Smith and make a difference today!

Donate Ether
Chose your donation! Even a donation as small as 0.001 Ether helps the cause!

We have already collected...
0.05 ETH!
```

# Solution
Lets first look at all the `public`/`external` methods we can call. Notice the `Donation` contract's `withdrawDonationsFromTheSuckersWhoFellForIt()` has the following:
```
msg.sender.transfer(funds);
```
Bingo. This will send the entirety of the available ethers stored in the contract to the caller of the function. So using your favorite web3/ethers library call the method:
```
await contract.withdrawDonationsFromTheSuckersWhoFellForIt();
```

We've completed this lesson!

# Key Learnings
- Always poke around in a contract to see the available holes available to test. These are the `public`/`external` functions.
