// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.12;

library AccessFlags {
  uint256 public constant EMERGENCY_ADMIN = 1 << 0;

  // Following constants are used by descendant(s)
  uint256 public constant LENDING_POOL = 1 << 1;
  uint256 public constant LENDING_POOL_CONFIGURATOR = 1 << 2;
  uint256 public constant POOL_ADMIN = 1 << 3;
  uint256 public constant LENDING_POOL_COLLATERAL_MANAGER = 1 << 4;
  uint256 public constant PRICE_ORACLE = 1 << 5;
  uint256 public constant LENDING_RATE_ORACLE = 1 << 6;
  //  uint256 public constant REWARD_ADMIN = 1<<7;

  uint256 public constant REWARD_MINT = 1 << 10;
  uint256 public constant REWARD_BURN = 1 << 11;
  uint256 public constant REWARD_SUSPEND_ADDRESS = 1 << 12;
}