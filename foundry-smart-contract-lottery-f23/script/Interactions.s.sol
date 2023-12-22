// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";


contract CreateSubscription is Script {

       function CreateSubscriptionUsingConfig() public returns(uint64) {
        HelperConfig helperConfig = new HelperConfig();

        (,, address vrfCoordinator,,,,) = helperConfig.activeNetworkConfig();
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
contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether ;

    function fundSubscriptionUsingConfig()public {
         HelperConfig helperConfig = new HelperConfig();

        (,, address vrfCoordinator,uint64 subId,,,address link) = helperConfig.activeNetworkConfig();
        fundSubscription(vrfCoordinator , subId, link);
        
    }

    function fundSubscription(address vrfCoordinator, uint64 subId, address link) public {
        console.log("Funding subscription: ", subId);
        console.log("Using vrfCoordinator: ", vrfCoordinator);
        console.log("On ChainId :", block.chainid);

        if(block.chainid == 31337){
            vm.startBroadcast();
            VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription(subId, FUND_AMOUNT);
            vm.stopBroadcast();
        }else{
            vm.startBroadcast();
            LinkToken(link).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subId));
            vm.stopBroadcast();
        }
    }

    function run()external {

        fundSubscriptionUsingConfig();
        
    }


}


contract AddConsumer is Script {

         function addConsumerUsingConfig(address raffle) public{
        
         HelperConfig helperConfig = new HelperConfig();

        (,, address vrfCoordinator,uint64 subId,,,) = helperConfig.activeNetworkConfig();
        addConsumer(raffle, vrfCoordinator,subId);


        
    }

       function addConsumer(address raffle ,address vrfCoordinator,uint64 subId ) public {
        console.log("Adding consumer contract : ", raffle);
        console.log("using vrfCoordinator : ", vrfCoordinator);
        console.log("On ChainID : ", block.chainid);

        vm.startBroadcast();

        VRFCoordinatorV2Mock(vrfCoordinator).addConsumer(subId,raffle);


        vm.stopBroadcast();
    }

    function run()external {

        address raffle = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );

        addConsumerUsingConfig(raffle);
        
    }



 
}