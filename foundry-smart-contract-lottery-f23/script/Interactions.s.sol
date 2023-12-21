// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
// import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
// import {LinkToken} from "../test/mocks/LinkToken.sol";


contract CreateSubscription is Script {

       function CreateSubscriptionUsingConfig() public returns(uint64) {
        HelperConfig helperConfig = new HelperConfig();

        (,, address vrfCoordinator,,,) = helperConfig.activeNetworkConfig();
        return createSubscription(vrfCoordinator);
        
       }


       function run() external returns (uint64) {
              return CreateSubscriptionUsingConfig(); 
       }

       
    function createSubscription(
        address vrfCoordinatorV2
       
    ) public returns (uint64){
         console.log("Create subdcription on ChainId: ", block.chainid);

         vm.startBroadcast();
         uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2).createSubscription();
         vm.stopBroadcast();
        

        console.log("Your SubId is : ", subId);
        console.log("please update subscription in HelperConfig.s.sol");
        return subId;
    }
}