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

    // Function to send a message to a chat room 
    function sendMessage(bytes32 threadId, MessageType messageType, string memory ciphertextURI) public {
        ThreadAction memory newAction = ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: messageType,
            ciphertextURI: ciphertextURI,
            sequenceNumber: sequenceNumbers[threadId],
            timestamp: block.timestamp
        });
    }
    // Function to collect and share findings (basic implementation)
    function shareFindings(string memory data) public {
        // In a more advanced implementation, this function would interact with other storage
        // and smart contract systems to collect, organize, and share findings.
        emit MessageSent("findings", msg.sender, data, block.timestamp);
    }
}
