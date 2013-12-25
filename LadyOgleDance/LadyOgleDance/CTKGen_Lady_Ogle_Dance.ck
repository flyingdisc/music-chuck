// @Soesilo Wijono
// Assignment_5_CTKGen_Lady_Ogle_Dance.ck
<<< "\n", "Assignment_5_CTKGen_Lady_Ogle_Dance.ck", "\n" >>>;

// save the time for 30 seconds later as the assignment limit
now => time start30;
now + 30::second => time later30;

// -------- array of MIDI notes in Db Phrygian mode ------------
[49,50,52,54,56,57,59,61] @=> int midi[];


// -------- Mandolin as STK Instrument unit generator ----------
// video lecture #9, week 5 - with panning...
Mandolin m1 => Pan2 p1 => dac;
0.4 => m1.gain;   // default gain


// -------- Shakers as STK Instrument unit generator ----------
// video lecture #12, week 5
Shakers s1 => dac;
0.6 => s1.gain;   // default gain


// -------------- Oscillator + ADSR unit generator ------------
// video lecture #4, week 5
SinOsc osc1 => ADSR env => dac;
0 => osc1.gain;  // initial gain
(0.2::second, 0.1::second, 0.4, 0.2::second) => env.set;


//------ banks of SndBuf: snare, hihat, kick, cowbell -------
7 => int num_banks;         // total number of sounds
SndBuf banks[num_banks-1];  // sound buf array
Pan2 p[num_banks-1];        // panning array

// connect to DACs, with panning
for (0 => int i; i < (num_banks-1); i++)
    banks[i] => p[i] => dac;

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


