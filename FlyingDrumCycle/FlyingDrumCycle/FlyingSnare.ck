// @Soesilo Wijono
// FlyingSnare.ck
// Assignment_7_Flying_DrumCycles
// this is composition file to play snares SndBuf

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// first snare
SndBuf snare1 => Pan2 p1 => dac;
-0.7 => p1.pan;      // panning left

me.dir(-1) + "/audio/snare_01.wav" => snare1.read;  // load
snare1.samples() => snare1.pos;  // playhead at end

// second snare
SndBuf snare2 => Pan2 p2 => dac;
0.8 => p2.pan;       // panning right

me.dir(-1) + "/audio/snare_03.wav" => snare2.read;
snare2.samples() => snare2.pos;  // playhead at end

// object of FlyingBPM (BPM.ck) class, conductor for tempo
FlyingBPM tempo;

0 => int cntBeat;  // index to beat number

while (true)     // loop
{
    cntBeat % 8 => int beatIndex;  // parse each duration into 8 beats
    // snare drum #1 on 2 and 6
    if (( beatIndex == 2 ) || ( beatIndex == 6 ))
    {
        0 => snare1.pos;
        Math.random2f(.6, 1.4) => snare1.rate;
        .4 => snare1.gain;
    }
    
    // snare drum #2 on beat 5
    if ( beatIndex == 5 )
    {
        0 => snare2.pos;
        Math.random2f(.8, 1.0) => snare2.rate;
        .4 => snare2.gain;
    }
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by eighth duration
    tempo.eighthNote => now;  
    
    cntBeat++;
}    
