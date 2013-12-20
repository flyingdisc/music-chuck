// BPM.ck 
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

// A global BPM conductor class to define tempo 
public class QBPM
{
    // overall duration
    163 => float oAllDur;
    
    // global static variables 
    static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote;
    
    fun void tempo(float beat)  
    {
        // beat is BPM, beat per minute
        60.0/(beat) => float SPB;    // seconds per beat
        SPB::second => quarterNote;
        quarterNote*0.5 => eighthNote;
        eighthNote*0.5 => sixteenthNote;
        sixteenthNote*0.5 => thirtysecondNote;
    }
}
