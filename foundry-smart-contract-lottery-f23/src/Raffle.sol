// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


/**@title A sample Raffle Contract
 * @author Patrick Collins
 * @notice This contract is for creating a sample raffle contract
 * @dev This implements the Chainlink VRF Version 2
 */

contract Raffle {

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee ;
    }

       function enterRaffle() public {
        
       }    


       function pickWinner() public{

       }

       /* Getter functions */

       function getEntranceFee() external view returns( uint256){
          return i_entranceFee;
       }
}