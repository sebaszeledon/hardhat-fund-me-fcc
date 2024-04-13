// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; //4:53

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error FundMe__NotOwner();

/**
 * @title A contract for crowd funding
 * @author Sebastián Zeledón
 * @notice This contract is to demo a sample funding contract
 * @dev This implements price feeds as our Library 
 */
contract FundMe {
    //Type declarations
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    //State Variables 
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;
    AggregatorV3Interface public priceFeed;

    //
    modifier onlyOwner {
        //require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) {revert FundMe__NotOwner();}
        _;
    }
    
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
    /**
    * @notice This function funds this conrtract
    * @dev This implements price feeds as our Library 
    */
    function fund() public payable{
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "Didn't sent enough!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public onlyOwner{
        //require(msg.sender == owner, "Sender is not owner");
        /* For Syntax: starting index, ending index, step amount */
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
        //withdraw the funds
        //call (recommended)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed.");

    } 

}