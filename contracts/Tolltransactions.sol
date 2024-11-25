// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TollTransactions {
    // Struct to store transaction details
    struct Transaction {
        uint256 id;
        address userPublicKey;
        address tollBoothPublicKey;
        uint256 amount;
    }

    // Mapping to store transactions by their ID
    mapping(uint256 => Transaction) public transactions;

    // Event to log transaction details
    event TransactionCompleted(
        uint256 indexed id,
        address indexed userPublicKey,
        address indexed tollBoothPublicKey,
        uint256 amount
    );

    // Function to facilitate a transaction
    function makeTransaction(
        uint256 _id,
        address _userPublicKey,
        address _tollBoothPublicKey,
        uint256 _amount
    ) public payable {
        require(msg.value == _amount, "Incorrect amount sent.");
        require(transactions[_id].id == 0, "Transaction ID already exists.");

        // Record the transaction details
        transactions[_id] = Transaction({
            id: _id,
            userPublicKey: _userPublicKey,
            tollBoothPublicKey: _tollBoothPublicKey,
            amount: _amount
        });

        // Transfer the amount to the toll booth
        payable(_tollBoothPublicKey).transfer(_amount);

        // Emit an event for logging
        emit TransactionCompleted(_id, _userPublicKey, _tollBoothPublicKey, _amount);
    }

    // Function to fetch transaction details by ID
    function getTransaction(uint256 _id)
        public
        view
        returns (
            uint256 id,
            address userPublicKey,
            address tollBoothPublicKey,
            uint256 amount
        )
    {
        Transaction memory txn = transactions[_id];
        require(txn.id != 0, "Transaction not found.");
        return (txn.id, txn.userPublicKey, txn.tollBoothPublicKey, txn.amount);
    }
}
