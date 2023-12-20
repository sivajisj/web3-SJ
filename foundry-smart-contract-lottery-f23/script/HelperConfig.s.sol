// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";





contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;



    struct NetworkConfig{
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        uint64 subscriptionId;
        bytes32 gasLane;
        uint32 callbackGasLimit;
      
    }
    
    NetworkConfig public c;
        constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else{
            activeNetworkConfig = getOrCreateAnvilETHConfig();
        }
    }

    function getSepoliaEthConfig() public view returns(NetworkConfig memory){ 
        
        return NetworkConfig({
            entranceFee: 0.01 ether ,
            interval: 30,
            vrfCoordinator : 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            subscriptionId : 0,
            gasLane :0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit : 500000

        });
    }

    function getOrCreateAnvilETHConfig()public  returns(NetworkConfig memory){
    
     
      
         if(activeNetworkConfig.vrfCoordinator != address(0)){
                     return activeNetworkConfig;
         }
          
          uint96 baseFee = 0.25 ether;
          uint96 gasPriceLink = 1e9 ;
          vm.startBroadcast();
          VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
          vm.stopBroadcast();


            return NetworkConfig({
            entranceFee: 0.01 ether ,
            interval: 30,
            vrfCoordinator : address(vrfCoordinatorMock),
            subscriptionId : 0,
            gasLane :0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit : 500000

        });
    
    }

}
