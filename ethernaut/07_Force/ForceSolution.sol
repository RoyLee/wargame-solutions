// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceSolution {
  constructor() payable { }
  function run(address payable _forceAddress) external {
    selfdestruct(_forceAddress);
  }
}
