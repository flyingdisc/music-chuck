// BPM.ck 
// Assignment_7_Flying_DrumCycles

// This is the "class from lecture", as a mandatory 
// A global BPM conductor class to define tempo 

// In this case, I don't use BPM class name to avoid this error: 
//   "Class/type 'BPM' is already defined in namespace '[user]'"
//   so I change class name to unique name "FlyingBPM", 
public class FlyingBPM
{
    // global variables 
    dur beatDuration[5];  // array of durations
    
    // global static variables 
    static dur quarterNote, eighthNote, sixteenthNote, 
               thirtysecondNote, sixtyfourthNote;
    
    fun void tempo(float beat)  
    {
        // beat is BPM, example beat=96 beats per minute
        // 60.0/96 = 0.625 second as assignment requirement
        
        60.0/(beat) => float SPB;    // seconds per beat
        SPB::second => quarterNote;
        quarterNote*0.5 => eighthNote;
        eighthNote*0.5 => sixteenthNote;
        sixteenthNote*0.5 => thirtysecondNote;
        thirtysecondNote*0.5 => sixtyfourthNote;
        
        // store data in array
        [quarterNote, eighthNote, sixteenthNote, thirtysecondNote, sixtyfourthNote] @=> beatDuration;
    }
}

