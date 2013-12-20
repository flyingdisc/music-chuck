// sinstrumentclass.ck 
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

public class ChannelInstrument
{
    QBPM tempo;
    tempo.quarterNote / second => float beat;  // get quarter beat
    
    // channel's index to notes-array
    int channelIndex;

    // channel's end time when playing sequence of notes
    time channelEndTime;
    
    // channel's loop counter variable
    int channelCounter;
    
    // counter and period for panning
    int panningCounter;
    int panningPeriod;
    int isPanning;
    
    // frequency multiplication factor
    float mulFactor;
    
    StkInstrument @ stkInst;
    Pan2 iPan;
    
    // object of Notes class
    SNotes notes;
    notes.melody_note @=> int melody[][][];
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain, int ispan)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        ispan => isPanning;
        gain => stkInst.gain;   // default gain
        1 => mulFactor;
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        // to be implemented in subclass
    }
    
    // function to set new duration in ms from notes-array
    fun void setNewDuration()
    {
        // quarter * note's duration, in second
        (melody[channelIndex][channelCounter][1] * beat / 128)::second + now => channelEndTime;
    }

    // function to get a note frequency from notes-array with shift
    fun float getNoteFreq()
    {
        // valid note index is >= 0
        if (melody[channelIndex][channelCounter][0] >= 0)
        {
            melody[channelIndex][channelCounter][0] => int n;
            return Std.mtof(n);
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
        getNoteFreq() * mulFactor => float freq;
        if (freq != 0)
        {
            freq => stkInst.freq;   // set frequency
            setStkParams();
            1.0 => stkInst.noteOn;  // turn on
        }
        else {
            1.0 => stkInst.noteOff;   // turn off
        }
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
            if (channelCounter < melody[channelIndex].cap())   
            {
                // applying modulo to ensure counter < capacity
                (channelCounter % melody[channelIndex].cap()) => channelCounter;
                // new duration for next note
                setNewDuration();
                setInstrument(1); // play next note
            }
            else
                return;
            
            if (isPanning == 1) {
                // sine wave panning, -pi..pi
                (panningCounter % panningPeriod) => float modPanning;
                panningPeriod / 2 => float halfPanning;
                Math.sin(((modPanning / halfPanning) - 1) * Math.PI) => iPan.pan;
                panningCounter++;
            }
        }
    }
}  // end of class    
