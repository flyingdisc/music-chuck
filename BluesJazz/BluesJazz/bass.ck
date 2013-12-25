// @Soesilo Wijono
// bass.ck
// Assignment_6_Blues_Jazz_Meet_Traditional

// save the time for 30 seconds later as the assignment limit
now + 30::second => time later30;

// -------- array of MIDI notes in Bb Aeolian mode ------------
[46,48,49,51,53,54,56,58] @=> int midi[];

// ----- Mandolin & Clarinet as STK Instrument unit generator ------
// (mandolin & clarinet from week 5) 
Mandolin m0 => dac;
0.2 => m0.gain;   // default gain

// clarinet with panning 
// and John Chowning (JC) reverberator as STK audio effect
Clarinet cla => Pan2 p1 => JCRev rev => dac;
0.3 => cla.gain;   // default gain
0.1 => rev.mix;    // reverb mix level

Mandolin mb => dac;
0.15 => mb.gain;   // default gain

[0,2,1] @=> int instOrder[];  // order of instruments

// array of indices to MIDI Bb Aeolian notes
// format: [note_index, duration, note_shift]
// index: -1 = 'rest', 0-7 is 'note index'
// shift: -12, 0, 12, 24, = octave below/above
// duration: in n/128 quarter
[[[0,0,0],        // channel 0
[6,-12,256],[-1,0,8],[3,0,128],
[3,0,64],[3,0,8],[3,0,32],[3,0,16],
[2,0,256],[6,-12,128],[6,-12,64],[6,-12,16],
[6,-12,8],[2,-12,16],[-1,0,8],[-1,0,16],
[5,-12,256],[2,0,128],[2,0,64],[2,0,16],
[2,0,8],[5,-24,16],[-1,0,8],[-1,0,16],
[6,-12,128],[6,-12,32],[6,-12,8],[6,-12,8],
[3,0,32],[-1,0,8],[1,0,16],[1,0,8],
[-1,0,16],[-1,0,16],[4,0,64],[4,0,32],
[4,0,16],[4,0,8],[-1,0,8],[4,0,64],
[4,0,16],[4,0,8],[5,-12,32],[-1,0,8],
[5,-12,64],[5,-12,32],[5,-12,16],[5,-12,8],
[-1,0,8],[6,-12,64],[6,-12,32],[6,-12,16],
[-1,0,16],[7,-12,64],[7,-12,32],[7,-12,16],
[7,-12,8],[-1,0,8],[0,0,64],[0,0,16],
[0,0,8],[5,-12,32],[-1,0,8],[5,-12,64],
[5,-12,32],[5,-12,16],[5,-12,8],[-1,0,8],
[6,-12,64],[6,-12,32],[6,-12,16],[-1,0,16],
[7,-12,64],[7,-12,32],[7,-12,16],[7,-12,8],
[-1,0,8],[0,0,64],[0,0,16],[0,0,8],
[7,-12,32],[-1,0,8],[6,-12,64],[6,-12,16],
[-1,0,8],[6,-24,32],[-1,0,8],[0,0,64], 
[0,0,32],[0,0,16],[0,0,8],[-1,0,8],
[1,0,64],[1,0,32],[1,0,16],[1,0,8],
[-1,0,8],[3,0,64],[3,0,16],[3,0,8],
[6,-12,32],[6,-12,8],[2,0,64],[2,0,16],
[2,0,8],[2,-12,16],[2,-12,8],[2,0,8], 
[-1,0,8],[1,0,64],[1,0,32],[1,0,16],
[1,0,8],[-1,0,8],[0,0,128],[6,-12,64],
[6,-12,16],[6,-12,8],[6,-12,32],[6,-12,8],
[5,-12,256],[2,0,128],[2,0,64],[2,0,16],
[2,0,8],[5,-24,16],[-1,0,8],[-1,0,16],
[1,0,256],[5,0,128],[5,0,64],[5,0,16],
[5,0,8],[1,-12,16],[-1,0,8],[-1,0,16],
[1,0,256],[5,0,128],[5,0,64],[5,0,32],
[5,0,16],[5,0,8],[-1,0,8],[1,0,128],
[1,0,64],[1,0,16],[1,0,8],[1,-12,16]],
[[0,0,0],        // channel 1
[3,0,8],[-1,0,8],[-1,0,16],
[-1,0,32],[-1,0,64],[2,0,32],[2,0,16],
[-1,0,8],[-1,0,32],[2,0,32],[2,0,8],
[2,0,32],[2,0,16],[-1,0,16],[-1,0,64],
[2,0,32],[2,0,16],[-1,0,8],[-1,0,32], 
[2,0,32],[2,0,8],[7,0,32],[6,0,16],
[-1,0,16],[-1,0,64],[3,0,32],[2,0,16],
[-1,0,8],[-1,0,32],[1,12,32],[1,12,8],
[1,12,32],[1,12,16],[-1,0,16],[-1,0,64],
[1,12,32],[7,0,16],[-1,0,8],[-1,0,32],
[7,0,32],[7,0,8],[1,12,8],[-1,0,8],
[-1,0,16],[-1,0,32],[-1,0,64],[3,0,32],
[2,0,16],[-1,0,8],[-1,0,32],[1,12,32],
[1,12,8],[1,12,8],[1,12,32],[1,12,8],
[-1,0,16],[-1,0,64],[2,0,32],[2,0,16],
[-1,0,8],[-1,0,32],[1,12,32],[1,12,8],
[1,12,32],[7,0,16],[-1,0,16],[-1,0,64],
[7,0,32],[7,0,16],[-1,0,8],[-1,0,32],
[1,12,32],[1,12,8],[1,12,32],[1,12,16],
[-1,0,8],[-1,0,32],[1,12,32],
[1,12,8],[1,12,8],[1,12,32],
[1,12,8],[-1,0,8],[-1,0,32],[0,0,32],
[0,0,8],[0,0,8],[7,0,32],[7,0,8],
[-1,0,8],[-1,0,32],[7,0,32],[7,0,8],
[1,12,8],[-1,0,16],[-1,0,64],[0,0,32],
[0,0,8],[0,0,8],[2,0,32],[2,0,8],
[-1,0,8],[-1,0,32],[1,12,32],[1,12,8],
[1,12,8],[1,12,32],[1,12,8],[-1,0,8],
[-1,0,32],[5,0,32],[5,0,8],[5,0,8],
[7,0,32],[7,0,8],[-1,0,8],[-1,0,32],
[1,12,32],[1,12,8],[3,0,8],[-1,0,8],
[-1,0,16],[-1,0,32],[-1,0,64],[2,0,32],
[2,0,16],[-1,0,8],[-1,0,32],[2,0,32],
[2,0,8],[2,0,32],[2,0,16],[-1,0,8],
[-1,0,32],[2,0,32],[2,0,8],[2,0,32],
[2,0,16],[-1,0,8],[-1,0,32],[2,0,32],
[2,0,8],[3,0,8],[-1,0,8],[-1,0,16],
[-1,0,32],[-1,0,64],[2,0,32],[2,0,16],
[-1,0,8],[-1,0,32],[5,0,32],[4,0,8],
[2,0,32],[2,0,16],[-1,0,16],[-1,0,64],
[2,0,32],[2,0,16],[-1,0,8],[-1,0,32],
[2,0,32],[2,0,8],[1,12,8],[-1,0,8],
[-1,0,16],[-1,0,32],[-1,0,64],[3,0,32],
[2,0,16],[-1,0,8],[-1,0,32],[1,12,32],
[1,12,8],[1,12,8],[1,12,32],[1,12,8],
[-1,0,8],[-1,0,32],[0,0,32],[0,0,8],
[0,0,8],[2,0,32],[2,0,8],[-1,0,8],
[-1,0,32],[1,12,32],[1,12,8],[1,12,32],
[7,0,16],[-1,0,16],[-1,0,64],[3,0,32],
[2,0,16],[-1,0,8],[-1,0,32],[1,12,32],
[1,12,8],[1,12,32],[1,12,16],[-1,0,16],
[-1,0,64],[2,0,32],[2,0,16],[-1,0,8],
[-1,0,32],[1,12,32],[1,12,8],[1,12,8],
[-1,0,16],[-1,0,64],[0,0,32],[0,0,8],
[0,0,8]],
[[0,0,0],        // channel 2
[-1,0,8],[-1,0,64],[-1,0,16],
[1,24,16],[1,24,8],[-1,0,8],[2,24,16],
[2,24,8],[-1,0,8],[3,24,16],[3,24,8],
[-1,0,16],[3,24,256],[3,24,64],[3,24,64],
[3,24,8],[-1,0,8],[3,24,16],[3,24,8], 
[-1,0,16],[4,24,32],[-1,0,8],[-1,0,16],
[4,24,32],[-1,0,8],[-1,0,32],[6,24,8],
[7,24,16],[7,24,8],[7,24,128],[7,24,64],
[7,24,32],[7,24,16],[7,24,8],[-1,0,32],
[7,24,32],[7,24,8],[7,24,32],[6,24,32],
[-1,0,8],[-1,0,16],[5,24,16],[5,24,256],
[5,24,64],[5,24,16],[-1,0,32],[-1,0,128],
[-1,0,8],[-1,0,16],[-1,0,64],[7,24,128],
[7,24,64],[7,24,8],[-1,0,8],[-1,0,16], 
[-1,0,128],[1,24,32],[1,24,16],[1,24,8],
[2,24,32],[-1,0,8],[3,24,32],[3,24,8],
[-1,0,8],[-1,0,16],[3,24,256],[3,24,128],
[-1,0,16],[2,24,16],[2,24,8],[3,24,16],
[3,24,8],[3,24,8],[2,24,32],[2,24,16],
[2,24,8],[2,24,16],[7,12,128],[7,12,32],
[-1,0,8],[-1,0,32],[-1,0,128],[1,24,32],
[1,24,8],[-1,0,8],[2,24,32],[2,24,16],
[2,24,8],[-1,0,8],[-1,0,16],[3,24,16],
[3,24,8],[-1,0,16],[3,24,64],[3,24,8],
[-1,0,8],[-1,0,16],[-1,0,32],[4,24,64],
[4,24,8],[-1,0,8],[-1,0,16],[-1,0,32],
[7,24,64],[7,24,32],[7,24,8],[-1,0,8],
[-1,0,16],[7,24,64],[7,24,8],[-1,0,8],
[7,24,32],[7,24,16],[7,24,256],[7,24,32],
[7,24,16],[-1,0,16],[-1,0,64],[5,24,8],
[6,24,8],[6,24,16],[6,24,32],[6,24,16],
[-1,0,8],[5,24,32],[5,24,8],[5,24,256],
[5,24,32],[-1,0,16],[-1,0,64],[2,24,16],
[2,24,8],[2,24,8],[3,24,64],[-1,0,8],
[1,24,32],[1,24,8],[1,24,256],[1,24,64],
[1,24,16],[-1,0,8],[7,12,32],[7,12,16],
[1,24,8],[1,24,64],[-1,0,8],[5,24,32],
[5,24,8],[5,24,256],[5,24,32],[5,24,16],
[-1,0,8],[-1,0,64],[1,24,8],[2,24,8]]] @=> int note[][][];

