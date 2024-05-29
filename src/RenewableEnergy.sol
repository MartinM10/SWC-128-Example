// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract RenewableEnergyContract {
    struct Transaction {
        address payable producer;
        address consumer;
        uint amount;
        uint price;
        uint timestamp;
        bool isPaid;
        uint paidTimestamp;
    }

    address public owner;
    Transaction[] public transactions;
    mapping(address => bool) public registeredProducers;
    mapping(address => bool) public registeredConsumers;
    bool public paused;

    event TransactionAdded(
        address indexed producer,
        address indexed consumer,
        uint256 amount,
        uint256 price,
        uint256 timestamp,
        bool isPaid,
        uint256 paidTimestamp
    );

    event TransactionProcessed(
        address indexed producer,
        address indexed consumer,
        uint amount,
        uint price,
        uint timestamp,
        bool isPaid,
        uint256 paidTimestamp
    );

    event ProducerRegistered(address indexed producer);
    event ConsumerRegistered(address indexed consumer);
    event ContractPaused();
    event ContractUnpaused();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyWhenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    modifier onlyWhenPaused() {
        require(paused, "Contract is not paused");
        _;
    }

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    function registerProducer(address _producer) external onlyOwner {
        registeredProducers[_producer] = true;
        emit ProducerRegistered(_producer);
    }

    function registerConsumer(address _consumer) external onlyOwner {
        registeredConsumers[_consumer] = true;
        emit ConsumerRegistered(_consumer);
    }

    function addTransaction(
        address payable _producer,
        address payable _consumer,
        uint256 _amount,
        uint256 _price
    ) external payable onlyWhenNotPaused {
        require(registeredProducers[_producer], "Producer not registered");
        require(registeredConsumers[_consumer], "Consumer not registered");
        require(msg.value >= _amount * _price, "Incorrect payment amount");

        transactions.push(
            Transaction(
                _producer,
                _consumer,
                _amount,
                _price,
                block.timestamp,
                false,
                0
            )
        );
        emit TransactionAdded(
            _producer,
            _consumer,
            _amount,
            _price,
            block.timestamp,
            false,
            0
        );
    }

    function processTransactions() public onlyOwner {
        for (uint i = 0; i < transactions.length; i++) {
            Transaction storage txn = transactions[i];
            if (!txn.isPaid) {
                txn.isPaid = true;
                txn.paidTimestamp = block.timestamp;

                (bool success, ) = txn.producer.call{value: txn.amount}("");
                require(success, "Transfer failed.");

                emit TransactionProcessed(
                    txn.producer,
                    txn.consumer,
                    txn.amount,
                    txn.price,
                    txn.timestamp,
                    txn.isPaid,
                    txn.paidTimestamp
                );
            }
        }
    }

    // Function to get the total number of transactions
    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }

    function pause() external onlyOwner onlyWhenNotPaused {
        paused = true;
        emit ContractPaused();
    }

    function unpause() external onlyOwner onlyWhenPaused {
        paused = false;
        emit ContractUnpaused();
    }
}
