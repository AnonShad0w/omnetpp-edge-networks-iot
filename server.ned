simple Server
{
    parameters:
        double processingTime @unit(s) @prompt("Time to process a query") = default(0.2s);
    	@display("i=device/server");
    gates:
        inout port[2];
}