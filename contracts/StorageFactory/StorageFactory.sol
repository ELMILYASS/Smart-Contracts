// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import "./SimpleStorage.sol";
// import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;
    
// SimpleStorage public simpleStorage ; 
    function createSimpleStorageContract() public {
        // simpleStorage = new SimpleStorage();
        SimpleStorage simpleStorageContractVariable = new SimpleStorage();
        listOfSimpleStorageContracts.push(simpleStorageContractVariable);
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        //to interact with a smart contract we need it's address and ABI, ABI is generated when the smart contract is deployed ( after complilation ) so the compliter knows ABIs for smart contracts in the list
        // Address
        // ABI
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}