// ----------quarter note, in second--------------
.625 => float quarter;
quarter/16 => float unit_quarter;

// multiply factor for frequency
1 => float factor;

// initialize channel loop counter variables
0 => int idxMand0 => int idxClar => int idxMand1;

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

// function to set mandolin #0 frequency & gain
fun void setMandolin0(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => m0.noteOff;
        return;
    }
    // get note from array channel 0
    getNoteFreq(instOrder[0], idx) => float freq;
    if (freq != 0)
    {
        freq => m0.freq;
        Math.random2f(0.1, 0.3) => m0.pluckPos;       // pluck position
        Math.random2f(0.01, 0.03) => m0.stringDetune; // detune string pairs
        Math.random2f(0.05, 0.15) => m0.bodySize;       // mandolin body size percentage
        1.0 => m0.noteOn;
    }
    else
        1.0 => m0.noteOff;
}

// function to set clarinet frequency & gain (channel 1)
fun void setClarinet(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => cla.noteOff;
        return;
    }
    // get note from array channel 1
    getNoteFreq(instOrder[1], idx) => float freq;
    if (freq != 0)
    {
        freq / 2 => cla.freq;
        Math.random2f(0.2, 0.5) => cla.pressure;   // pressure/volume
        Math.random2f(0.1, 0.3) => cla.vibratoGain; 
        1.0 => cla.noteOn;
    }
    else
        1.0 => cla.noteOff;
}

