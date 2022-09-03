// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UselessToken is ERC20 {
  // (10**18) is to set it to 18 decimals
  uint constant _initialSupply = 100 * (10**18);

  constructor() ERC20("UselessToken", "USE") {
    _mint(msg.sender, _initialSupply);
  }

  function approveSpender(address spender, uint256 amount) public {
    super._approve(msg.sender, spender, amount);
  }
}