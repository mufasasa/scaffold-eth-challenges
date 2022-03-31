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
  function stake() public payable {
    
    // increase the balance of the sender
    balances[msg.sender] += msg.value;
    
    // emit the event
    emit Stake(msg.sender, msg.value);

  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  uint256 public deadline = block.timestamp + 30 seconds;

  // keep track of whether the contract is open for withdrawal
  bool openForWithdraw = false;

  // execute function that is public and only called when the deadline has passed
  function execute() public {
    require(block.timestamp >= deadline, "The deadline has not passed yet");
    
    // call the external contract
    if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else {
      openForWithdraw = true;
    }

  }


  



  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance

  // Withdraw funds by calling `withdraw()`
  function withdraw() public {
    require(openForWithdraw, "The contract is not open for withdrawal");
    require(balances[msg.sender] > 0, "You have no funds to withdraw");
    
    // get the amount of ether staked by the sender
     uint256 stakedEther = balances[msg.sender];

    // send all the funds of the sender
   (bool successful,) = msg.sender.call{value:stakedEther}("");
   require(successful, "Transaction failed");

    // reset the balances
    balances[msg.sender] = 0;
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

  function timeLeft() public view returns (uint256) {
    if (block.timestamp >= deadline) {
      return 0;
    }
    else {
      return deadline - block.timestamp;
    }
  }

  // Add the `receive()` special function that receives eth and calls stake()

  receive() external payable {
    
    
    // call the stake function
    stake();

  }

}
