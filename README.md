The current configuration is:

logback.xml is present in the project class path, i.e., src/logback.xml.

    .
    |-- ... (other files/folders)
    |-- src
        |-- com
        |   `-- ... (other files/folders)
        `-- logback.xml

I kept it at this location as per the rule given at: http://logback.qos.ch/manual/configuration.html.

I tried making a conf folder in the same level where src lies:

    .
    |-- ... (other files/folders)
    |-- conf
        |-- logback.xml
    |-- src
        |-- com
        |   `-- ... (other files/folders)

But the its not able to find logback.xml directly. Its using the basic configurator by default. In order to use the logback.xml placed in the new conf folder, I need to use the following command to execute any main class:

java -Dlogback.configurationFile=conf/logback.xml -cp target/MessageBroker.jar com.starscriber.snowball.simulator.DataSourceServer

instead of this:

java -cp target/MessageBroker.jar com.starscriber.snowball.simulator.DataSourceServer

Is it OK for you?

Tree

    .
    |-- conf
    |   |-- config.properties
    |   `-- logback.xml
    |-- pom.xml
    |-- README.md
    |-- src
    |   `-- com
    |       `-- starscriber
    |           `-- snowball
    |               |-- consumer
    |               |   |-- Client.java
    |               |   |-- Distributor.java
    |               |   |-- OOBReader.java
    |               |   `-- PacketWriter.java
    |               |-- loadbalancingrules
    |               |   |-- RoundRobinImpl.java
    |               |   `-- Rule.java
    |               |-- logger
    |               |   `-- ProbeLogger.java
    |               |-- producer
    |               |   `-- ServerConnectionHandler.java
    |               |-- simulator
    |               |   |-- DataSinkClient.java
    |               |   `-- DataSourceServer.java
    |               `-- util
    |               |   `-- ProjectProperties.java
    |               |-- MessageBroker.java
    |               |-- server-ips.yaml
    
Adding more data for further types in markdown format:



# Demo: SMGProbeTrafficDistributor v 1.0.0

### Introduction

SMGProbeTrafficDistributor is a module which serves as a load balancer between Probe Servers and the clients which require the data from servers.

### Requirements

JDK 1.7.0_07 is used in this module, but JDK 1.6.x can also be used.
There are some third party JARs used which are added as dependency in
POM.xml file.

Maven 2.x is used to build and run the project.

### JARs / Dependencies Used

* Logback 1.0.1<br/>
* SLF4J API 1.7.1<br/>
* JavaMail API 1.4.5<br/>
* SnakeYAML 1.10<br/>
* Google Protocol Buffers 2.4.1<br/>
* JUnit 4.11

### Plugins Used

Apart from default maven compile and install plugin, a git plugin is used to get git information about the current build during runtime.

* git-commit-id-plugin 2.1.4 (Source: https://github.com/ktoso/maven-git-commit-id-plugin)

### YAML File format

IPs to connect are to be read from a YAML file and is mentioned in:

    src/com/starscriber/smg3/ptd/server-ips.yaml

file.

Every IP should be written in a new line in format "<b>- {IP1: PORT1, IP2: PORT2}</b>", where IP1 and IP2 are Primary and Backup IPs or Hosts and PORT1 and PORT2 are Primary and Backup ports. The number of IPs 
to connect written in this file should match the value of name property - "server.ips" 
in config.properties.

### Logs

SLF4J has been used for logging purpose. The log coniguration can be seen in:

    [root]/conf/logback.xml
    
The client logs go to the client.log file.

### To build

mvn compile

### To install

mvn -Dlogback.configurationFile=conf/logback.xml  install

### To test

mvn -Dlogback.configurationFile=conf/logback.xml  test

This generates the project JAR file as: SMGProbeTrafficDistributor-x.x.x-SNAPSHOT.jar and ProbeTrafficDistributor.jar.

### Runtime Arguments

<b>Dummy Server -</b>

Arguments accepted:

* PORT (on which Server will run).
* Data file path (CSV data file which server will read).

Order of runtime arguments:

* Argument1 -> Server PORT1 (example: 9090)
* Argument2 -> CSV File location (example: /home/root/data.csv)

Default values:

* If nothing is passed, it will take the default values initialized within the program as -
 * PORT: "9090"
 * CSV file location: "conf/sample.csv".

<b>PTD (ProbeTrafficDistributor) -</b>

Arguments accepted:

* PORT (on which Registration Server will run to accept clients).
* TPS threshold (no. of transactions for which throughput should be calculated.)
* No. of servers to connect.

Order of runtime arguments:

* Argument1 -> Registration Server PORT1 (example: 9091)
* Argument2 -> TPS Number (example: 1000000 - no. of packets to check throughput for).
* Argument3 -> No. of servers to connect (example: 5)

Default values:

* If nothing is passed, it will take the default values initialized within the program as -
 * Reg PORT: 9091
 * Default TPS to check for: 1000000
 * Default no. of servers to connect: 5

<b>Dummy Client -</b>

Arguments accepted:

* HOST (on which PTD will host to).
* PORT (on which PTD will listen to).

Order of runtime arguments:

* Argument1 -> PTD Registration Server HOST (example: localhost)
* Argument2 -> PTD Registration Server PORT (example: 9091).

Default values:

* HOST and PORT information of PTD for client is mandatory. No default values.

### To run

<b>PTD:</b>

1. Without any runtime arguments

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.Main
    
2. Giving registration server port information as a runtime argument

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.Main 9091

3. Giving registration server port and tps threshold (no. of transactions for which throughput should be calculated) informations as a runtime arguments

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.Main 9091 1000000

4. Giving registration server port and tps threshold (no. of transactions for which throughput should be calculated) and no. of servers to connect to informations as a runtime arguments

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.Main 9091 1000000 1

If the probe servers and clients are not already written, following classes can be run manually to make the project work:

src/com/starscriber/smg3/ptd/simulator/DataSourceServer - Dummy Probe Server<br/>
src/com/starscriber/smg3/ptd/simulator/DataSinkClient - Dummy client

In order to run these, following execution commands can be used -

<b>Dummy server:</b>

1. Without any runtime arguments

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSourceServer

2. Giving port number as the runtime argument

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSourceServer 9090

3. Giving port number and data file location as the runtime arguments

        java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSourceServer 9090 conf/sample.csv

<b>Dummy client:</b>

    java -Dlogback.configurationFile=conf/logback.xml -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSinkClient
