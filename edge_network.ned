network small_edge_fog
{
    parameters:
        // Change number of nodes here
        int numEndNodes = default(3);
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
        iot_device[numEndNodes]: Client {
            parameters:
                timeout = 5s;
        }
        edge_switch: Switch {
            parameters:
                pkRate = 1.5*numEndNodes; // pkRate should be >= numClients, otherwise switch will become the bottleneck
                queueMaxLen = 20; // buffer max 20 packets
            gates:
                port[numEndNodes+1];
        }
        edge_server: Server {
            parameters:
            	@display("p=261,40");
        }
    connections:
        for i=0..numEndNodes-1 {
            iot_device[i].port <--> endpoint <--> edge_switch.port[i];
        }

        edge_server.port[0] <--> eth <--> edge_switch.port[numEndNodes];            
}
