// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol" ;
import {DeployFundMe} from "../script/DeployFundMe.s.sol" ;


contract FundMeTest is Test{
   FundMe fundMe;

    address  USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

  function setUp() external {
    //  fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      DeployFundMe deployFundMe = new DeployFundMe();
      fundMe = deployFundMe.run();
      vm.deal(USER, STARTING_BALANCE);
  }

  function testMinimumDollarIsFive() public {
    console.log("Hello!");
    assertEq(fundMe.MINIMUM_USD(),5e18);
   
  }

  function testOwnerisMsgSender() public {
    assertEq(fundMe.i_owner(), msg.sender);
   
  }

  function testPriceVersionIsAccurate() public {
   uint256 version =  fundMe.getVersion();
   assertEq(version,4);
  }
  // --match-test

   function testFundFailsWithoutEnoughEth() public {

        vm.expectRevert();// Hey the nextline , should revert

        fundMe.fund();// here sending 0 value

        
    }

       function testFundUpdatesFundedDataStructure() public {

        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        uint256 amountFunded  = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);

    }

}
