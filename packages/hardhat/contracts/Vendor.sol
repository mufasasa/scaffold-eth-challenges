pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    // calculate the number of tokens to buy based on the amount of ETH sent
    uint256 amountOfTokens = msg.value * tokensPerEth;

    // transfer the tokens to the buyer
    yourToken.transfer(msg.sender, amountOfTokens);

    // emit the BuyTokens event
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    uint256 amount = address(this).balance;

    (bool sent,) = msg.sender.call{value: amount}("");
    require(sent, "Failed to send funds to owner");
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount_of_tokens) public {

    
    yourToken.transferFrom(msg.sender, address(this), amount_of_tokens);

    // calculate eth to send at the current rate
    uint256 amountOfETH = amount_of_tokens / tokensPerEth;


    // send the ETH to the seller
    (bool sent,) = msg.sender.call{value:  amountOfETH}("");
    require(sent, "Failed to send funds to seller");

  }

}
