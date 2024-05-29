// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract RenewableEnergyContract {
    struct Transaction {
        address producer;
        address consumer;
        uint256 amount;
        uint256 price;
        uint256 timestamp;
    }

    address public owner;
    mapping(address => bool) public producers;
    mapping(address => bool) public consumers;
    mapping(address => uint256) public balances;
    mapping(uint256 => Transaction) public transactions;
    uint256 public transactionCount;

    bool public paused;

    event TransactionAdded(
        address indexed producer,
        address indexed consumer,
        uint256 amount,
        uint256 price,
        uint256 timestamp
    );
    event TransactionProcessed(
        address indexed producer,
        address indexed consumer,
        uint256 amount,
        uint256 price,
        uint256 timestamp
    );
    event Withdrawal(address indexed producer, uint256 amount);
    event Paused(address account);
    event Unpaused(address account);

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
    }

    function registerProducer(address payable _producer) public {
        producers[_producer] = true;
    }

    function registerConsumer(address _consumer) public {
        consumers[_consumer] = true;
    }

    function addTransaction(
        address _producer,
        address _consumer,
        uint256 _amount,
        uint256 _price
    ) public payable onlyWhenNotPaused {
        require(producers[_producer], "Producer not registered.");
        require(consumers[_consumer], "Consumer not registered.");
        require(msg.value == _amount, "Incorrect amount sent.");

        transactions[transactionCount] = Transaction({
            producer: _producer,
            consumer: _consumer,
            amount: _amount,
            price: _price,
            timestamp: block.timestamp
        });

        balances[_producer] += _amount;
        emit TransactionAdded(
            _producer,
            _consumer,
            _amount,
            _price,
            block.timestamp
        );
        transactionCount++;
    }

    function withdraw() public onlyWhenNotPaused {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw.");
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");

        emit Withdrawal(msg.sender, amount);
    }

    function getTransactionCount() public view returns (uint256) {
        return transactionCount;
    }

    function pause() public onlyOwner onlyWhenNotPaused {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner onlyWhenPaused {
        paused = false;
        emit Unpaused(msg.sender);
    }
}
