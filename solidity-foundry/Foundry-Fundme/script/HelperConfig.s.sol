// SPDX-License-Identifier: MIT

// 1. Deploy mock when we are on a local anvil chain
// 2. keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD 


pragma solidity ^0.8.18;


import {Script} from "forge-std/Script.sol";
import {FundMe} from  "../src/FundMe.sol";


contract HelperConfig {

    //If we are on a local anvil , we depploy mocks
    //Otherwise , grab the existing address from the live networks

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig{
        address priceFeed; // ETH/ USD price feed address
    }

    constructor(){
       if(block.chainid == 11155111){
        activeNetworkConfig= getSepoliaEthConfig();
       }else if(block.chainid == 1){
         activeNetworkConfig= getMainnetEthConfig();

       }else{
        activeNetworkConfig = getAnvilEthConfig();
       }
    }


     function getMainnetEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory mainnetEthConfig = NetworkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 });

        return mainnetEthConfig;

     }
     function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306 });

        return sepoliaConfig;

     }

     function getAnvilEthConfig() public pure returns(NetworkConfig memory){


     }
}

