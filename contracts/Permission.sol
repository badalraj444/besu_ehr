// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Registry.sol";  // import path for the registry contract

contract Permission {
    mapping(address => address) public link; // Maps requester to granter
    mapping(address => mapping(address => bool)) public permissions; // Maps requester to granter to permission status

    Registry public registry; // Reference to the Registry contract

    event NotifyRequest(address patient, address requester, uint periodReq, string message);
    event NotifyGrant(address requester, address granter, uint periodGranted, string message);
    event NotifyDenial(address requester, address granter, string message);

    // Constructor to initialize the Registry contract
    constructor(address _registryAddress) {
        registry = Registry(_registryAddress); // Set the registry address registry.target 
    }

    // Function to request permission from a granter
    function requestPermission(address _requester, address _granter, uint _periodReq) public {
        require(registry.checkUser(msg.sender), "You are not registered!"); // Check if caller is registered
        require(msg.sender == _requester, "You cannot request for others!"); // Ensure the requester is the caller

        emit NotifyRequest(_granter, _requester, _periodReq, "You have a new request for permission.");
    }

    // Function to approve or deny permission
    function approvePermission(address _requester, address _granter, bool _allow, uint _periodGranted) public {
        require(registry.checkUser(msg.sender), "You are not registered!"); // Check if caller is registered
        require(msg.sender == _granter, "You cannot permit for others!"); // Ensure the granter is the caller

        if (_allow) {
            link[_requester] = _granter;
            permissions[_requester][_granter] = true; // Grant permission
            emit NotifyGrant(_requester, _granter, _periodGranted, "Permission granted!");
        } else {
            emit NotifyDenial(_requester, _granter, "Permission denied!"); // Notify denial
        }
    }

    // Function to check if permission is granted
    function checkPermission(address _requester, address _granter) public view returns (bool) {
        return permissions[_requester][_granter]; // Return the permission status
    }
}
