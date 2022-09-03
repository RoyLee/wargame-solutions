// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
  function enter(bytes8 _gateKey) external;
}

contract GatekeeperOneSolution {
  IGatekeeperOne target;

  event FailedRequest(bytes reason, uint gas);

  constructor(address _address) {
    target = IGatekeeperOne(_address);
  }

  function determineGateTwoGas() external {
    uint gasSearch = 100000;
    for(uint i = 0; i <= 8191; i++) {
      gasSearch += 1;
      // doesn't matter what _gateKey we use here
      try target.enter{gas:gasSearch}('0x01') {}
      catch (bytes memory reason) {
        // "0x" is a non reason which is used by GateTwo
        emit FailedRequest(reason, gasSearch);
      }
    }
  }

  // This was found to be the correct key using determineGateTwoGas()
  uint gas = 106737;

  function attemptEnter() external {
    // Replace HHHH here with the last 4 of your deployer address
    bytes8 key = 0x100000000000HHHH;
    target.enter{gas:gas}(key);
  }
}