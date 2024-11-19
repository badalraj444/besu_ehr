// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Registry {
    enum Role { Patient, CareProvider, Researcher, Regulator }

    struct User {
        bytes32 key;
        Role role;
        bool isRegistered;
    }

    mapping(address => User) public users;
    string[4] public roles = ["Patient", "CareProvider", "Researcher", "Regulator"];
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function checkUser(address userAddress) public view returns (bool) {
        return users[userAddress].isRegistered;
    }

    function registerUser(bytes32 _key, string memory _role) public {
        require(!checkUser(msg.sender), "User already registered!");

        Role role;
        if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Patient"))) {
            role = Role.Patient;
        } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("CareProvider"))) {
            role = Role.CareProvider;
        } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Researcher"))) {
            role = Role.Researcher;
        } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Regulator"))) {
            role = Role.Regulator;
        } else {
            revert("Invalid role!");
        }

        users[msg.sender] = User({
            key: _key,
            role: role,
            isRegistered: true
        });
    }

    function getUserRole(address userAddress) public view returns (Role) {
        require(users[userAddress].isRegistered, "User not registered");
        return users[userAddress].role;
    }
}