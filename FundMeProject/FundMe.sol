// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;  // all functions defined in PriceConverter will be used for uint256 

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // immutable for variables that are initialized inside a constructor and do not change another time
    address public  immutable  i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    
    constructor() {
        i_owner = msg.sender;
    }

    // function that will allow users to fund money to the contract , payable to allow users to send money to the contract as they sent money to a user wallet's address 
    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    //   function fund() public payable {
    //     require(msg.value > 1e18, "You need to send  more then 1 ETH!");
      
    // }
    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    //// This function enables the contract deployer, who is the user that deployed the contract, to transfer the funds from the contract (originally provided by users) to his own wallet.

    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // reset the array of funders
        // // transfer : automatically revert (throw error ) if the gas used to send money > 2300
        // payable(msg.sender).transfer(address(this).balance);
        
        // // send : return boolean 
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
   
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}
