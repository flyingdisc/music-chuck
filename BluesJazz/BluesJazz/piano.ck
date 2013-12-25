// @Soesilo Wijono
// piano.ck
// Assignment_6_Blues_Jazz_Meet_Traditional

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// -------- array of MIDI notes in Bb Aeolian mode ------------
[46,48,49,51,53,54,56,58] @=> int midi[];

// ---------- Rhodey as STK Instrument unit generator ---------
// with JC reverberator and Delay as STK audio effect
Rhodey p0 => JCRev rev => dac;
0.4 => p0.gain;   // default gain
p0 => Delay d => rev;

// STK effect parameters
0.2 => rev.mix;      // reverb mix level
0.4::second => d.max => d.delay;    // delay time
0.1 => d.gain;       // delay gain

// ------------- Oscillator + ADSR unit generator -----------
// (ADSR and Chorus from week 5)
SinOsc osc1 => ADSR env => Chorus ch => dac;
0 => osc1.gain;  // initial gain
(0.2::second, 0.1::second, 0.4, 0.2::second) => env.set;
0.4 => ch.mix;   // chorus mix level

// array of indices to MIDI Bb Aeolian notes
// format: [note_index, duration, note_shift]
// index: -1 = 'rest', 0-7 is 'note index'
// shift: -12, 0, 12, 24, = octave below/above
// duration: in n/128 quarter
[[[0,0,0],        // channel 3
[5,12,128],[5,12,64],[5,12,32],
[5,12,8],[-1,0,8],[-1,0,16],[5,12,64],
[5,12,8],[-1,0,16],[6,0,32],[-1,0,8],
[4,24,64],[4,24,32],[-1,0,32],[1,24,128],
[1,24,64],[1,24,32],[1,24,8],[-1,0,8],
[-1,0,16],[1,24,64],[1,24,8],[-1,0,16],
[2,12,32],[-1,0,8],[1,24,64],[1,24,32],
[-1,0,32],[5,12,64],[-1,0,8],[-1,0,16],
[5,12,32],[5,12,8],[-1,0,8],[-1,0,16],
[-1,0,64],[5,12,256],[5,12,8],[-1,0,32],
[1,24,64],[1,24,8],[-1,0,8],[-1,0,16],
[-1,0,32],[1,24,128],[1,24,64],[1,24,8],
[-1,0,8],[-1,0,16],[-1,0,32],[2,24,64],
[2,24,8],[-1,0,16],[2,12,32],[2,12,8],
[2,24,32],[2,24,16],[-1,0,16],[-1,0,64],
[-1,0,8],[-1,0,16],[-1,0,64],[-1,0,128],
[5,0,32],[5,0,8],[5,0,8],[7,12,64],
[7,12,8],[-1,0,8],[5,0,32],[5,0,8],
[7,12,64],[-1,0,64],[-1,0,8],[-1,0,16],
[-1,0,64],[-1,0,128],[5,0,32],[5,0,8],
[3,12,8],[3,12,64],[3,12,8],[-1,0,8],
[5,0,32],[5,0,8],[3,12,64],[-1,0,64],
[1,24,128],[1,24,64],[-1,0,8],[-1,0,16],
[1,24,32],[1,24,16],[-1,0,8],[-1,0,16],
[-1,0,32],[-1,0,64],[-1,0,128],[1,24,256],
[1,24,128],[1,24,32],[1,24,8],[-1,0,8], 
[-1,0,16],[-1,0,64],[5,12,256],[5,12,128],
[5,12,32],[5,12,16],[-1,0,16],[-1,0,64],
[-1,0,8],[-1,0,16],[-1,0,64],[1,24,64],
[1,24,32],[1,24,16],[1,24,8],[-1,0,8],
[1,12,32],[1,12,8],[1,12,8],[1,24,64],    
[1,24,16],[1,24,8],[-1,0,32],[-1,0,128],
[1,24,32],[1,24,16],[1,24,8],[-1,0,32],
[1,24,32],[1,24,16],[-1,0,16],[-1,0,64],
[1,24,256],[1,24,16],[-1,0,8],[-1,0,16],
[-1,0,8],[-1,0,16],[-1,0,64],[1,24,64]],
[[0,0,0],        // channel 4
[6,0,512],[2,12,512],[5,0,8],
[5,0,256],[5,0,128],[5,0,64],[5,0,32],
[5,0,16],[5,0,8],[6,0,256],[2,24,512],
[5,12,8],[5,12,256],[5,12,128],[5,12,64],
[5,12,32],[5,12,16],[5,12,8],[5,12,8],
[-1,0,8],[-1,0,16],[-1,0,32],[-1,0,64],
[-1,0,128],[-1,0,256],[6,12,512],[2,24,512],
[5,0,512],[1,12,512],[1,12,8],[3,12,256],
[3,12,128],[3,12,64],[3,12,32],[3,12,16],
[3,12,8],[3,12,512],[6,0,512],[6,0,512],
[6,12,512],[2,24,512]]] @=> int note[][][];

