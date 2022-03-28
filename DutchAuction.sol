// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// @dev Interface to implement transferFrom function
interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
} 

/**
@title Dutch Auction Contract
@notice This is a smart contract - a program that can deployed into Ethereum smart chain
@author Aiman Nazmi
*/

contract DutchAuction {
    // @notice Auction duration
    uint public constant Duration = 7 days;
    // @notice Instantiate NFT object
    IERC721 public immutable nft;
    // @notice Id of token
    uint public immutable nftId;
    // @notice NFT starting price
    uint public immutable startingPrice;
    // @notice Auction start time
    uint public immutable startAt;
    // @notice Auction end time
    uint public immutable expiretAt;
    // @notice Dicount rate over time
    uint public immutable discountRate;
    // @notice Address of seller
    address public immutable seller;

    // @notice Constructor to set all relevant state variables
    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftId) {
        seller = msg.sender;
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiretAt = block.timestamp + Duration;

        require(_startingPrice >= _discountRate * Duration, "Starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    } 
    // @notice Function to inquire token price
    function getPrice() public view returns (uint256) {
        uint256 timeLapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeLapsed;
        return startingPrice - discount;
    }
    // @notice Function to buy NFT and 'delete' contract
    function buyNFT() external payable {
        require(block.timestamp < expiretAt, "Auction expired");
        uint256 price = getPrice();
        require(msg.value >= price, "Insufficient payment amount");
        nft.transferFrom(seller, msg.sender, nftId);

        uint256 refundAmount = msg.value - price;
        if(refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
        selfdestruct(payable(seller));
    }

}
