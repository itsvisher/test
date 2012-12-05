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