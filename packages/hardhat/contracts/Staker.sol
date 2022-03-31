// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;

  // add a stake event
  event Stake(address, uint256);


  // Stake funds
  function stake(uint256 amount) public payable {
    require(balances[msg.sender] == 0, "You already have staked funds");
   
    // require the message value to be greater than or equal to the amount
    require(msg.value >= amount * 10^18, "You did not send enough ether");

    // increase the balance of the sender
    balances[msg.sender] = amount;
    
    // emit the event
    emit Stake(msg.sender, amount);

  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
