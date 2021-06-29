// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.12;

import {IERC20Details} from '../dependencies/openzeppelin/contracts/IERC20Details.sol';

import {AccessFlags} from '../access/AccessFlags.sol';
import {IMarketAccessController} from '../access/interfaces/IMarketAccessController.sol';

import {RewardedTokenLocker} from './locker/RewardedTokenLocker.sol';
import {VersionedInitializable} from '../tools/upgradeability/VersionedInitializable.sol';

import 'hardhat/console.sol';

contract XAGFTokenV1 is RewardedTokenLocker, VersionedInitializable {
  string internal constant NAME = 'Augmented Finance Locked Reward Token';
  string internal constant SYMBOL = 'xAGF';
  uint8 internal constant DECIMALS = 18;

  string private _name;
  string private _symbol;
  uint8 private _decimals;

  uint256 private constant TOKEN_REVISION = 1;
  uint32 private constant ONE_PERIOD = 1 weeks;
  uint32 private constant MAX_PERIOD = 4 * 52 weeks;
  uint256 private constant MAX_SUPPLY = 10**36;

  constructor()
    public
    RewardedTokenLocker(
      IMarketAccessController(0),
      address(0),
      18,
      ONE_PERIOD,
      MAX_PERIOD,
      MAX_SUPPLY
    )
  {
    _initializeERC20(NAME, SYMBOL, DECIMALS);
  }

  function _initializeERC20(
    string memory name,
    string memory symbol,
    uint8 decimals
  ) internal {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function getRevision() internal pure virtual override returns (uint256) {
    return TOKEN_REVISION;
  }

  // This initializer is invoked by AccessController.setAddressAsImpl
  function initialize(IMarketAccessController remoteAcl)
    external
    virtual
    initializerRunAlways(TOKEN_REVISION)
  {
    _initialize(remoteAcl, remoteAcl.getRewardToken(), NAME, SYMBOL, DECIMALS);
  }

  function initializeToken(
    IMarketAccessController remoteAcl,
    address underlying,
    string calldata name_,
    string calldata symbol_,
    uint8 decimals_
  ) public virtual initializerRunAlways(TOKEN_REVISION) {
    _initialize(remoteAcl, underlying, name_, symbol_, decimals_);
  }

  function _initialize(
    IMarketAccessController remoteAcl,
    address underlying,
    string memory name_,
    string memory symbol_,
    uint8 decimals_
  ) private {
    require(underlying != address(0), 'underlying is missing');
    _remoteAcl = remoteAcl;
    _initializeERC20(name_, symbol_, decimals_);
    super._initialize(underlying, IERC20Details(underlying).decimals(), ONE_PERIOD, MAX_PERIOD);
  }
}
