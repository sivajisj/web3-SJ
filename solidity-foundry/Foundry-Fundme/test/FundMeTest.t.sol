// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test{

    uint number = 1;

    function setUp() external{
        number = 2;
    }


    function testDemo() public{
       assertEq(number, 2);
    }
}