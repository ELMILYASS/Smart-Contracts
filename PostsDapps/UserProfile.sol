// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Profile{
    struct UserProfile{
        string Name ;
        string description ;
    }
    mapping (address => UserProfile ) public userProfiles ;

    function setProfile(string memory name , string memory desc) public {
        userProfiles[msg.sender]=UserProfile(name,desc);
    }

     
}