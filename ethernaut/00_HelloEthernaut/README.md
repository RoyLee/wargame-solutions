# Hello Ethernaut

# Problem Statement
```
This level walks you through the very basics of how to play the game.

1. Set up MetaMask
If you don't have it already, install the MetaMask browser extension (in Chrome, Firefox, Brave or Opera on your desktop machine). Set up the extension's wallet and use the network selector to point to the 'Rinkeby test network' in the top left of the extension's interface.

2. Open the browser's console
Open your browser's console: Tools > Developer Tools.
You should see a few messages from the game. One of them should state your player's address. This will be important during the game! You can always see your player address by entering the following command:
player
Keep an eye out for warnings and errors, since they could provide important information during gameplay.

3. Use the console helpers
You can also see your current ether balance by typing:
getBalance(player)
NOTE: Expand the promise to see the actual value, even if it reads "pending". If you're using Chrome v62, you can use await getBalance(player) for a cleaner console experience.
Great! To see what other utility functions you have in the console type:
help()
These will be super handy during gameplay.

4. The ethernaut contract
Enter the following command in the console:
ethernaut
This is the game's main smart contract. You don't need to interact with it directly through the console (as this app will do that for you) but you can if you want to. Playing around with this object now is a great way to learn how to interact with the other smart contracts of the game.
Go ahead and expand the ethernaut object to see what's inside.

5. Interact with the ABI
ethernaut is a TruffleContract object that wraps the Ethernaut.sol contract that has been deployed to the blockchain.
Among other things, the contract's ABI exposes all of Ethernaut.sol's public methods, such as owner. Type the following command for example:
ethernaut.owner() or await ethernaut.owner() if you're using Chrome v62.
You can see who the owner of the ethernaut contract is.

6. Get test ether
To play the game, you will need test ether. The easiest way to get some testnet ether is via this, this or this faucet. Those are Rinkeby faucets where the game was originally deployed. If you're on a different network be sure to find your test money needed to run the game.
Once you see some ether in your balance, move on to the next step.

7. Getting a level instance
When playing a level, you don't interact directly with the ethernaut contract. Instead, you ask it to generate a level instance for you. To do so, click the blue button at the bottom of the page. Go do it now and come back!
You should be prompted by MetaMask to authorize the transaction. Do so, and you should see some messages in the console. Note that this is deploying a new contract in the blockchain and might take a few seconds, so please be patient when requesting new level instances!

8. Inspecting the contract
Just as you did with the ethernaut contract, you can inspect this contract's ABI through the console using the contract variable.

9. Interact with the contract to complete the level
Look into the level's info method contract.info() or await contract.info() if you're using Chrome v62. You should have all you need to complete the level within the contract. When you know you have completed the level, submit the contract using the submit button at the bottom of the page. This sends your instance back to the ethernaut, which will determine if you have completed it.

Tip: don't forget that you can always look in the contract's ABI!
```

# Solution

Firstly, run this command in the developer console to get the functions that are available for you to call:
```
contract.abi
```
You will notice there is an `info1` method. Lets try that first and then follow the sequence of commands:
```
await contract.info1()
// returns 'Try info2(), but with "hello" as a parameter.'
await contract.info2("hello")
// returns 'The property infoNum holds the number of the next info method to call.'
Number(await contract.infoNum())
// returns 42
await contract.info42()
// returns'theMethodName is the name of the next method.'
await contract.theMethodName()
// returns'The method name is method7123949.'
await contract.method7123949()
// returns'If you know the password, submit it to authenticate().'
contract.abi
// returnsThis will show a password attribute
await contract.password()
// returns'ethernaut0'
await contract.authenticate("ethernaut0")
await contract.getCleared()
```

We've completed this lesson!

# Key Learnings
- Always search throughly and look through all the objects and methods (like `contract.abi`) to find answers.
