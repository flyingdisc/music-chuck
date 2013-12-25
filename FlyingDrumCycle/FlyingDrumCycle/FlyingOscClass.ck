// @Soesilo Wijono
// FlyingOscClass.ck 
// Assignment_7_Flying_DrumCycles

// This is oscillator channel class,
//    to define class and play notes using oscillator

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

class ChannelOsc    // private class
{
    // object of BPM class
    FlyingBPM tempo;
    // get quarter, the 0.625 second is declared in the score.ck
    tempo.quarterNote / second => float quarter; 
    
    // -------- array of MIDI notes in C Ionian mode ------------
    [48,50,52,53,55,57,59,60] @=> int midi[];

    // ------------- Oscillator + ADSR unit generator -----------
    // (ADSR and Chorus from week 5)
    SinOsc osc1 => ADSR env => Chorus ch => dac;
    0 => osc1.gain;  // initial gain
    (0.2::second, 0.1::second, 0.4, 0.2::second) => env.set;
    0.1 => ch.mix;   // chorus mix level
    
    // channel's index to notes-array
    int channelIndex;

    // channel's end time when playing sequence of notes
    time channelEndTime;
    
    // channel's loop counter variable
    int channelCounter;
    
    // object of Notes class
    FlyingNotes notes;
    notes.note @=> int note[][][];
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx)
    {
        idx => channelIndex;
        0 => channelCounter;
    }

    // function to set new duration in ms from notes-array
    fun void setNewDuration()
    {
        // quarter * note's duration, in second
        (note[channelIndex][channelCounter][2] * quarter / 128)::second + now => channelEndTime;
    }

    // function to get a note frequency from notes-array with shift
    fun float getNoteFreq()
    {
        // valid note index is in the range 0..7
        if ((note[channelIndex][channelCounter][0] >= 0) && (note[channelIndex][channelCounter][0] <= 7))
        {
            midi[note[channelIndex][channelCounter][0]] => int n;
            note[channelIndex][channelCounter][1] => int offset;
            return Std.mtof(n+offset);
        }
        else   // not an index to note, but a rest
            return 0.0;
    }
    
    // function to set oscillator frequency & gain with ADSR envelope
    fun void setOsc(int OnOff)
    {
        if (OnOff == 0)  // off
        {    
            1 => env.keyOff;
            return;
        }
        // get note from array
        getNoteFreq() => float freq;
        if (freq != 0)
        {
            freq => osc1.freq;
            .4 => osc1.gain;
            1 => env.keyOn;
        }
        else
            1 => env.keyOff;
    }
    
    // function to play a channel note
    fun void playOsc()
    {
        // if channel's duration is over, turn off & set next note
        if (now >= channelEndTime)
        {
            setOsc(0); // turn off previous note
            
            // index to channel's next note
            channelCounter++;
            // applying modulo to ensure counter < capacity
            (channelCounter % note[channelIndex].cap()) => channelCounter;
            if (channelCounter < note[channelIndex].cap())   
            {
                // new duration for next note
                setNewDuration();
                setOsc(1); // play next note
            }
        }
    }
}  // end of class

// ---------instantiate oscillator object, then play---------
// object of BPM class
FlyingBPM tempo;

// instantiation object of ChannelOsc class
ChannelOsc co;

// create oscillator on channel 0
// by using ChannelOsc object
co.createChannel(0);

// initial values of timing for channel's first notes
co.setNewDuration();

//------ loop over all channel notes ---------
while (true) 
{
    // call ChannelOsc object's play method
    co.playOsc();

    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by sixtyfourth duration
    tempo.quarterNote/16 => now;
}
