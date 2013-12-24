// FlyingShakeClass.ck 
// Assignment_7_Flying_DrumCycles

// This is the third class, my own class, ChannelShaker
// this class encapsulate a (Shaker) channel
public class ChannelShaker
{
    // class member variables
    // object of BPM class
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
    
    // STK instrument, shakers (from week 5 lecture)
    Shakers stkInst => JCRev rev => dac;
    stkInst => Delay d => rev;
    
    // STK instrument's variables
    float minObject, maxObject;
    float minDecay, maxDecay;
    int optPreset;
    float optEnergy;
    
    // object of Notes class
    FlyingNotes notes;
    notes.note @=> int note[][][];
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, int optpreset, float optenergy, 
                          float minobject, float maxobject, 
                          float mindecay, float maxdecay)
    {
        idx => channelIndex;
        0 => channelCounter;
        optpreset => optPreset;
        optenergy => optEnergy;
        minobject => minObject;
        maxobject => maxObject;
        mindecay => minDecay;
        maxdecay => maxDecay;
        0.7 => stkInst.gain;   // default gain
        // STK effect parameters
        0.2 => rev.mix;      // reverb mix level
        0.3::second => d.max => d.delay;    // delay time
        0.2 => d.gain;       // delay gain
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
            optPreset => stkInst.preset;
            Math.random2f(minObject, maxObject) => stkInst.objects;
            Math.random2f(minDecay, maxDecay) => stkInst.decay;
            optEnergy => stkInst.energy;
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
        }
    }
}  // end of class    
