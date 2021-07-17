import { task } from 'hardhat/config';
import {
  deployLendingPoolCollateralManagerImpl,
  deployLendingPoolConfiguratorImpl,
  deployLendingPoolImpl,
} from '../../helpers/contracts-deployments';
import { eContractid, eNetwork } from '../../helpers/types';
import { falsyOrZeroAddress, getTenderlyDashboardLink, waitForTx } from '../../helpers/misc-utils';
import {
  getMarketAddressController,
  getLendingPoolProxy,
  getLendingPoolConfiguratorProxy,
} from '../../helpers/contracts-getters';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { loadPoolConfig, ConfigNames } from '../../helpers/configuration';

task('full:deploy-lending-pool', 'Deploy lending pool for prod enviroment')
  .addFlag('verify', 'Verify contracts at Etherscan')
  .addParam('pool', `Pool name to retrieve configuration, supported: ${Object.values(ConfigNames)}`)
  .setAction(async ({ verify, pool }, DRE: HardhatRuntimeEnvironment) => {
    await DRE.run('set-DRE');
    const network = <eNetwork>DRE.network.name;
    const poolConfig = loadPoolConfig(pool);
    const addressesProvider = await getMarketAddressController();

    // Reuse/deploy lending pool implementation

    console.log('\tDeploying new lending pool implementation & libraries...');
    const lendingPoolImpl = await deployLendingPoolImpl(verify);
    const lendingPoolImplAddress = lendingPoolImpl.address;

    console.log('\tSetting lending pool implementation with address:', lendingPoolImplAddress);
    // Set lending pool impl to Address provider
    await waitForTx(await addressesProvider.setLendingPoolImpl(lendingPoolImplAddress));

    const address = await addressesProvider.getLendingPool();
    const lendingPoolProxy = await getLendingPoolProxy(address);

    console.log('\tDeploying new configurator implementation...');
    const lendingPoolConfiguratorImpl = await deployLendingPoolConfiguratorImpl(verify);
    const lendingPoolConfiguratorImplAddress = lendingPoolConfiguratorImpl.address;

    console.log(
      '\tSetting lending pool configurator implementation with address:',
      lendingPoolConfiguratorImplAddress
    );

    const collateralManager = await deployLendingPoolCollateralManagerImpl(verify);
    console.log(
      '\tSetting lending pool collateral manager implementation with address',
      collateralManager.address
    );
    await waitForTx(
      await lendingPoolProxy.setLendingPoolCollateralManager(collateralManager.address)
    );

    // Set lending pool conf impl to Address Provider
    await waitForTx(
      await addressesProvider.setLendingPoolConfiguratorImpl(lendingPoolConfiguratorImplAddress)
    );
  });