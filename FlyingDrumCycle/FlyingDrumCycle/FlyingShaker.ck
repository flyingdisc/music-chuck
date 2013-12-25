// @Soesilo Wijono
// FlyingShaker.ck
// Assignment_7_Flying_DrumCycles
// This is the second composition file 
//    to play shakers STK instrument

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// note: the MIDI C Ionian mode is declared 
// ... in ChannelShaker class (FlyingShakeClass.ck)

// object of BPM class
FlyingBPM tempo;

// instantiate object of ChannelShaker class (FlyingShakeClass.ck)
ChannelShaker cs;

// create a Shaker STK instrument on channel 3
// by calling ChannelShaker object's function, preset=20 (Big Rocks)
cs.createChannel(3, 20, 1.0, 40.0, 80.0, 0.4, 1.0);

// initial values of timing for channel's first notes
cs.setNewDuration();

playShaker();

// function to play shaker notes
fun void playShaker()
{
    //------ loop over all notes ---------
    while (true) 
    {
        // call ChannelShaker object's play method
        cs.playInstrument();
        
        // ------ if time >= 30 seconds then break ---------
        if ( now >= later30 ) 
            break;
    
        // advance time by sixyfourth duration
        tempo.quarterNote/16 => now;
    }
}
