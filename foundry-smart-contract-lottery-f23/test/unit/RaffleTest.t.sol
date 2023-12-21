// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test,console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test{

  /* Events */

  event RaffleEnter(address indexed player);


  
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    uint64 subscriptionId;
    bytes32 gasLane;
    uint32 callbackGasLimit;
    address link;

     address public PLAYER = makeAddr("player");
     uint256 public constant STARTING_USER_BALANCE = 10 ether;



    function setUp() external {
      DeployRaffle deployer = new DeployRaffle();
       (raffle, helperConfig) = deployer.run();
       (
        entranceFee,
        interval,
        vrfCoordinator,
        subscriptionId,
        gasLane,
        callbackGasLimit,
        link
          ) = helperConfig.activeNetworkConfig();
       vm.deal(PLAYER, STARTING_USER_BALANCE);

    }


      function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertWhenYouDontPayEnoughEth() public {
      //Arrange
      vm.prank(PLAYER);

      //Act  //assert
      vm.expectRevert(Raffle.Raffle_NotEnoughETHSent.selector);
      raffle.enterRaffle();
      


    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
      vm.prank(PLAYER);
      raffle.enterRaffle{value : entranceFee}();
      address playerRecorded = raffle.getPlayer(0);
      assert(playerRecorded == PLAYER);
    }

    function testEmitsEventOnEntrance() public{
      // Arrange
        vm.prank(PLAYER);

        // Act / Assert
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEnter(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

    }

     function testDontAllowPlayersToEnterWhileRaffleIsCalculating() public {
        vm.prank(PLAYER);
        raffle.enterRaffle{value : entranceFee}();

       // vm.roll(newHeight); //used for setting new block.number avlue
       // vm.warp(newTimestamp); //used for setting new block.timestamp avlue
       vm.warp(block.timestamp + interval  + 1);

       vm.roll(block.number + 1);

       raffle.performUpkeep("");
       

      vm.expectRevert(Raffle.Raffle_RaffleNotOpen.selector);
      vm.prank(PLAYER);
      raffle.enterRaffle{value : entranceFee} ();

    }
}