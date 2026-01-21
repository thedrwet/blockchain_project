// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LC.sol";
import "./USD.sol";

contract LCMaster {
    LC[] public lcs; // List of all LCs
    USD public token;

    constructor(address _tokenAddress) {
        token = USD(_tokenAddress);
    }

    function createLC(address _buyer, address _seller, uint _amount, uint _expiration) public {
        // 1. Create the new LC Contract
        LC newLC = new LC(_buyer, _seller, msg.sender, _amount, _expiration, address(token));
        
        // 2. Add to our list
        lcs.push(newLC);

        // 3. TRANSFER MONEY: Bank -> New LC Contract
        // The Bank (msg.sender) must have approved this Master contract first!
        token.transferFrom(msg.sender, address(newLC), _amount);
    }

    function lengthLC() public view returns (uint) {
        return lcs.length;
    }

    // Function to get data for the frontend list
    function viewLC(uint index) public view returns (address, address, uint, bytes1, uint, uint, address) {
        LC lc = lcs[index];
        (address buyer, address seller, uint amount, uint statusInt, uint expiration) = lc.getDetails();
        
        // Convert integer status to Character (I, A, S) for your Frontend
        bytes1 charStatus;
        if (statusInt == 0) charStatus = "I";
        if (statusInt == 1) charStatus = "A";
        if (statusInt == 2) charStatus = "S";

        return (seller, buyer, amount, charStatus, 0, expiration, address(lc));
    }
}