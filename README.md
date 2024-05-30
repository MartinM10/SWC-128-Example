# Sistema de Gestión de Consumo de Energías Renovables ⚡

## Tabla de Contenidos

- [Introducción a la Seguridad en Web3 🛡️](#introducción-a-la-seguridad-en-web3-️)
- [Requisitos 🛠️](#requisitos-️)
  - [IDE](#ide)
  - [Foundry](#foundry)
  - [Primeros Pasos](#primeros-pasos)
- [Descripción del Smart Contract 📜](#descripción-del-smart-contract-)
  - [Contexto de Aplicación ⚙️](#contexto-de-aplicación-️)
  - [Beneficios 📈](#beneficios-)
  - [Estructura del Smart Contract 🏗️](#estructura-del-smart-contract-️)
  - [Explicación Detallada de las Funciones 🔍](#explicación-detallada-de-las-funciones-)
  - [Diagrama del Smart Contract 📎](#diagrama-del-smart-contract-)
- [Pruebas y Seguridad 🧪](#pruebas-y-seguridad-)
  - [Casos de Prueba 📑](#casos-de-prueba-)
- [Vulnerabilidad Intencional 🚨](#vulnerabilidad-intencional-)
- [Posible Solución ✍️](#posible-solución-️)
  - [Proof Of Concept 🥷](#proof-of-concept-)
- [Conclusión 💭](#conclusión-)
- [Agradecimientos 🧾](#agradecimientos-)

## Introducción a la Seguridad en Web3 🛡️

¡Bienvenido al mundo de Web3! Los contratos inteligentes son la columna vertebral de las aplicaciones descentralizadas, pero _"un gran poder conlleva una gran responsabilidad"_ 🦸. La seguridad en Web3 es fundamental, ya que las vulnerabilidades pueden llevar a pérdidas financieras significativas. Este repositorio muestra un simple contrato inteligente de energía renovable, destacando tanto su funcionalidad como una vulnerabilidad intencional. El objetivo es demostrar la importancia de las prácticas de codificación segura y proporcionar una experiencia práctica en la identificación y mitigación de riesgos de seguridad.

## Requisitos 🛠️

### IDE

Vamos a necesitar un entorno de desarrollo integrado, podemos utilizar cualquier IDE que nos guste, por ejemplo:

- [Visual Studio Code](https://code.visualstudio.com/)

### Foundry

Lo siguiente que necesitamos es instalar un framework de desarrollo para Solidity.

> [!NOTE]
> Puedes utilizar [Remix](https://remix.ethereum.org/), un IDE online para Solidity, pero los tests los tendrías que ejecutar de forma manual. En esta ocasión utilizaremos [Foundry](https://book.getfoundry.sh/) para automatizar los tests.

Foundry está compuesto por cuatro componentes:

> - [**Forge**](https://github.com/foundry-rs/foundry/blob/master/crates/forge): Ethereum Testing Framework
> - [**Cast**](https://github.com/foundry-rs/foundry/blob/master/crates/cast): Una herramienta de línea de comandos para realizar llamadas RPC a Ethereum. Permitiendo interactuar con contratos inteligentes, enviar transacciones o recuperar cualquier tipo de datos de la Blockchain mediante la consola.
> - [**Anvil**](https://github.com/foundry-rs/foundry/blob/master/crates/anvil): Un nodo local de Ethereum, similar a Ganache, el cual es desplegado por defecto durante la ejecución de los tests.
> - [**Chisel**](https://github.com/foundry-rs/foundry/blob/master/crates/chisel): Un REPL de solidity, muy rápido y útil durante el desarrollo de contratos o testing.

**¿Por qué Foundry?**

> - Es el framework más rápido
> - Permite escribir test y scripts en Solidity, minimizando los cambios de contexto
> - Cuenta con muchísimos cheatcodes para testing y debugging

La forma recomendada de instalarlo es mediante la herramienta **foundryup**. A continuación vamos a realizar la instalación paso a paso, pero si quieres realizar una instalación libre de dependencias, puedes seguir las instrucciones de instalación de [este repositorio](https://github.com/hardenerdev/smart-contract-auditor).

#### Instalación

> [!NOTE]
> Si usas Windows, necesitarás instalar y usar [Git BASH](https://gitforwindows.org/) o [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) como terminal, ya que Foundryup no soporta Powershell o Cmd.

En la terminal ejecuta:

```Powershell
curl -L https://foundry.paradigm.xyz | bash
```

Como resultado obtendrás algo parecido a esto:

```shell
consoleDetected your preferred shell is bashrc and added Foundry to Path run:source /home/user/.bashrcStart a new terminal session to use Foundry
```

Ahora simplemente escribe `foundryup` en la terminal y pulsa `Enter`. Esto instalará los cuatro componentes de Foundry: _forge_, _cast_, _anvil_ y _chisel_.

Para confimar la correcta instalación escribe `forge --version`. Deberías de obtener la versión instalada de forge:

```shell
Forge version x.x.x
```

Si no has obtenido la versión, es posible que necesites añadir Foundry a tu PATH. Para ello, puedes ejecutar lo siguiente:

```shell
cd ~echo 'source /home/user/.bashrc' >> ~/.bash_profile
```

Si aún así sigues teniendo problemas con la instalación, puedes seguir las instrucciones de instalación de Foundry en su [repositorio](https://book.getfoundry.sh/getting-started/installation).

Aún así, si no puedes instalar Foundry, no te preocupes, puedes seguir el taller utilizando [Remix](https://remix.ethereum.org/), un IDE online para Solidity.

### Primeros Pasos

Lo primero que vamos a hacer es clonar el repositorio del taller. Para ello, abre una terminal y ejecuta:

```shell
# Clonamos el repo:
https://github.com/MartinM10/SWC-128-Example.git

# Abrimos la carpeta creada
cd SWC-128-Example
```

A continuación instalaremos las dependencias y compilaremos el proyecto para comprobar que todo está correcto.

```shell
# Instalamos las dependencias
forge install foundry-rs/forge-std --no-commit

# Compilamos el proyecto
forge build
```

Con esto ya tendríamos todo lo necesario para ejecutar los tests y probar nuestro smart contract 👍.

## Descripción del Smart Contract 📜

El contrato inteligente [`RenewableEnergy.sol`](src/RenewableEnergy.sol) permite la gestión de transacciones de energía renovable entre productores y consumidores. Este contrato se puede utilizar en una plataforma descentralizada de comercio de energía renovable, facilitando la transferencia segura y transparente de energía y pagos entre los participantes del mercado

### Contexto de Aplicación ⚙️

El RenewableEnergyContract se puede aplicar en el contexto de un mercado de energía descentralizado, donde los productores de energía renovable (como solar o eólica) pueden vender su energía directamente a los consumidores finales. Algunos escenarios específicos incluyen:

1. Mercados de Energía Peer-to-Peer (P2P):

   - Los productores de energía renovable pueden vender directamente a los consumidores locales, eliminando la necesidad de intermediarios y reduciendo costos.

2. Comunidades de Energía:

   - En comunidades locales donde varios hogares producen energía renovable (por ejemplo, a través de paneles solares), el contrato puede facilitar el intercambio y el comercio de energía entre vecinos.

3. Reducción de Huella de Carbono:

   - Al incentivar la producción y el consumo de energía renovable, este tipo de contratos puede contribuir a la reducción de la huella de carbono global.

4. Transparencia y Seguridad:
   - El uso de contratos inteligentes en la blockchain asegura que todas las transacciones sean transparentes, inmutables y seguras, generando confianza entre los participantes del mercado.

### Beneficios 📈

- Transparencia: Todas las transacciones y registros son visibles en la blockchain, proporcionando un alto nivel de transparencia.
- Automatización: El contrato inteligente automatiza la ejecución de transacciones y pagos, reduciendo la necesidad de intervención manual.
- Seguridad: Los pagos se gestionan de manera segura a través del contrato, garantizando que los productores reciban su compensación una vez que se procesa la transacción.
- Descentralización: Elimina la dependencia de intermediarios y autoridades centrales, fomentando un mercado más inclusivo y accesible.

### Estructura del Smart Contract 🏗️

A continuación se muestra una visión general del contrato [`RenewableEnergy.sol`](src/RenewableEnergy.sol):

1. **Variables y Estructuras**:

   - `owner`: Dirección del propietario del contrato.
   - `paused`: Indica si el contrato está pausado.
   - `transactions`: Array de transacciones.
   - `registeredProducers`: Mapa que almacena los productores registrados.
   - `registeredConsumers`: Mapa que almacena los consumidores registrados.
   - `Transaction` struct: Contiene los detalles de cada transacción (productor, consumidor, cantidad, precio, y marca de tiempo).

2. **Funciones**:

   - `constructor()`: Inicializa el contrato y establece al propietario.
   - `registerProducer(address _producer)`: Registra un nuevo productor.
   - `registerConsumer(address _consumer)`: Registra un nuevo consumidor.
   - `addTransaction(address payable _producer, address payable _consumer, uint256 _amount, uint256 _price)`: Añade una nueva transacción entre un productor y un consumidor.
   - `processTransactions()`: Procesa todas las transacciones pendientes y transfiere los pagos correspondientes a los productores.
   - `getTransactionCount()`: Devuelve el número de transacciones registradas.
   - `getTransactionsByConsumer(address _consumer)`: Devuelve todas las transacciones asociadas a un consumidor específico.
   - `pause()`: Pausa el contrato, deteniendo la capacidad de añadir y procesar transacciones.
   - `unpause()`: Reactiva el contrato, permitiendo añadir y procesar transacciones.

### Explicación Detallada de las Funciones 🔍

A continuación se detallan algunas de las funciones más destacables del contrato

#### registerProducer

```solidity
function registerProducer(address _producer) external onlyOwner {
    registeredProducers[_producer] = true;
    emit ProducerRegistered(_producer);
}
```

- Propósito: Registra un nuevo productor de energía. ✅
- Modificadores:
  - onlyOwner: Asegura que solo el propietario del contrato puede registrar productores. ✅

#### registerConsumer

```solidity
function registerConsumer(address _consumer) external onlyOwner {
    registeredConsumers[_consumer] = true;
    emit ConsumerRegistered(_consumer);
}
```

- Propósito: Registra un nuevo consumidor de energía. ✅
- Modificadores:
  - onlyOwner: Asegura que solo el propietario del contrato puede registrar consumidores. ✅

#### addTransaction

```solidity
function addTransaction(address payable _producer, address payable _consumer, uint256 _amount, uint256 _price) external payable onlyWhenNotPaused {
    require(registeredProducers[_producer], "Producer not registered");
    require(registeredConsumers[_consumer], "Consumer not registered");
    require(msg.value >= _amount * _price, "Incorrect payment amount");

    transactions.push(Transaction(_producer, _consumer, _amount, _price, block.timestamp));
    emit TransactionAdded(_producer, _consumer, _amount, _price, block.timestamp);
}
```

- Propósito: Añade una nueva transacción de energía entre un productor y un consumidor. ✅
- Modificadores:
  - onlyWhenNotPaused: Asegura que la función solo se puede ejecutar cuando el contrato no está pausado. ✅

#### processTransactions

```solidity
function processTransactions() external onlyOwner onlyWhenNotPaused {
    for (uint256 i = 0; i < transactions.length; i++) {
        Transaction memory txn = transactions[i];
        require(address(this).balance > txn.amount * txn.price, "Insufficient contract balance");

        // Send the amount to the producer
        txn.producer.transfer(txn.amount * txn.price);

        emit TransactionProcessed(
            txn.producer,
            txn.consumer,
            txn.amount,
            txn.price,
            txn.timestamp
        );
    }
    // delete transactions; // Clear the transactions array
}
```

- Propósito: Procesa todas las transacciones pendientes, transfiriendo fondos a los productores. ✅
- Modificadores:
  - onlyOwner: Asegura que solo el propietario del contrato puede procesar transacciones. ✅
  - onlyWhenNotPaused: Asegura que la función solo se puede ejecutar cuando el contrato no está pausado. ✅

#### getTransactionCount

```solidity
function getTransactionCount() external view returns (uint256) {
    return transactions.length;
}
```

- Propósito: Devuelve el número total de transacciones almacenadas en el contrato. ✅

#### getTransactionsByConsumer

```solidity
function getTransactionsByConsumer(address _consumer) external view returns (Transaction[] memory) {
    uint256 count = 0;
    for (uint256 i = 0; i < transactions.length; i++) {
        if (transactions[i].consumer == _consumer) {
            count++;
        }
    }

    Transaction[] memory result = new Transaction[](count);
    uint256 j = 0;
    for (uint256 i = 0; i < transactions.length; i++) {
        if (transactions[i].consumer == _consumer) {
            result[j] = transactions[i];
            j++;
        }
    }

    return result;
}
```

- Propósito: Devuelve todas las transacciones asociadas a un consumidor específico. ✅

#### pause

```solidity
function pause() external onlyOwner {
    paused = true;
    emit ContractPaused();
}
```

- Propósito: Pausa el contrato, deshabilitando ciertas funciones hasta que se despausa. ✅
- Modificadores:
  - onlyOwner: Asegura que solo el propietario del contrato puede pausar el contrato. ✅

#### unpause

```solidity
function unpause() external onlyOwner {
    paused = false;
    emit ContractUnpaused();
}
```

- Propósito: Despausa el contrato, reanudando la funcionalidad completa. ✅
- Modificadores:
  - onlyOwner: Asegura que solo el propietario del contrato puede despausar el contrato. ✅

### Diagrama del Smart Contract 📎

A continuación se muestra un diagrama que muestra el funcionamiento más destacable del smart contract de manera visual. Generado con [draw.io](https://app.diagrams.net/)

![Diagrama_01](/resources/Diagrama.png)

## Pruebas y Seguridad 🧪

### Casos de Prueba 📑

> [!NOTE]
> Para la ejecución de los test automatizados debes haber realizado previamente los [Primeros Pasos](#primeros-pasos). Una vez hayamos instalado foundry y compilado el proyecto se pueden ejecutar los tests con el siguiente comando

```shell
forge test --match-contract RenewableEnergy
```

Tras ejecutar el comando deberías ver que todos los tests se han pasado correctamente

![TestPassed_01](/resources/TestPassed.png)

> [!WARNING]
> Los tests no son infalibles, y en la mayoría de los casos son escritos por el mismo desarrollador que diseñó el contrato, lo que significa que pueden estar sesgados.

> [!CAUTION]
> Aunque el código pase los tests correctamente y éstos no den ningún tipo de error, ¿Significa que el código es seguro? **NO**

En el contrato [`RenewableEnergyt.sol`](test/RenewableEnergyt.sol) tienes algunos casos de prueba importantes para asegurarte de que el contrato funciona correctamente:

## Tests

1. **testRegisterProducer**: Verifica que se registre correctamente un productor.
2. **testRegisterConsumer**: Verifica que se registre correctamente un consumidor.
3. **testAddTransaction**: Verifica que se agregue correctamente una transacción.
4. **testProcessTransactions**: Verifica que se procesen correctamente las transacciones.
5. **testPauseAndUnpause**: Verifica que se pause y se despause el contrato.
6. **testRegisterProducerRevertIfNotOwner**: Verifica que solo el propietario del contrato pueda registrar un productor.
7. **testRegisterConsumerRevertIfNotOwner**: Verifica que solo el propietario del contrato pueda registrar un consumidor.
8. **testAddTransactionRevertIfProducerNotRegistered**: Verifica que no se pueda añadir una transacción si el productor no está registrado.
9. **testAddTransactionRevertIfConsumerNotRegistered**: Verifica que no se pueda añadir una transacción si el consumidor no está registrado.
10. **testAddTransactionRevertIfIncorrectPaymentAmount**: Verifica que la transacción falle si el monto del pago es incorrecto.
11. **testPauseRevertIfNotOwner**: Verifica que solo el propietario del contrato pueda pausar el contrato.
12. **testUnpauseRevertIfNotOwner**: Verifica que solo el propietario del contrato pueda despausar el contrato.

```solidity
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
```

## Vulnerabilidad Intencional 🚨

> [!WARNING]
> SPOILER: La vulnerabilidad se encuentra en la función processTransactions. Antes de seguir leyendo, te invito a que la encuentres y razones. ¿Qué consecuencias puede tener esta posible vulnerabilidad?

> [!NOTE]
> La función processTransactions tiene una posible vulnerabilidad de denegación de servicio (DoS) por agotamiento de gas. Al iterar sobre el array de transacciones, si el número de transacciones es muy grande, el gas necesario para procesarlas todas puede exceder el límite de gas por bloque, haciendo imposible que la función se ejecute completamente. Esta vulnerabilidad puede hacer que sea imposible procesar las transacciones acumuladas, bloqueando el sistema. Se incluyó esta vulnerabilidad para demostrar la importancia de revisar y optimizar la lógica de iteración en contratos inteligentes para evitar ataques de denegación de servicio.

> En este caso no tiene por qué ser un ataque en sí el que explote la vulnearbilidad, ya que no es necesario que un usuario malintencionado genere y añada transacciones de manera fraudulenta mediante la función `addTransaction`. Esta función requiere que el consumidor envíe al contrato la cantidad de ether necesario para cubrir los gastos (amount \* price) de energía, con lo cual es comprensible que el atacante no esté especialmente interesado (aunque podría estarlo) en ejecutar muchas veces esta función y gastar ethers para añadir transacciones hasta llegar al punto en el que la función `processTransactions` quede inutilizada y por consecuente el contrato. No es necesario que aparezca la figura de un atacante en este contrato, ya que bastaría con usar el contrato legítimamente para que este en algún momento colapse debido a que las transacciones serián demasiadas como para procesarlas, siendo el gas necesario mayor que el límite de gas por bloque de la red de ethereum.

```solidity
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
```

### Proof of Concept 🥷

Para este repositorio se ha desarrollado un Smart Contract como prueba de concepto para explotar la vulnerabilidad mencionada anteriormente. La idea es simular a través de un test similar a los vistos en [los casos de prueba](#casos-de-prueba-), que un atacante se aprovecha de este posible fallo de seguridad y consigue inutilizar una función muy importante del contrato.

El contrato [ProofOfConcept.t.sol](/test/ProofOfConcept.t.sol) tiene todo lo necesario para llevar ejecutar el exploit.

> Para ejecutar el exploit debes usar el siguiente comando

```shell
 forge test --match-contract ProofOfConcept -vvvv --block-gas-limit 30000000
```

> El argumento `--match-contract` nos permite indicar que solo queremos ejecutar el contrato `ProofOfConcept` y el argumento `-vvvv` nos activa el modo `verbose` en la ejecución de `forge test`, de esta manera nos dará las trazas con más información para saber por dónde va la ejecución y qué está ocurriendo con más detalle.

Tras la ejecución del comando deberías ver algo como esto:

![ExploitImage](/resources/ExploitRenewableEnergy.png)

> Donde se puede observar que:
>
> - Inicialmente:
>   - Se registra al consumidor y al productor de energía.
>   - Se añaden 10 transacciones entre el consumidor y el productor.
>   - El contrato del balance es 11 (10 ethers por las transacciones añadidas + 1 ether añadido al balance manualmente para que el contrato tenga más fondos de los que necesitará a la hora de hacer los pagos)
> - Tras ejecutar el exploit e intentar procesar las transacciones con un límite de gas (simulando que en algún momento el límite de gas por bloque será < gas necesario para ejecutar toda la función:
>   - La función devuelve un revert indicando Out Of Gas y las transacciones no se procesan.

## Posible solución ✍️

Para este tipo de vulnerabilidades se pueden proponer varias soluciones, aunque no todas son lo **suficientemente buenas**. Una podría ser procesar las _transacciones por lotes_, otra podría ser modificar la lógica del contrato y que en lugar de utilizar un array _se utilice la estructura `mapping`_, característica de solidity.

Si observamos detenidamente el contrato inteligente podemos apreciar que no se cumple el patrón Pull over Push ([para saber más](https://blockchain-academy.hs-mittweida.de/courses/solidity-coding-beginners-to-intermediate/lessons/solidity-11-coding-patterns/topic/pull-over-push/)). Este patrón recomienda que en lugar de que el contrato envíe automáticamente los pagos a los productores, se debería permitir que los productores retiren sus pagos ellos mismos. Esto tiene varias ventajas, entre ellas evitar problemas de gas y mejorar la seguridad del contrato.

Debido a la vulnerabilidad actual, puede suceder que no se puedan realizar los pagos a los productores de energía si el gas se agota, y llegará un punto en que lo hará porque el gas necesario será mayor que el gas límite por bloque. En cambio, si usamos el patrón Pull over Push y modificamos un poco la lógica del contrato, no debería existir este problema y esta vulnerabilidad, ya que no sería necesario recorrer todo el array para hacerle los pagos a los productores. Además, no sería necesario que una función haga todos los pagos, sino que cada productor podría cobrar por separado, llamando a una función específica para cobrar.

En este repositorio se proporciona el código del smart contract con la posible solución mencionada (Pull Over Push + modificación de la lógica del contrato) [RenewableEnergySolution.sol](src/RenewableEnergySolution.sol)

> [!TIP]
> Hay que intentar evitar los arrays en los Smart Contracts ya que pueden provocar un consumo de gas excesivo o incluso inviable.

## Conclusión 💭

El objetivo principal de este repositorio ha sido mostrar una posible vulnerabilidad en Smart Contracts, concreamente generar un ejemplo para la vulnerabilidad [SWC-128](https://swcregistry.io/docs/SWC-128/) con fines educativos. Es importante este tipo de actividades para atraer desarolladores del mundo web2 y remarcarles que deben tener precaución a la hora de desarrollar smart contracts, ya que un simple despiste puede provocar una gran pérdida de fondos o totalidad de los mismos.

En resumen:

- Hemos estudiado el contrato inteligente.
- Lo hemos analizado en busca de vulnerabilidades, y hemos encontrado una.
- Hemos realizado un ataque para comprobar que la vulnerabilidad es real.

Este es el proceso que sigue un auditor de contratos inteligentes. Interpreta y analiza el contrato en busca de vulnerabilidades, y si encuentra alguna, realiza una prueba de concepto para comprobar que es real.

Espero que hayas disfrutado del taller, y que hayas aprendido algo nuevo. Si tienes cualquier duda o sugerencia, no dudes en abrir un issue en el repositorio. Si quieres ver otra vulnerabilidad te dejo otro repositorio desarrollado con el mismo fin y siguiendo la misma metodología. 

[VulnerableLottery](https://github.com/MartinM10/VulnerableLottery)

## Agradecimientos 🧾

Quiero agradecer a por los conocimientos que me proporcionaron y por la plantilla de guía que me brindaron en el repositorio [HackerWeekX-Web3-workshop](https://github.com/Marcolopeez/HackerWeekX-Web3-workshop.git)

- 🦸 @Marcolopeez 📖 [Perfil de Github](https://github.com/Marcolopeez)
- 🦸 @jcsec-security 📖 [Perfil de Github](https://github.com/jcsec-security)
