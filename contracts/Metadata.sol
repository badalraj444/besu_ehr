// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Registry.sol";  // Assuming Registry.sol is in the same directory
import "./Permission.sol";  // Import the Permission contract

contract Metadata {
    Registry public registry;
    Permission public permission;  // Add reference to the Permission contract

    enum DataType { BloodTest, XRay, MRI, Prescription }

    struct Data {
        bytes32 key;
        DataType dataType;
        bytes32 hashIndex;
        bytes32 encKey;
    }

    // Mapping from address to an array of Data
    mapping(address => Data[]) public patientData;

    event DataAdded(string message);
    event NotifyUser(address userAddress, string message);

    // Constructor to set the Registry and Permission contract addresses
    constructor(address _registryAddress, address _permissionAddress) {
        registry = Registry(_registryAddress);  // Initialize the Registry contract
        permission = Permission(_permissionAddress);  // Initialize the Permission contract
    }

    function addEHRdata(
        address _userAddress, 
        bytes32 _key, 
        DataType _dataType, 
        bytes32 _hashIndex, 
        bytes32  _encKey
    ) 
        public 
    {
        require(registry.getUserRole(msg.sender) == Registry.Role.CareProvider, "You are not authorized!");

        // Push the new data into the array for the user
        patientData[_userAddress].push(Data({
            key: _key,
            dataType: _dataType,
            hashIndex: _hashIndex,
            encKey: _encKey
        }));

        emit DataAdded("Data added successfully!");
        emit NotifyUser(_userAddress, "New data added to your account!");
    }

    // Updated function to get patient data with permission check
    function getPatientData(address _userAddress) public view returns (Data[] memory) {
        // Ensure the caller has permission to access the requested user's data
        require(
            permission.checkPermission(msg.sender, _userAddress), 
            "You do not have permission to access this data!"
        );

        return patientData[_userAddress];
    }
}
