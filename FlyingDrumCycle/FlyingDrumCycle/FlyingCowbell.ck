// FlyingCowbell.ck
// Assignment_7_Flying_DrumCycles
// this is composition file to play cowbell SndBuf

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

SndBuf cow1 => Pan2 p => dac;
-0.9 => p.pan;     // panning left

me.dir(-1) + "/audio/cowbell_01.wav" => cow1.read;  // load
cow1.samples() => cow1.pos;  // playhead at end

// object of FlyingBPM (BPM.ck) class, conductor for tempo
FlyingBPM tempo;

0 => int cntBeat;  // index to beat number

while (true)     // loop
{
    cntBeat % 8 => int beatIndex;  // parse each duration into 8 beats
    // bass drum on 0 and 4
    if (( beatIndex == 3 ) || ( beatIndex == 7 ))
    {
        0 => cow1.pos;
        Math.random2f(.4, 1.6) => cow1.rate;
        .6 => cow1.gain;
    }
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by eighth duration
    tempo.eighthNote => now;  
    cntBeat ++;
}    