// ----------quarter note, in second--------------
.625 => float quarter;
quarter/16 => float unit_quarter;

// multiply factor for frequency
1 => float factor;

// initialize channel loop counter variables
0 => int idxPiano => int idxOsc;

// --------------------- Functions ---------------------------
// function to get duration in ms from note array
fun dur getDuration(int chan, int idx)  // chan=channel
{
    // quarter second to ms
    return (note[chan][idx][2] * quarter / 128)::second;
}

// function to get a note frequency from array with shift
fun float getNoteFreq(int chan, int idx)
{
    if ((note[chan][idx][0] >= 0) && (note[chan][idx][0] <= 7))  // if valid note index
    {
        midi[note[chan][idx][0]] => int n;
        note[chan][idx][1] => int offset;
        return Std.mtof(n+offset) * factor;
    }
    else   // not an index to note, but a rest
        return 0.0;
}

// function to set Rhodey piano frequency & gain
fun void setPiano(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => p0.noteOff;
        return;
    }
    // get note from array channel 3 (chan.index 0)
    getNoteFreq(0, idx) => float freq;
    if (freq != 0)
    {
        freq / 2 => p0.freq;
        Math.random2f(0.6, 1.0) => p0.afterTouch; 
        1.0 => p0.noteOn;
    }
    else
        1.0 => p0.noteOff;
}

// function to set oscillator frequency & gain with ADSR envelope
fun void setOsc(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1 => env.keyOff;
        return;
    }
    // get note from array channel 4 (chan.index 1)
    getNoteFreq(1, idx) / 2 => float freq;
    if (freq != 0)
    {
        freq => osc1.freq;
        .25 => osc1.gain;
        1 => env.keyOn;
    }
    else
        1 => env.keyOff;
}

// initial values of timing for channel's first notes, in ms
getDuration(0, 0) + now => time endTimePiano;
getDuration(1, 0) + now => time endTimeOsc;

//------ loop over all notes ---------
while (true) 
{
    // if channel 3 duration is over, turn off & set next note
    if (now >= endTimePiano)
    {
        // --------- STK instrument Rhodey piano --------
        setPiano(idxPiano, 0); // turn off previous note
        
        idxPiano++;
        (idxPiano % note[0].cap()) => idxPiano;  // index to channel 3's next note
        if (idxPiano < note[0].cap())   
        {
            // new duration for next note
            getDuration(0, idxPiano) + now => endTimePiano;
            setPiano(idxPiano, 1); // play next piano note
        }
    }
    
    // if channel 4 duration is over, turn off & set next note
    if (now >= endTimeOsc)
    {
        setOsc(idxOsc, 0);    // turn off previous osc note
        
        idxOsc++;  // index to channel 4's (osc) next note
        (idxOsc % note[1].cap()) => idxOsc;  // index to channel 4's next note
        if (idxOsc < note[1].cap())   
        {
            // new duration for next osc note
            getDuration(1, idxOsc) + now => endTimeOsc;
            setOsc(idxOsc, 1);    // play next osc note
        }
    }

    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    // advance time by unit quarter
    unit_quarter::second => now;
}
