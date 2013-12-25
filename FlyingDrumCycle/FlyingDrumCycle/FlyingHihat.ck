// @Soesilo Wijono
// FlyingHihat.ck
// Assignment_7_Flying_DrumCycles
// this is composition file to play hihats SndBuf

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// first hihat
SndBuf hihat1 => Pan2 p1 => dac;
-0.4 => p1.pan;    // panning left

me.dir(-1) + "/audio/hihat_01.wav" => hihat1.read;  // load
hihat1.samples() => hihat1.pos;  // playhead at end

// second hihat
SndBuf hihat2 => Pan2 p2 => dac;
0.2 => p2.pan;      // panning right

me.dir(-1) + "/audio/hihat_04.wav" => hihat2.read;
hihat2.samples() => hihat2.pos;  // playhead at end

// object of FlyingBPM (BPM.ck) class, conductor for tempo
FlyingBPM tempo;

0 => int cntBeat;  // index to beat number

while (true)     // loop
{
    cntBeat % 8 => int beatIndex;  // parse each duration into 8 beats
    // hihat #1
    0 => hihat1.pos;
    Math.random2f(.4, 1.6) => hihat1.rate;
    .4 => hihat1.gain;
    
    // hihat #2 on random beat
    if ( beatIndex == (Math.random2(0, 8)) )
    {
        0 => hihat2.pos;
        Math.random2f(.8, 1.0) => hihat2.rate;
        .4 => hihat2.gain;
    }
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by eighth duration
    tempo.eighthNote => now;  
    
    cntBeat++;
}    
