// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from  "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test{
    FundMe fundMe;


    function setUp() external{
        //  fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
          DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
     
    }


    function testMinimusUSDIsFive() public{
        assertEq(fundMe.MINIMUM_USD(),5e18);

        // console.log(fundMe.i_owner());
        // console.log(msg.sender);
    
    }
    function testOwnerIsMsgSender() public{
        assertEq(fundMe.i_owner(),address(this));
    
    }

    function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}