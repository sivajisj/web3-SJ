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

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
// import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

contract Raffle is VRFConsumerBaseV2 {
    error Raffle_NotEnoughETHSent();

    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint256 private immutable i_entranceFee;
    uint64 private immutable i_subscriptionId;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    // keep all track of participants

    address payable[] private s_players;

    //Events

    event Enterraffle(address indexed player);

    // mapping (address => uint) name;

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        uint64 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() external payable {
        //   require(msg.value >= i_entranceFee, "Not enough ETH to send..!");
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughETHSent();
        }
        s_players.push(payable(msg.sender));

        //1 .Makes migration easier
        //2 .Makes front end "indexing" easier

        emit Enterraffle(msg.sender);
    }

    // Get a randome number and using this for pick a player
    // Be automatically called
    function pickWinner() external {
        //check if enough time is passed
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

        /**
     * @dev This is the function that Chainlink VRF node
     * calls to send the money to the random winner.
     */
    function fulfillRandomWords(
        uint256  requestId ,
        uint256[] memory randomWords
    ) internal override {
        // s_players size 10
        // randomNumber 202
        // 202 % 10 ? what's doesn't divide evenly into 202?
        // 20 * 10 = 200
        // 2
        // 202 % 10 = 2
        // uint256 indexOfWinner = randomWords[0] % s_players.length;
        // address payable recentWinner = s_players[indexOfWinner];
        // s_recentWinner = recentWinner;
        // s_players = new address payable[](0);
        // s_raffleState = RaffleState.OPEN;
        // s_lastTimeStamp = block.timestamp;
        // emit WinnerPicked(recentWinner);
        // (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // // require(success, "Transfer failed");
        // if (!success) {
        //     revert Raffle__TransferFailed();
        // }
    }

    /* Getter functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
