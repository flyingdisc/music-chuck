// FlyingKick.ck
// Assignment_7_Flying_DrumCycles
// this is composition file to play drum kick SndBuf

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

SndBuf kick1 => Pan2 p => dac;
0.4 => p.pan;     // panning right

me.dir(-1) + "/audio/kick_04.wav" => kick1.read;  // load
kick1.samples() => kick1.pos;  // playhead at end

// object of FlyingBPM (BPM.ck) class, conductor for tempo
FlyingBPM tempo;

0 => int cntBeat;  // index to beat number

while (true)     // loop
{
    cntBeat % 8 => int beatIndex;  // parse each duration into 8 beats
    // bass drum on 0 and 4
    if (( beatIndex == 0 ) || ( beatIndex == 4 ))
    {
        0 => kick1.pos;
        Math.random2f(0.5, 1.0) => kick1.rate;
        0.4 => kick1.gain;
    }
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by eighth duration
    tempo.eighthNote => now;  
    
    cntBeat++;
}    

