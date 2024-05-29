// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/RenewableEnergy.sol";

contract RenewableEnergyContractTest is Test {
    RenewableEnergyContract contractInstance;
    address public owner;
    address payable public consumer;
    address payable public producer;

    function setUp() public {
        contractInstance = new RenewableEnergyContract();
        owner = address(this);
        producer = payable(vm.addr(10));
        consumer = payable(vm.addr(20));
    }

    function testRegisterProducer() public {
        contractInstance.registerProducer(producer);
        bool registered = contractInstance.registeredProducers(producer);
        assertTrue(registered, "Producer should be registered");
    }

    function testRegisterConsumer() public {
        contractInstance.registerConsumer(consumer);
        bool registered = contractInstance.registeredConsumers(consumer);
        assertTrue(registered, "Consumer should be registered");
    }

    function testAddTransaction() public {
        // Register producer and consumer
        contractInstance.registerProducer(producer);
        contractInstance.registerConsumer(consumer);

        // Add transaction
        uint256 amount = 1 ether;
        uint256 price = 1;
        contractInstance.addTransaction{value: amount * price}(
            producer,
            payable(consumer),
            amount,
            price
        );

        vm.assertEq(
            contractInstance.getTransactionCount(),
            1,
            "Transaction not saved"
        );
    }

    function testProcessTransactions() public {
        // Register producer and consumer
        contractInstance.registerProducer(producer);
        contractInstance.registerConsumer(consumer);

        // Add transaction
        uint256 amount = 1 ether;
        uint256 price = 1;
        contractInstance.addTransaction{value: amount * price}(
            producer,
            consumer,
            amount,
            price
        );

        // Process transactions
        uint256 initialProducerBalance = producer.balance;
        uint256 initialContractBalance = address(contractInstance).balance;
        contractInstance.processTransactions();
        uint256 finalProducerBalance = producer.balance;
        uint256 finalContractBalance = address(contractInstance).balance;

        // Assert balances updated correctly
        assertEq(
            finalProducerBalance,
            initialProducerBalance + amount,
            "Producer balance should increase by transaction amount"
        );
        assertEq(
            finalContractBalance,
            initialContractBalance - amount,
            "Contract balance should decrease by transaction amount"
        );
    }

    function testPauseAndUnpause() public {
        // Pause contract
        contractInstance.pause();
        assertTrue(contractInstance.paused(), "Contract should be paused");

        // Unpause contract
        contractInstance.unpause();
        assertFalse(contractInstance.paused(), "Contract should be unpaused");
    }

    function testRegisterProducerRevertIfNotOwner() public {
        vm.startPrank(consumer);

        // Expect revert since only owner can call this function
        vm.expectRevert("Only owner can call this function");
        contractInstance.registerProducer(producer);
    }

    function testRegisterConsumerRevertIfNotOwner() public {
        vm.startPrank(consumer);

        // Expect revert since only owner can call this function
        vm.expectRevert("Only owner can call this function");
        contractInstance.registerConsumer(consumer);
    }

    function testAddTransactionRevertIfProducerNotRegistered() public {
        // Expect revert since producer is not registered
        vm.expectRevert("Producer not registered");
        contractInstance.addTransaction{value: 1 ether}(
            producer,
            consumer,
            1 ether,
            1
        );
    }

    function testAddTransactionRevertIfConsumerNotRegistered() public {
        // Register producer
        contractInstance.registerProducer(producer);

        // Expect revert since consumer is not registered
        vm.expectRevert("Consumer not registered");
        contractInstance.addTransaction{value: 1 ether}(
            producer,
            consumer,
            1 ether,
            1
        );
    }

    function testAddTransactionRevertIfIncorrectPaymentAmount() public {
        // Register producer and consumer
        contractInstance.registerProducer(producer);
        contractInstance.registerConsumer(consumer);

        // Expect revert since payment amount is incorrect
        vm.expectRevert("Incorrect payment amount");
        contractInstance.addTransaction{value: 0 ether}(
            producer,
            consumer,
            1 ether,
            1
        );
    }

    function testPauseRevertIfNotOwner() public {
        vm.startPrank(consumer);

        // Expect revert since only owner can call this function
        vm.expectRevert("Only owner can call this function");
        contractInstance.pause();
    }

    function testUnpauseRevertIfNotOwner() public {
        vm.startPrank(consumer);

        // Expect revert since only owner can call this function
        vm.expectRevert("Only owner can call this function");
        contractInstance.unpause();
    }
}
