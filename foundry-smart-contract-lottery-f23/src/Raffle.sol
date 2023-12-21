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
     error Raffle__TransferFailed();
     error Raffle_RaffleNotOpen();
     error Raffle__UpkeepNotNeeded(
        uint256 currentBalance,
        uint256 numPlayers,
        uint256 raffleState
     );


   /* Type declarations */
    enum RaffleState {
        OPEN, //0
        CALCULATING //1
    }
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint256 private immutable i_entranceFee;
    uint64 private immutable i_subscriptionId;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    RaffleState private s_raffleState;

    // keep all track of participants

    address payable[] private s_players;
    address private s_recentWinner;

    //Events

    event RaffleEnter(address indexed player);
    event WinnerPicked(address indexed winner);

    // mapping (address => uint) name;

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        uint64 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit,
        address link
    ) VRFConsumerBaseV2(vrfCoordinator){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        s_raffleState = RaffleState.OPEN;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() external payable {
        //   require(msg.value >= i_entranceFee, "Not enough ETH to send..!");
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughETHSent();
        }
        s_players.push(payable(msg.sender));
        
        if(s_raffleState != RaffleState.OPEN){
            revert Raffle_RaffleNotOpen();
        }

        //1 .Makes migration easier
        //2 .Makes front end "indexing" easier

        emit RaffleEnter(msg.sender);
    }


      /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * they look for `upkeepNeeded` to return True.
     * the following should be true for this to return true:
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is open.
     * 3. The contract has ETH.
     * 4. Implicity, your subscription is funded with LINK.
     */

    function checkUpKeep(
        bytes memory /*checkData */
    ) public view returns(bool upKeepNeeded , bytes memory ){
          bool isOpen = RaffleState.OPEN == s_raffleState;
          bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
          bool hasPlayers = s_players.length > 0;
          bool hasBalance = address(this).balance > 0;
          upKeepNeeded = (timePassed && isOpen && hasBalance && hasPlayers);
          return (upKeepNeeded,"0x0");
    }

    // Get a randome number and using this for pick a player
    // Be automatically called
    function pickWinner() external {
        //check if enough time is passed
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }


      /**
     * @dev Once `checkUpkeep` is returning `true`, this function is called
     * and it kicks off a Chainlink VRF call to get a random winner.
     */
    function performUpkeep(bytes calldata /* performData */) external  {
        (bool upkeepNeeded, ) = checkUpKeep("");
        // require(upkeepNeeded, "Upkeep not needed");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        s_raffleState = RaffleState.CALCULATING;
        i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        // Quiz... is this redundant?
        // emit RequestedRaffleWinner(requestId);
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
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_players = new address payable[](0);
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        emit WinnerPicked(recentWinner);
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // // require(success, "Transfer failed");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /* Getter functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns(RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns(address) {
        return s_players[indexOfPlayer];
    }
}
