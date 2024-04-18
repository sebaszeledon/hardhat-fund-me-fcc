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
    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;
    address public immutable i_owner;
    AggregatorV3Interface public s_priceFeed;

    //
    modifier onlyOwner {
        //require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) {revert FundMe__NotOwner();}
        _;
    }
    
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
    /**
    * @notice This function funds this conrtract
    * @dev This implements price feeds as our Library 
    */
    function fund() public payable{
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Didn't sent enough!");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        //require(msg.sender == owner, "Sender is not owner");
        /* For Syntax: starting index, ending index, step amount */
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        //reset the array
        s_funders = new address[](0);
        //withdraw the funds
        //call (recommended)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed.");

    }
    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    function cheaperWithdraw() public payable onlyOwner{
        address[] memory funders = s_funders;
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{ value : address(this).balance}("");
        require(success);
    }

}