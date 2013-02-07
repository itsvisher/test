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


# StarScriber: ParadigmModules v 1.0.0

### Introduction

ParadigmModules is a module which serves as a load balancer between
Probe Servers and the clients which require the data from servers.

### Requirements

JDK 1.7.0_07 is used in this module, but JDK 1.6.x can also be used.
There are some third party JARs used which are added as dependency in
POM.xml file.

Maven 2.x is used to build and run the project.

### JARs / Dependencies Used

Logback 1.0.1<br/>
SLF4J API 1.7.1<br/>
JavaMail API 1.4.5<br/>
SnakeYAML 1.10<br/>
Google Protocol Buffers 2.4.1

### Configure options

Dummy Probe Servers are written and their configuration information such as
PORT, HOST and CSV PATH are to be written in:

    [root]/conf/config.properties
    
file. Here are the steps for configuring module -

Assume your dummy server runs on IP1 and PORT1, MB (MessageBroker) runs on IP2 and PORT2 and dummy clients runs on some different IP (IP and PORT doesn't matters for client).

<b>Dummy Server -</b>

* On machine which runs dummy server, change the CSV path (csv.path key) in config.properties file which it will look for.
* Also change the dummy server port (probe.server.port key) on which the server will listen.

<b>MB (MessageBroker) -</b>

* On machine which runs MB, add the IP1 and PORT1 in server-ips.yaml file. It takes the IP and Ports in following format -
    * - {IP1: PORT1, IP2: PORT2} where IP1 and IP2 are Primary and Backup IPs and PORT1 and PORT2 are Primary and Backup ports. You can add backup IP and port as well if you have a backup dummy server running too.
* MB also registers the clients with it, so change the registration server port (reg.server.port key) in config.properties on which it will listen for client connections.

<b>Dummy Client -</b>

* On machine which runs dummy client, change the registration server host and port (reg.server.host and reg.server.port keys) in config.properties file to which the clients will connect to.

Also, no. of IPs to connect are to be read from a YAML file and is mentioned in:

    src/com/starscriber/snowball/server-ips.yaml

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

mvn install

This generates the project JAR file as: ParadigmModules-x.x.x-SNAPSHOT.jar and ProbeTrafficDistributor.jar.

### To run

    java -Dlogback.configurationFile=conf/logback.xml -Dconf.path=conf/config.properties -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.Main

If the probe servers and clients are not already written, following classes can be run
manually to make the project work:

src/com/starscriber/snowball/simulator/DataSourceServer - Dummy Probe Server<br/>
src/com/starscriber/snowball/simulator/DataSinkClient - Dummy client

In order to run these, following execution commands can be used -

For dummy server:

    java -Dlogback.configurationFile=conf/logback.xml -Dconf.path=conf/config.properties -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSourceServer

For dummy client:

    java -Dlogback.configurationFile=conf/logback.xml -Dconf.path=conf/config.properties -cp target/ProbeTrafficDistributor.jar com.starscriber.smg3.ptd.simulator.DataSinkClient
