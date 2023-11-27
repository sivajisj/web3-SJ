// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from  "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test{
    FundMe fundMe;

    address  USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;


    function setUp() external{
        //   const fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
     
    }


    function testMinimusUSDIsFive() public{
        assertEq(fundMe.MINIMUM_USD(),5e18);

        // console.log(fundMe.i_owner());
        // console.log(msg.sender);
    
    }
    function testOwnerIsMsgSender() public{
        assertEq(fundMe.i_owner(),msg.sender);
    
    }

    function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {

        vm.expectRevert();

        fundMe.fund();

        
    }

    function testFundUpdatesFundedDataStructure() public {

        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        uint256 amountFunded  = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);

    }
}