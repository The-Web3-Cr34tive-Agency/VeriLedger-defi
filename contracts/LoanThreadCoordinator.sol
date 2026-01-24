// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunicationsTool {
    // Enum for message types in the lending workflow
    enum MessageType {
        REQUEST,
        RISK_RESULT,
        PROOF,
        APPROVAL
    }

    // Structure to store thread actions
    struct ThreadAction {
        address sender;
        bytes32 threadId;
        MessageType messageType; // enum for the type of message: SEND_MESSAGE, RECEIVE_MESSAGE
        string ciphertextURI;  // IPFS/Arweave/HTTPS location
        uint256 sequenceNumber; // strict ordering per thread
        uint256 timestamp;
    }


    // Mapping to store thread actions for each thread
    mapping(bytes32 => ThreadAction[]) public threadActions;

    // Mapping to track sequence numbers for strict ordering per thread
    mapping(bytes32 => uint256) public sequenceNumbers; // sequence number for each thread

    // Constructor to initialize user roles (admin function)
    address public admin;
    constructor() {
        admin = msg.sender;
        roles[msg.sender] = "admin";
    }

    // Function to create a new thread
    function createThread(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.REQUEST,
            ciphertextURI: "",
            sequenceNumber: 0,
}
