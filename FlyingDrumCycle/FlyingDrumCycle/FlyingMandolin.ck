// FlyingMandolin.ck
// Assignment_7_Flying_DrumCycles
// This is the first composition file 
//   to play mandolin STK instruments

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// note: the MIDI C Ionian mode is declared 
//   in ChannelMandolin class (FlyingMandoClass.ck)

// object of BPM class
FlyingBPM tempo;

// instantiate two objects of ChannelMandolin class (FlyingMandoClass.ck)
ChannelMandolin cm1;
ChannelMandolin cm2;

// by calling ChannelMandolin objects' function, 
// create a mandolin STK instrument on channel 2
cm1.createChannel(2, 0.5, 0.3, 0.6, 0.04, 0.08, 0.5, 0.8);
// create a mandolin STK instrument on channel 1
cm2.createChannel(1, 0.4, 0.1, 0.4, 0.02, 0.05, 0.1, 0.4);

// initial values of timing for channels' first notes
cm1.setNewDuration();
cm2.setNewDuration();

// ---------- spork to call functions concurrently ---------
spork ~ playMandolin1();
spork ~ playMandolin2();

// keep parent alive
while (true) tempo.quarterNote/16 => now;

// function to play first mandolin notes
fun void playMandolin1()
{
    //------ loop over all notes ---------
    while (true) 
    {
        // call ChannelMandolin object's play method
        cm1.playInstrument();  
        
        // ------ if time >= 30 seconds then break ---------
        if ( now >= later30 ) 
            break;
    
        // advance time by unit quarter
        tempo.thirtysecondNote/2 => now;
    }
}

// function to play second mandolin notes
fun void playMandolin2()
{
    //------ loop over all notes ---------
    while (true) 
    {
        // call ChannelMandolin object's play method
        cm2.playInstrument();
        
        // ------ if time >= 30 seconds then break -------
        if ( now >= later30 ) 
            break;
    
        // advance time by sixtyfourth duration
        tempo.quarterNote/16 => now;
    }
}
