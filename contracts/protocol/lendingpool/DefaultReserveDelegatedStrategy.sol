// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

import '../../dependencies/openzeppelin/contracts/SafeMath.sol';
import '../../interfaces/IReserveDelegatedStrategy.sol';
import '../../tools/math/WadRayMath.sol';
import '../../tools/math/PercentageMath.sol';
import '../../interfaces/IPriceOracleProvider.sol';
import '../../interfaces/ILendingRateOracle.sol';
import '../../dependencies/openzeppelin/contracts/IERC20.sol';

abstract contract DefaultReserveDelegatedStrategy is IReserveDelegatedStrategy {
  using WadRayMath for uint256;
  using SafeMath for uint256;
  using PercentageMath for uint256;

  address public immutable externalProvider;

  constructor(address externalProvider_) public {
    externalProvider = externalProvider_;
  }

  function baseVariableBorrowRate() external view override returns (uint256) {
    return 0;
  }

  function getMaxVariableBorrowRate() external view override returns (uint256) {
    return 0;
  }
}