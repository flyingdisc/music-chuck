// FlyingMandoClass.ck 
// Assignment_7_Flying_DrumCycles

// This is the second class, my own class, ChannelMandolin
// this class encapsulate a (mandolin) channel
public class ChannelMandolin
{
    // class member variables
    // object of FlyingBPM class (BPM.ck)
    FlyingBPM tempo;
    // get quarter, the 0.625 second is declared in the score.ck
    tempo.quarterNote / second => float quarter;  
    
    // -------- array of MIDI notes in C Ionian mode ------------
    [48,50,52,53,55,57,59,60] @=> int midi[];
    
    // channel's index to notes-array
    int channelIndex;

    // channel's end time when playing sequence of notes
    time channelEndTime;
    
    // channel's loop counter variable
    int channelCounter;
    
    // counter and period for panning
    int panningCounter;
    int panningPeriod;
    
    // STK instrument, mandolin with panning
    // and John Chowning (JC) reverberator as STK audio effect
    Mandolin stkInst => Pan2 iPan => JCRev rev => dac;
    
    // STK instrument's variables
    float minPluck, maxPluck;
    float minDetune, maxDetune;
    float minBody, maxBody;
    
    // object of Notes class
    FlyingNotes notes;
    notes.note @=> int note[][][];
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain, 
                          float minpluck, float maxpluck, 
                          float mindetune, float maxdetune,
                          float minbody, float maxbody)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        24 => panningPeriod;  // set panning sine wave period to n loop
        minpluck => minPluck;
        maxpluck => maxPluck;
        mindetune => minDetune;
        maxdetune => maxDetune;
        minbody => minBody;
        maxbody => maxBody;
        0.1 => rev.mix;    // reverb mix level
        gain => stkInst.gain;   // default gain
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
            return Std.mtof(n+offset);  // octave above
        }
        else   // not an index to note, but a rest
            return 0.0;
    }

    // function to set instrument's state, freq and gain
    fun void setInstrument(int OnOff)
    {
        if (OnOff == 0)  // off
        {
            1.0 => stkInst.noteOff;
            return;
        }
        // get note from array
        getNoteFreq() => float freq;
        if (freq != 0)
        {
            freq => stkInst.freq;   // set frequency
            Math.random2f(minPluck, maxPluck) => stkInst.pluckPos;       // pluck position
            Math.random2f(minDetune, maxDetune) => stkInst.stringDetune; // detune string pairs
            Math.random2f(minBody, maxBody) => stkInst.bodySize;         // mandolin body size percentage
            1.0 => stkInst.noteOn;  // turn on
        }
        else
            1.0 => stkInst.noteOff;   // turn off
    }
    
    // function to play a channel note
    fun void playInstrument()
    {
        // if channel's duration is over, turn off & set next note
        if (now >= channelEndTime)
        {
            setInstrument(0); // turn off previous note
            
            // index to channel's next note
            channelCounter++;
            // applying modulo to ensure counter < capacity
            (channelCounter % note[channelIndex].cap()) => channelCounter;
            if (channelCounter < note[channelIndex].cap())   
            {
                // new duration for next note
                setNewDuration();
                setInstrument(1); // play next note
            }
            
            // sine wave panning, -pi..pi
            (panningCounter % panningPeriod) => float modPanning;
            panningPeriod / 2 => float halfPanning;
            Math.sin(((modPanning / halfPanning) - 1) * Math.PI) => iPan.pan;
            panningCounter++;
        }
    }
}  // end of class    
