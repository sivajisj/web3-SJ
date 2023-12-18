
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


/**@title A sample Raffle Contract
 * @author Patrick Collins
 * @notice This contract is for creating a sample raffle contract
 * @dev This implements the Chainlink VRF Version 2
 */

contract Raffle {

    error Raffle_NotEnoughETHSent();

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;

    // keep all track of participants

    address payable[] private s_players;

    //Events

    event Enterraffle(address indexed player);

    // mapping (address => uint) name;

    constructor(uint256 entranceFee, uint256 interval){
        i_entranceFee = entranceFee ;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

       function enterRaffle() external payable {
        //   require(msg.value >= i_entranceFee, "Not enough ETH to send..!");
        if(msg.value < i_entranceFee){
            revert Raffle_NotEnoughETHSent();
        }
        s_players.push(payable(msg.sender));

        //1 .Makes migration easier
        //2 .Makes front end "indexing" easier

        emit Enterraffle(msg.sender);
       }    

       // Get a randome number and using this for pick a player
       // Be automatically called
       function pickWinner() view external{
      
      //check if enough time is passed
      if(block.timestamp - s_lastTimeStamp < i_interval){
        revert();
      }



       }

       /* Getter functions */

       function getEntranceFee() external view returns( uint256){
          return i_entranceFee;
       }
}