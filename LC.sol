// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./USD.sol";

contract LC {
    // 1. Variables
    address public buyer;
    address public seller;
    address public bank;
    uint public amount;
    uint public expiration;
    uint public status; // 0=Issued, 1=Accepted, 2=Settled
    
    USD public token;

    // 2. Constructor (Updated for 0.8.0: No 'public' visibility)
    constructor(
        address _buyer, 
        address _seller, 
        address _bank,
        uint _amount, 
        uint _expiration,
        address _tokenAddress
    ) {
        buyer = _buyer;
        seller = _seller;
        bank = _bank;
        amount = _amount;
        expiration = _expiration;
        token = USD(_tokenAddress);
        status = 0; // Starts as "Issued"
    }

    // 3. Accept Function
    function acceptLC() public {
        // Security Check: Only Seller can accept
        require(msg.sender == seller, "Only Seller can accept!");
        require(status == 0, "LC is not in Issued state");
        
        status = 1; // Change to "Accepted"
    }

    // 4. Settle Function
    function settleLC() public {
        require(msg.sender == seller, "Only Seller can settle!");
        require(status == 1, "LC must be Accepted first");
        
        // Transfer money from THIS contract to Seller
        token.transfer(seller, amount);
        
        status = 2; // Change to "Settled"
    }

    // 5. Helper to view details
    function getDetails() public view returns (address, address, uint, uint, uint) {
        return (buyer, seller, amount, status, expiration);
    }
}