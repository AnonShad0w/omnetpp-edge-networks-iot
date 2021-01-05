network binary_tree
{
    parameters:
        // Change number of nodes here
        int numEndNodes1 = default(3);
        int numEndNodes2 = default(3);
        int numSwitches = default(2);
    types:
        channel endpoint extends ned.DatarateChannel
        {
            delay = 100ms;
        }
        channel eth extends ned.DatarateChannel
        {
            datarate = 100Gbps;
        }
    submodules:
        iot_device1[numEndNodes1]: Client {
            parameters:
                timeout = 5s;
        }
        iot_device2[numEndNodes2]: Client {
            parameters:
                timeout = 5s;
        }
        edge_switch[numSwitches]: Switch {
            parameters:
                pkRate = 1.5*numEndNodes1; // pkRate should be >= numClients, otherwise switch will become the bottleneck
                queueMaxLen = 20; // buffer max 20 packets
            gates:
                port[numEndNodes1+1];
        }
        edge_server: Server {
            parameters:
            	@display("p=261,40");
        }
    connections:
        for i=0..numEndNodes1-1 {
            iot_device1[i].port <--> endpoint <--> edge_switch[0].port[i];
        }
		for i=0..numEndNodes2-1 {
            iot_device2[i].port <--> endpoint <--> edge_switch[1].port[i];
        }
        edge_server.port[0] <--> eth <--> edge_switch[0].port[numEndNodes1];
        edge_server.port[1] <--> eth <--> edge_switch[1].port[numEndNodes1]; 
}
