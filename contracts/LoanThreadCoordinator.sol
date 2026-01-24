// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunicationsTool {
    // Enum for message types in the lending workflow
    enum MessageType {
        REQUEST,
        RISK_RESULT,
        PROOF,
        APPROVAL,
        REJECTION,
        RISK_REQUESTED,
        RISK_EVALUATED
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
            sequenceNumber: 0, // initial sequence number for the thread
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId] = 1; // increment sequence number for the thread
    }

    // Function to send a message to a thread
    function requestRiskEvaluation(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.RISK_REQUESTED,
            ciphertextURI: "",
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
    }

    // Function to receive a message from a thread
    function receiveRiskEvaluation(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.RISK_EVALUATED,
            ciphertextURI: "",
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
    }

    // Function to send a proof to a thread for risk evaluation
    function sendProof(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.PROOF,
            ciphertextURI: "",
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        }));

    // Function to receive approval for the loan
    function approveLoan(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.APPROVAL,
            ciphertextURI: "",
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
    }

    // Function to reject the loan
    function rejectLoan(bytes32 threadId) public {
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.REJECTION,
            ciphertextURI: "",
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
    }

    // Function to get the thread actions for a thread
    function getThreadActions(bytes32 threadId) public view returns (ThreadAction[] memory) {
        return threadActions[threadId];
}