// function to set mandolin #1 frequency & gain (channel 5)
fun void setMandolin1(int idx, int OnOff)
{
    if (OnOff == 0)  // off
    {    
        1.0 => mb.noteOff;
        return;
    }
    // get note from array channel 2
    getNoteFreq(instOrder[2], idx) => float freq;
    if (freq != 0)
    {
        freq => mb.freq;
        Math.random2f(0.4, 0.8) => mb.pluckPos;       // pluck position
        Math.random2f(0.04, 0.08) => mb.stringDetune; // detune string pairs
        Math.random2f(0.4, 0.8) => mb.bodySize;       // mandolin body size percentage
        1.0 => mb.noteOn;
    }
    else
        1.0 => mb.noteOff;
}

// initial values of timing for channels' first notes, in ms
getDuration(instOrder[0], 0) + now => time endTimeMand0;
getDuration(instOrder[1], 0) + now => time endTimeClar;
getDuration(instOrder[2], 0) + now => time endTimeMand1;

// ---------- spork to call functions concurrently ----------
spork ~ playMandolin0();
spork ~ playClarinet();
spork ~ playMandolin1();

// keep parent alive
while (true) unit_quarter::second => now;

// function to play mandolin #0 notes
fun void playMandolin0()
{
    //------ loop over all notes ---------
    while (true) 
    {
        // if channel 0 duration is over, turn off & set next note
        if (now >= endTimeMand0)
        {
            // --------- STK instrument Mandolin --------
            setMandolin0(idxMand0, 0); // turn off previous mandolin note
            
            idxMand0++;
            (idxMand0 % note[instOrder[0]].cap()) => idxMand0;  // index to channel 0's next note
            if (idxMand0 < note[instOrder[0]].cap())   
            {
                // new duration for next mandolin note
                getDuration(instOrder[0], idxMand0) + now => endTimeMand0;
                setMandolin0(idxMand0, 1); // play next mandolin note
            }
        }
        
        // ------ if time >= 30 seconds then break ---------------
        if ( now >= later30 ) 
            break;
    
        // advance time by unit quarter
        unit_quarter::second => now;
    }
}

