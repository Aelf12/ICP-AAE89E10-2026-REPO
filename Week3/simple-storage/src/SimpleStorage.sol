// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleStorage {
    string private s_message;
    address public immutable i_owner;

    error SimpleStorage__NotOwner();

    event MessageUpdated(string newMessage, address indexed updater);

    constructor(string memory initialMessage) {
        s_message = initialMessage;
        i_owner = msg.sender;
    }

    function updateMessage(string calldata newMessage) external {
        if (msg.sender != i_owner) revert SimpleStorage__NotOwner();
        s_message = newMessage;
        emit MessageUpdated(newMessage, msg.sender);
    }

    function getMessage() external view returns (string memory) {
        return s_message;
    }
}