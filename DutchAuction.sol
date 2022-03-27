// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
} 

contract DutchAuction {

    uint public constant Duration = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;
    
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiretAt;
    uint public immutable discountRate;
    address public immutable seller;


    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftId) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiretAt = block.timestamp + Duration;

        require(_startingPrice >= _discountRate * Duration, "Starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    } 


}