// function to play clarinet notes
fun void playClarinet()
{
    0 => int cnt;   // counter for sine wave panning
    
    //------ loop over all notes ---------
    while (true) 
    {
        // if channel 1 duration is over, turn off & set next note
        if (now >= endTimeClar)
        {
            // --------- STK instrument Clarinet --------
            setClarinet(idxClar, 0); // turn off previous note
            
            idxClar++;
            (idxClar % note[instOrder[1]].cap()) => idxClar;  // index to channel 1's next note
            if (idxClar < note[instOrder[1]].cap())   
            {
                // new duration for next note
                getDuration(instOrder[1], idxClar) + now => endTimeClar;
                setClarinet(idxClar, 1); // play next note
            }
            
            // sine wave panning, -pi to pi
            (cnt % 13) => float mod13;
            Math.sin(((mod13 / 6) - 1) * Math.PI) => p1.pan;
            cnt++;
        }
        
        // ------ if time >= 30 seconds then break ---------------
        if ( now >= later30 ) 
            break;
    
        // advance time by unit quarter
        unit_quarter::second => now;
    }
}

// function to play mandolin #1 notes
fun void playMandolin1()
{
    //------ loop over all notes ---------
    while (true) 
    {
        // if channel 2 duration is over, turn off & set next note
        if (now >= endTimeMand1)
        {
            // --------- STK instrument Mandolin --------
            setMandolin1(idxMand1, 0); // turn off previous mandolin note
            
            idxMand1++;
            (idxMand1 % note[instOrder[2]].cap()) => idxMand1;  // index to channel 2's next note
            if (idxMand1 < note[instOrder[2]].cap())   
            {
                // new duration for next mandolin note
                getDuration(instOrder[2], idxMand1) + now => endTimeMand1;
                setMandolin1(idxMand1, 1); // play next mandolin note
            }
        }
        
        // ------ if time >= 30 seconds then break ---------------
        if ( now >= later30 ) 
            break;
    
        // advance time by unit quarter
        unit_quarter::second => now;
    }
}
