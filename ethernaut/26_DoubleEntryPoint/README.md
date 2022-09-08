# Double Entry Point

# Problem Statement
```
This level features a CryptoVault with special functionality, the sweepToken function. This is a common function used to retrieve tokens stuck in a contract. The CryptoVault operates with an underlying token that can't be swept, as it is an important core logic component of the CryptoVault. Any other tokens can be swept.

The underlying token is an instance of the DET token implemented in the DoubleEntryPoint contract definition and the CryptoVault holds 100 units of it. Additionally the CryptoVault also holds 100 of LegacyToken LGT.

In this level you should figure out where the bug is in CryptoVault and protect it from being drained out of tokens.

The contract features a Forta contract where any user can register its own detection bot contract. Forta is a decentralized, community-based monitoring network to detect threats and anomalies on DeFi, NFT, governance, bridges and other Web3 systems as quickly as possible. Your job is to implement a detection bot and register it in the Forta contract. The bot's implementation will need to raise correct alerts to prevent potential attacks or bug exploits.

Things that might help:
- How does a double entry point work for a token contract?
```

# Solution
Check which contract `contract` represents:
```
contract.abi // one of the items in the result is cryptoVault
```
One of the available functions will be `cryptoVault` so that means `contract` is `DoubleEntryPoint` as `cryptoVault` is one of the `public` variables.<br>
After examining the code more, notice that `DoubleEntryPoint` and `LegacyToken` use `DelegateERC20`, and `DoubleEntryPoint`'s `delegatedFrom` points to `LegacyToken`.<br>
Also notice the `LegacyToken`'s `transfer` function calls `DoubleEntryPoint`'s `delegateTransfer` function therefore `DET` tokens.<br>
Lastly, notice `CryptoVault`'s `sweepToken` calls `LegacyToken`'s `transfer` function.
The security exploit call chain looks like this:
```
CryptoVault sweepToken -> LegacyToken transfer -> DoubleEntryPoint delegateTransfer -> receive DET tokens
```
Now that we know how the exploit works, we just need to use `Forta` to prevent this from happening. So how do we do this?<br>
`DoubleEntryPoint`'s `delegateTransfer` has a `fortaNotify` modifier. This modifier has a `revert` if an alert is raised. Perfect. So we need to code up a bot that will raise an alert when the explot happens.<br>
To be able to create this bot we need to to understand the `fortaNotify` modifier more. It lives as a modifier on the `delegateTransfer` method:
```
function delegateTransfer(address to, uint256 value, address origSender) public override onlyDelegateFrom fortaNotify returns (bool) { ...
```
If you now look at the `fortaNotify` function, you'll see it has access to the `msg.data` which has access to all of the `delegateTransfer` parameter values (`to`, `value`, `origSender`). The bot will need the `origSender` becacuse it is the `msg.sender` where it is called in the `LegacyTransfer`'s `transfer` method:
```
return delegate.delegateTransfer(to, value, msg.sender);
```
So all our bot needs to do is to get the `origSender`'s value and if it equals the `cryptoVault` address then we have `Forta` raise an alert and `revert` the transaction preventing the exploit from happening. With all of this information, lets start to create our contract.<br>
First, get the `cryptoVault` address:
```
await contract.cryptoVault()
```
Create the `DetectionBot` contract (`DetectionBot.sol`) and make sure to define the `CRYPTO_VAULT` value. Deploy it.<br>
Next, register the bot in the Forta contract:
```
const fortaAddress = await contract.forta()
const botAddress = "0xYOUR_BOT_ADDRESS";
const setBotData = web3.eth.abi.encodeFunctionCall({
  name: 'setDetectionBot',
  type: 'function',
  inputs: [{
    type: 'address',
    name: 'detectionBotAddress'
  }]
}, [botAddress])
await web3.eth.sendTransaction({
  to: fortaAddress,
  from: player,
  data: setBotData
})
```
We've completed this lesson!

# Key Learnings
- Detection bots can be useful to detect issues.
