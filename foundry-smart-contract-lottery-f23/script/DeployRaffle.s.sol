// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import  {HelperConfig} from "./HelperConfig.s.sol";
import { CreateSubscription,AddConsumer, FundSubscription} from "./Interactions.s.sol";


contract DeployRaffle is Script{

    function run() external returns(Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        uint64 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit,
        address link
        ) = helperConfig.activeNetworkConfig();

        if(subscriptionId == 0){
            CreateSubscription createSubscription = new CreateSubscription();

            subscriptionId = createSubscription.createSubscription(vrfCoordinator) ;

            console.log(subscriptionId);

            // Fund it
            FundSubscription fundSubscription = new FundSubscription();

            fundSubscription.fundSubscription(vrfCoordinator, subscriptionId, link);


        }

        vm.startBroadcast();

        Raffle raffle = new Raffle(
         entranceFee,
         interval,
         vrfCoordinator,
         subscriptionId,
         gasLane,
         callbackGasLimit
        );

        vm.stopBroadcast();

        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(address(raffle), vrfCoordinator, subscriptionId);

        return (raffle , helperConfig);
    }

}