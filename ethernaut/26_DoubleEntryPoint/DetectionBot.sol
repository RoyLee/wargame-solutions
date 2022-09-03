// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract DetectionBot is IDetectionBot {
  address constant CRYPTO_VAULT = 0x6a6F1826E12e9fb1998f5337B6dd5Ed1C7d36A90;
  function handleTransaction(address user, bytes calldata msgData) external {
    // msgData[4:] returns a new sliced array removing the function signature part
    // abi.decode's second parameter, (address, uint256, address), will know how to
    // decode the parameters because it'll know the types for them
    (,,address origSender) = abi.decode(msgData[4:], (address, uint256, address));
    if (origSender == CRYPTO_VAULT) {
      IForta(msg.sender).raiseAlert(user);
    }
  }
}
