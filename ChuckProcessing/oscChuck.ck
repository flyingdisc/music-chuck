// oscChuck.ck
// @soesilo wijono
// a very basic example of communication from/to Processing

// http://chuck.cs.princeton.edu/doc/examples/osc/OSC_send.ck
// http://chuck.cs.princeton.edu/doc/examples/osc/OSC_recv.ck
// http://chuck.cs.princeton.edu/doc/examples/osc/OSC_xmit.ck
// http://chuck.cs.princeton.edu/doc/examples/osc/s.ck
// http://chuck.cs.princeton.edu/doc/examples/osc/r.ck

// OSC sender
OscSend xmit;
"localhost" => string hostname;
6450 => int sendport;
xmit.setHost( hostname, sendport );

// OSC receiver
OscRecv recv;
6449 => recv.port;

// listening to receiver port
recv.listen();
// expected event "/hello", tag type string
recv.event("/hello, s") @=> OscEvent @ evtHello;
// concurrent shred
spork ~ listenHello();

0 => int cnt;  // a counter just for fun

// main loop
while( true )
{
    // send counter as float every 1 second
    xmit.startMsg( "/count", "f" );
    cnt++ => xmit.addFloat; 
    1::second => now;
}

// "/hello" listener
fun void listenHello()
{
    while(true) {
        evtHello => now;

        // get message if any
        if ( evtHello.nextMsg() != 0 )  
        { 
            evtHello.getString() => string mesg;
            <<< "Mesg:", mesg >>>;
        }
    }
}