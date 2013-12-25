//@Soesilo Wijono
// Assignment_3_Local_Folk_Song.ck
<<< "Assignment_3_Local_Folk_Song.ck" >>>;

// save the time for 30 seconds later as the assignment limit
now => time start30;
now + 30::second => time later30;

// array of MIDI notes in D Dorian scale
[50,52,53,55,57,59,60,62] @=> int dDorian[];

// sound chain
SinOsc main1 => Pan2 p1 => dac;   // main oscillator, panning

// banks of sound: snare, hihat, kick, stereofx, cowbell
7 => int num_banks;         // total of sounds
SndBuf banks[num_banks-1];  // sound buf array
Pan2 p[num_banks-1];        // panning array

// connect to DACs, with panning
for (0 => int i; i < (num_banks-1); i++)
{
    banks[i] => p[i] => dac;
}
// background stereo sound
SndBuf2 bg => dac;

// array of strings (paths) as sound file names
string name_banks[num_banks];

// load array with sound file names
"/audio/snare_01.wav" => name_banks[0];
"/audio/snare_03.wav" => name_banks[1];
"/audio/hihat_01.wav" => name_banks[2];
"/audio/hihat_04.wav" => name_banks[3];
"/audio/kick_01.wav" => name_banks[4];
"/audio/cowbell_01.wav" => name_banks[5];
"/audio/stereo_fx_04.wav" => name_banks[6]; 

// load sound files, using array of file-name string
for ( 0 => int i; i < (num_banks-1); i++)
{
    me.dir() + name_banks[i] => banks[i].read;   // load
    banks[i].samples() => banks[i].pos;  // playheads at end
}
// load stereo background sound
me.dir() + name_banks[num_banks-1] => bg.read;   // load
bg.samples() => bg.pos;  // playheads at end

// array of index to 124 MIDI D Dorian scale notes
// -1 is no sound
[-1,6,1,-1,6,1,2,3,3,-1,
5,6,5,6,5,3,-1,6,1,-1,
6,1,2,3,3,-1,5,6,5,6,
5,3,-1,6,1,3,2,2,3,2,
1,6,2,1,6,-1,6,1,3,2,
2,3,2,1,6,2,1,6,-1,6,
1,-1,6,1,2,3,3,-1,5,6,
5,6,5,3,-1,6,1,-1,6,1,
2,3,3,-1,5,6,5,6,5,3,
-1,6,1,3,2,2,3,2,1,6,
2,1,6,-1,6,1,3,2,2,3,
2,1,6,2,1,6,-1,6,1,-1,
6,1,2,3] @=> int note1[];

// array of offset to the MIDI notes above
// -1 is no sound, 0 is no scaling
[-1,-12,0,-1,-12,0,0,0,0,-1,
0,0,0,0,0,0,-1,-12,0,-1,
-12,0,0,0,0,-1,0,0,0,0,
0,0,-1,-12,0,0,0,0,0,0,
0,-12,0,0,-12,-1,-12,0,0,0,
0,0,0,0,-12,0,0,-12,-1,-12,
0,-1,-12,0,0,0,0,-1,0,0,
0,0,0,0,-1,-12,0,-1,-12,0,
0,0,0,-1,0,0,0,0,0,0,
-1,-12,0,0,0,0,0,0,0,-12,
0,0,-12,-1,-12,0,0,0,0,0,
0,0,-12,0,0,-12,-1,-12,0,-1,
-12,0,0,0] @=> int diff1[];

// gain value for main sound
.2 => float defGain;

// multiply factor for frequency
2 => float factor;

// quarter notes
.25::second => dur quarter;

// initialize counter variable
0 => int cnt;

// loop over all D Dorian notes
for ( 0 => int i; i < note1.cap(); i++ ) 
{
    // default midi notes
    dDorian[0] => int midinote1;

    // default gain value
    0 => float gain1;

    // ------------------MAIN PART-------------------
    // MIDI note from D Dorian array
    if ( note1[i] >= 0 ) 
    {
        dDorian[note1[i]] + diff1[i] => midinote1;
        defGain => gain1;
    }
   
    // convert MIDI note to frequency Hz, 
    // multiply freq. for higher octave
    Std.mtof(midinote1) * factor => main1.freq;
    
    // set volume level from array to gain
    gain1 => main1.gain;

    // --------------SOUND BANKS PART----------------

    // beats goes from position 0 to 7, use modulo %
    cnt % 8 => int beat;    
    
    // reverse 14 seconds stereo background
    if ( (i == 0) || (i == (note1.cap()/2)) )
    {
        -1 => bg.rate;   // reverse SndBuf sound
        0 => bg.gain; //.4 => bg.gain;
    }
    
    // bass drum on 0 and 4
    if (( beat == 0 ) || ( beat == 4 ))
    {
        0 => banks[4].pos;
        //Math.random2f(.6, 1.4) => banks[4].rate;
        .5 => banks[4].gain;
    }
    
    // snare drum #1 on 2 and 6
    if (( beat == 2 ) || ( beat == 6 ))
    {
        0 => banks[0].pos;
        Math.random2f(.6, 1.4) => banks[0].rate;
        .4 => banks[0].gain;
    }
    
    // snare drum #2 on beat 5
    if ( beat == 5 )
    {
        0 => banks[1].pos;
        Math.random2f(.8, 1.0) => banks[1].rate;
        .2 => banks[1].gain;
    }
    
    // cowbell on 3 and 7
    if (( beat == 3 ) || ( beat == 7 ))
    {
        0 => banks[5].pos;
        Math.random2f(.4, 1.6) => banks[5].rate;
        .4 => banks[5].gain;
    }
    
    // hihat #1
    0 => banks[2].pos;
    Math.random2f(.4, 1.6) => banks[2].rate;
    .2 => banks[2].gain;
    
    // hihat #2 on random beat
    if ( beat == (Math.random2(0,8)) )
    {
        0 => banks[3].pos;
        Math.random2f(.8, 1.0) => banks[3].rate;
        .2 => banks[3].gain;
    }
    
    // ---------panning-------------
    // main oscillator, sine wave panning, -pi to pi
    (cnt % 13) => float mod13;
    ((mod13 / 6) - 1) * Math.PI => p1.pan;
    
    // sound banks panning, left
    -0.7 => p[0].pan;      // snare drum #1
    -0.4 => p[2].pan;      // hihat #1
    -0.9 => p[5].pan;       // cowbell
    
    // sound banks panning, right
    0.4 => p[4].pan;        // kick, bass drum
    0.8 => p[1].pan;      // snare drum #2
    0.2 => p[3].pan;         // hihat #2
    
    
    // if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
    {
        break;
    }
    
    cnt++;    // increase counter by 1
    
    // quarter notes 250ms
    quarter => now;
    
    // turn off sound temporarily to avoid clipping
    0 => main1.freq;
    0 => main1.gain;
}   

// print time elapsed
<<< "Total Duration: ", (now-start30)/second, "seconds"  >>>;