// 3 channels array of indices to MIDI Db Phrygian notes
// format: [note_index, duration, note_shift]
// index: -1 = 'rest', 0-7 is 'note index'
// shift: -12, 0, 12, octave below/above
// duration: in n/8 quarter
[[[0,0,0],                        // channel 0
[3,2,0],[0,4,0],[3,4,0],[3,4,0],
[-1,2,0],[4,2,0],[5,4,0],[3,4,0],
[3,4,0],[-2,2,0],[6,2,0],[6,4,0],
[-1,2,0],[7,2,0],[6,2,0],[5,2,0],
[3,2,0],[2,2,0],[2,4,0],[-1,2,0],
[3,2,0],[4,4,0],[-1,2,0],[3,1,0],
[2,1,0],[0,4,0],[3,4,0],[3,4,0],
[-1,2,0],[4,2,0],[5,4,0],[3,4,0],
[3,4,0],[2,2,12],[-1,2,0],[7,4,0],
[6,2,0],[7,2,0],[2,2,12],[7,2,0],
[6,2,0],[4,2,0],[3,8,0],[5,4,0],
[-2,2,0],[3,2,0],[0,4,0],[3,4,0],
[3,4,0],[-1,2,0],[4,2,0],[5,4,0],
[3,4,0],[3,4,0],[-1,2,0],[6,2,0],
[6,4,0],[-1,2,0],[7,2,0],[6,2,0],
[5,2,0],[3,2,0],[2,2,0],[2,4,0],
[-1,2,0],[3,2,0],[4,4,0],[-1,2,0],
[3,1,0],[2,1,0],[0,4,0],[3,4,0],
[3,4,0],[-1,2,0],[4,2,0],[5,4,0],
[3,4,0],[3,4,0],[2,2,12],[-1,2,0],
[7,4,0],[6,2,0],[7,2,0],[2,2,12],
[7,2,0],[6,2,0],[4,2,0],[3,8,0],
[5,4,0],[-1,2,0],[4,2,0],[5,2,0],
[6,2,0],[7,2,0],[1,2,12],[2,2,12],
[1,2,12],[7,2,0],[6,2,0],[5,2,0],
[6,2,0],[7,2,0],[1,2,12],[2,4,12],
[-1,2,0],[6,2,0],[4,4,0],[2,4,12],
[6,2,0],[4,2,0],[3,2,0],[2,2,0],
[2,4,0],[-1,2,0],[3,2,0],[4,4,0],
[-2,2,0],[3,1,0],[4,1,0],[5,4,0],
[3,4,0],[3,4,0],[-1,2,0],[4,2,0],
[5,4,0],[3,4,0],[2,4,12],[-1,2,0]
],
[[0,0,0],                        // channel 1
[-1,2,0],[4,2,-12],[-1,2,0],[-1,4,0],
[4,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[3,2,-12],[-1,2,0],[-1,4,0],
[3,2,-12],[-1,4,0],[-1,2,0],[3,2,-12],
[-1,2,0],[-1,4,0],[3,2,-12],[-1,4,0],
[-1,2,0],[4,2,-12],[-1,2,0],[-1,4,0],
[4,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[1,2,-12],[-1,2,0],[-1,4,0],
[1,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[4,2,-12],[-1,2,0],[-1,4,0],
[4,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[3,2,-12],[-1,2,0],[-1,4,0],
[3,2,-12],[-1,4,0],[-1,2,0],[3,2,-12],
[-1,2,0],[-1,4,0],[3,2,-12],[-1,4,0],
[-1,2,0],[4,2,-12],[-1,2,0],[-1,4,0],
[4,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[1,2,-12],[-1,2,0],[-1,4,0],
[1,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[6,2,-24],[-1,2,0],[-1,4,0],
[6,2,-24],[-1,4,0],[-1,2,0],[0,2,-12],
[-1,2,0],[-1,4,0],[3,2,-12],[-1,4,0],
[-1,2,0],[3,2,-12],[-1,2,0],[-1,4,0],
[3,2,-12],[-1,4,0],[-1,2,0],[3,2,-12],
[-1,2,0],[-1,4,0],[3,2,-12],[-1,4,0],
[-1,2,0],[4,2,-12],[-1,2,0],[-1,4,0],
[4,2,-12],[-1,4,0],[-1,2,0],[4,2,-12],
[-1,2,0],[-1,4,0],[4,2,-12],[-1,4,0],
[-1,2,0],[3,2,-12],[-1,2,0],[-1,4,0]
],
[[0,0,0],                        // channel 2
[-1,2,0],[-1,4,0],[4,2,0],[6,2,0],
[1,2,12],[-1,2,0],[-1,4,0],[4,2,0],
[6,2,0],[1,2,12],[-1,2,0],[-1,4,0],
[4,2,0],[6,2,0],[1,2,12],[-1,2,0],
[-1,4,0],[4,2,0],[6,2,0],[1,2,12],
[-1,2,0],[-1,4,0],[3,2,0],[5,2,0],
[7,2,0],[-1,2,0],[-1,4,0],[3,2,0],
[5,2,0],[7,2,0],[-1,2,0],[-1,4,0],
[3,2,0],[5,2,0],[7,2,0],[-1,2,0],
[-1,4,0],[3,2,0],[5,2,0],[7,2,0],
[-1,2,0],[-1,4,0],[4,2,0],[6,2,0],
[1,2,12],[-1,2,0],[-1,4,0],[4,2,0],
[6,2,0],[1,2,12],[-1,2,0],[-1,4,0],
[4,2,0],[6,2,0],[1,2,12],[-1,2,0],
[-1,4,0],[4,2,0],[6,2,0],[1,2,12],
[-1,2,0],[-1,4,0],[1,2,0],[3,2,0],
[5,2,0],[-1,2,0],[-1,4,0],[1,2,0],
[3,2,0],[5,2,0],[-1,2,0],[-1,4,0],
[4,2,0],[6,2,0],[1,2,12],[-1,2,0],
[-1,4,0],[4,2,0],[6,2,0],[1,2,12],
[-1,2,0],[-1,4,0],[4,2,0],[6,2,0],
[1,2,12],[-1,2,0],[-1,4,0],[4,2,0],
[6,2,0],[1,2,12],[-1,2,0],[-1,4,0],
[4,2,0],[6,2,0],[1,2,12],[-1,2,0],
[-1,4,0],[4,2,0],[6,2,0],[1,2,12],
[-1,2,0],[-1,4,0],[3,2,0],[5,2,0],
[7,2,0],[-1,2,0],[-1,4,0],[3,2,0],
[5,2,0],[7,2,0],[-1,2,0],[-1,4,0],
[3,2,0],[5,2,0],[7,2,0],[-1,2,0],
[-1,4,0],[3,2,0],[5,2,0],[7,2,0],
[-1,2,0],[-1,4,0],[4,2,0],[6,2,0],
[1,2,12],[-1,2,0],[-1,4,0],[4,2,0],
[6,2,0],[1,2,12],[-1,2,0],[-1,4,0],
[4,2,0],[6,2,0],[1,2,12],[-1,2,0],
[-1,4,0],[4,2,0],[6,2,0],[1,2,12],
[-1,2,0],[-1,4,0],[1,2,0],[3,2,0],
[5,2,0],[-1,2,0],[-1,4,0],[1,2,0],
[3,2,0],[5,2,0],[-1,2,0],[-1,4,0]]] @=> int note[][][];

// ------------------- Global variables-----------------------
// initialize pan position value
1.0 => float panPosition;
-.05 => float panDelta;  // changes value for panning

// ----------quarter note, in second--------------
.75 => float quarter;
quarter/16 => float unit_quarter;

// sine modulator phase for panning
0.0 => float t;

// multiply factor for frequency, octave above
2 => float factor;

// initialize beat counter variable
0 => int cnt;

// initialize 3 channels loop counter variables
0 => int idxMand => int idxShak => int idxOsc;


// --------------------- Functions ---------------------------
// function to get duration in ms from note array
fun dur getDuration(int chan, int idx)  // chan=channel
{
    // quarter in second
    return (note[chan][idx][1] * quarter / 8)::second;
}

// function to get a note frequency from array with shift
fun float getNoteFreq(int chan, int idx)
{
    if ((note[chan][idx][0] >= 0) && (note[chan][idx][0] <= 7))  // if valid note index
    {
        midi[note[chan][idx][0]] => int n;
        note[chan][idx][2] => int offset;
        return Std.mtof(n+offset) * factor;
    }
    else   // not an index to note, but a rest
        return 0.0;
}

// function to set mandolin frequency & gain
fun void setMandolin(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => m1.noteOff;
        return;
    }
    // get note from array channel 0
    getNoteFreq(0, idx) => float freq;
    if (freq != 0)
    {
        freq => m1.freq;
        Math.random2f(0.3, 0.6) => m1.pluckPos;       // pluck position
        Math.random2f(0.04, 0.08) => m1.stringDetune; // detune string pairs
        Math.random2f(0.2, 0.6) => m1.bodySize;       // mandolin body size percentage
        1.0 => m1.noteOn;
    }
    else
        1.0 => m1.noteOff;
}

// function to set shakers frequency & gain
fun void setShakers(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => s1.noteOff;
        return;
    }
    // get note from array channel 1
    getNoteFreq(1, idx) => float freq;
    if (freq != 0)
    {
        freq => s1.freq;
        21 => s1.preset;
        Math.random2f(20.0, 40.0) => s1.objects;
        Math.random2f(0.4, 1.0) => s1.decay;
        1.0 => s1.energy;
        1.0 => s1.noteOn;
    }
    else
        1.0 => s1.noteOff;
}

// function to set oscillator frequency & gain with ADSR envelope
fun void setOsc(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1 => env.keyOff;
        return;
    }
    // get note from array channel 2
    getNoteFreq(2, idx) / 2 => float freq;
    if (freq != 0)
    {
        freq => osc1.freq;
        .08 => osc1.gain;
        1 => env.keyOn;
    }
    else
        1 => env.keyOff;
}

// function to play bass drum
fun void bassDrum(int beat)
{
    // bass drum on 0 and 4
    if (( beat == 0 ) || ( beat == 4 ))
    {
        0 => banks[4].pos;
        //Math.random2f(.6, 1.4) => banks[4].rate;
        .5 => banks[4].gain;
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
        .4 => banks[0].gain;
    }
    
    // snare drum #2 on beat 5
    if ( beat == 5 )
    {
        0 => banks[1].pos;
        Math.random2f(.8, 1.0) => banks[1].rate;
        .25 => banks[1].gain;
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
    .25 => banks[2].gain;
    
    // hihat #2 on random beat
    if ( beat == (Math.random2(0,8)) )
    {
        0 => banks[3].pos;
        Math.random2f(.8, 1.0) => banks[3].rate;
        .25 => banks[3].gain;
    }
}

// function to set panning
fun void doPanning()
{
    // ---------panning-------------
    // main oscillator, sine wave panning, -pi to pi
    (cnt % 13) => float mod13;
    Math.sin(((mod13 / 6) - 1) * Math.PI) => p1.pan;
    
    // sound banks panning, left
    -0.7 => p[0].pan;      // snare drum #1
    -0.4 => p[2].pan;      // hihat #1
    -0.9 => p[5].pan;       // cowbell
    
    // sound banks panning, right
    0.4 => p[4].pan;        // kick, bass drum
    0.8 => p[1].pan;      // snare drum #2
    0.2 => p[3].pan;         // hihat #2
    
    cnt++;    // increase counter by 1
}

// --------------------- MAIN PROGRAM ------------------------

// initial values of timing for channels' first notes, in ms
getDuration(0, 0) + now => time endTimeMand;
getDuration(1, 0) + now => time endTimeShak;
getDuration(2, 0) + now => time endTimeOsc;

//------ loop over all channels, notes and SndBufs ---------
while (now <= later30)    // limit to 30 seconds
{
    // ------------------MAIN PART-------------------

    // if channel 0 duration is over, turn off & set next note
    if (now >= endTimeMand)
    {
        // --------- STK instrument Mandolin --------
        setMandolin(idxMand, 0); // turn off previous mandolin note
        
        idxMand++;    // index to channel 0's next note
        if (idxMand < note[0].cap())   
        {
            // new duration for next mandolin note
            getDuration(0, idxMand) + now => endTimeMand;
            setMandolin(idxMand, 1); // play next mandolin note
        }

        // ------------ SndBuf part -----------
        // beats goes from position 0 to 7, use modulo %
        cnt % 8 => int beat;
        bassDrum(beat);
        snareDrum(beat);
        cowBell(beat);
        hiHat(beat);

        doPanning();       // call panning function
    }
    
    // --------- STK instrument Shakers --------
    // if channel 1 duration is over, turn off & set next note
    if (now >= endTimeShak)
    {
        setShakers(idxShak, 0); // turn off previous shakers note
        
        idxShak++;     // index to channel 1's next note
        if (idxShak < note[1].cap()) 
        {
            // new duration for next shakers note
            getDuration(1, idxShak) + now => endTimeShak;
            setShakers(idxShak, 1);  // play next shakers note
        }
    }
    
    // ---------- Oscillator ----------
    // if channel 2 duration is over, turn off & set next note
    if (now >= endTimeOsc)
    {
        setOsc(idxOsc, 0);    // turn off previous osc note
        
        idxOsc++;  // index to channel 2's (osc) next note
        if (idxOsc < note[2].cap())   
        {
            // new duration for next osc note
            getDuration(2, idxOsc) + now => endTimeOsc;
            setOsc(idxOsc, 1);    // play next osc note
        }
    }
    
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    cnt++;    // increase beat counter by 1
    
    // advance time by unit quarter
    unit_quarter::second => now;
}

// print time elapsed
<<< "Total Duration: ", (now-start30)/second, "seconds", "\n"  >>>;
