simple Switch
{
    parameters:
        double pkRate;
        int queueMaxLen;
        @display("i=device/switch;q=queue");
    gates:
        inout port[];
}


