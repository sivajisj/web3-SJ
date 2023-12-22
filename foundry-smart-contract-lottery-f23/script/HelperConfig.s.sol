// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken}  from "../test/mocks/LinkToken.sol";





contract HelperConfig is Script{

  



    struct NetworkConfig{
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        uint64 subscriptionId;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        address link;
      
    }

      NetworkConfig public activeNetworkConfig;
    
  
        constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else{
            activeNetworkConfig = getOrCreateAnvilETHConfig();
        }
    }

    function getSepoliaEthConfig() public  view returns(NetworkConfig memory sepoliaNetworkConfig){ 
        
        return NetworkConfig({
            entranceFee: 0.01 ether ,
            interval: 30,
            vrfCoordinator : 0x271682DEB8C4E0901D1a1550aD2e64D568E69909,
            subscriptionId : 0,
            gasLane :0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit : 500000,
            link : 0x779877A7B0D9E8603169DdbD7836e478b4624789

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
     

          LinkToken link = new LinkToken();

          vm.stopBroadcast();


            return NetworkConfig({
            entranceFee: 0.01 ether ,
            interval: 30,
            vrfCoordinator : address(vrfCoordinatorMock),
            subscriptionId : 0,
            gasLane :0x9fe0eebf5e446e3c998ec9bb19951541aee00bb90ea201ae456421a2ded86805,
            callbackGasLimit : 500000,
            link : address(link)

        });
    
    }

}
