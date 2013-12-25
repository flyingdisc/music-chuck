// @Soesilo Wijono
// drums.ck
// Assignment_6_Blues_Jazz_Meet_Traditional

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

//------ banks of SndBuf: snare, hihat, kick, cowbell -------
6 => int num_banks;         // total number of sounds
SndBuf banks[num_banks];  // sound buf array
Pan2 p[num_banks];        // panning array

// connect to DACs, with panning
for (0 => int i; i < (num_banks); i++)
    banks[i] => p[i] => dac;

// array of strings (paths) as sound file names
string name_banks[num_banks];

// load array with sound file names
"snare_01.wav" => name_banks[0];
"snare_03.wav" => name_banks[1];
"hihat_01.wav" => name_banks[2];
"hihat_04.wav" => name_banks[3];
"kick_01.wav" => name_banks[4];
"cowbell_01.wav" => name_banks[5];

// load sound files, using array of file-name string
for ( 0 => int i; i < (num_banks); i++)
{
    me.dir(-1) + "/audio/" + name_banks[i] => banks[i].read;   // load
    banks[i].samples() => banks[i].pos;  // playheads at end
}

// initialize beat counter variable
0 => int cnt => int cntbeat;

// ----------quarter note, in second--------------
.625 => float quarter;
quarter/16 => float unit_quarter;

// function to play bass drum
fun void bassDrum(int beat)
{
    // bass drum on 0 and 4
    if (( beat == 0 ) || ( beat == 4 ))
    {
        0 => banks[4].pos;
        Math.random2f(.6, 1.4) => banks[4].rate;
        0.35 => banks[4].gain;
    }
}

// function to play snare drum
fun void snareDrum(int beat)
{
    // snare drum #1 on 2 and 6
    if (( beat == 2 ) || ( beat == 6 ))
    {
        0 => banks[0].pos;
        Math.random2f(.6, 1.4) => banks[0].rate;
        .5 => banks[0].gain;
    }
    
    // snare drum #2 on beat 5
    if ( beat == 5 )
    {
        0 => banks[1].pos;
        Math.random2f(.8, 1.0) => banks[1].rate;
        .4 => banks[1].gain;
    }
}

// function to play cowbell
fun void cowBell(int beat)
{
    // cowbell on 3 and 7
    if (( beat == 3 ) || ( beat == 7 ))
    {
        0 => banks[5].pos;
        Math.random2f(.4, 1.6) => banks[5].rate;
        .4 => banks[5].gain;
    }
}

// function to play hihat
fun void hiHat(int beat)
{
    // hihat #1
    0 => banks[2].pos;
    Math.random2f(.4, 1.6) => banks[2].rate;
    .4 => banks[2].gain;
    
    // hihat #2 on random beat
    if ( beat == (Math.random2(0,8)) )
    {
        0 => banks[3].pos;
        Math.random2f(.8, 1.0) => banks[3].rate;
        .4 => banks[3].gain;
    }
}

// function to set panning
fun void doPanning()
{
    // sound banks panning, left
    -0.7 => p[0].pan;      // snare drum #1
    -0.4 => p[2].pan;      // hihat #1
    -0.9 => p[5].pan;       // cowbell
    
    // sound banks panning, right
    0.4 => p[4].pan;        // kick, bass drum
    0.8 => p[1].pan;      // snare drum #2
    0.2 => p[3].pan;         // hihat #2
}

while (true)
{
    // ------------ SndBuf part -----------
    int beat;
    // beats goes from position 0 to 7, use modulo %
    if ((cnt % 8) == 0)
    {
        cntbeat % 8 => beat;
        
        bassDrum(beat);
        snareDrum(beat);
        cowBell(beat);
        hiHat(beat);
        
        doPanning();       // call panning function    
        cntbeat++;
    }
    
    cnt++;    // increase beat counter by 1
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by unit quarter
    unit_quarter::second => now;   
}