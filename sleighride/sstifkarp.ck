// sstifkarp.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelStifKarp extends ChannelInstrument 
{
    // STK instrument, StifKarp
    // with JC reverberator and Delay as STK audio effect
    StifKarp stifkarp @=> stkInst => JCRev rev => dac;
    stkInst => Delay d => rev;
    
    // STK instrument's variables
    float minPickup, maxPickup;
    float minSustain, maxSustain;
    float minStretch, maxStretch;
    float minPluck, maxPluck;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain,      // overload
                float minpickup, float maxpickup,
                float minsustain, float maxsustain,
                float minstretch, float maxstretch,
                float minpluck, float maxpluck)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        0 => panningPeriod;      // no use
        gain => stkInst.gain;   // default gain
        2 => mulFactor;
        0 => isPanning;
        
        minpickup => minPickup;
        maxpickup => maxPickup;
        minsustain => minSustain;
        maxsustain => maxSustain;
        minstretch => minStretch;
        maxstretch => maxStretch;
        minpluck => minPluck;
        maxpluck => maxPluck;
        
        // STK effect parameters
        0.1 => rev.mix;      // reverb mix level
        0.1::second => d.max => d.delay;    // delay time
        0.1 => d.gain;       // delay gain
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        /*
        Math.random2f(minPickup, maxPickup) => stifkarp.pickupPosition;
        Math.random2f(minSustain, maxSustain) => stifkarp.sustain;  // string sustain
        Math.random2f(minStretch, maxStretch) => stifkarp.stretch;  // string stretch
        Math.random2f(minPluck, maxPluck) => stifkarp.pluck;  // pluck string
        */
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

// instantiation object of ChannelStifKarp class
ChannelStifKarp csk1;

// create a StifKarp STK instrument on a channel
//                         pickup    sustain   stretch   pluck
csk1.createChannel(7, 0.5, 0.7, 0.9, 0.7, 0.9, 0.7, 0.9, 0.1, 0.3);

// initial values of timing for channel's first notes
csk1.setNewDuration();

spork ~ playStifKarp(csk1);

// keep parent alive
while (true) tempo.quarterNote/16 => now;

fun void playStifKarp(ChannelStifKarp csk)
{
    while (true) 
    {
        csk.playInstrument();
        
        if ( now >= laterTime ) 
            break;
    
        tempo.quarterNote/16 => now;
    }
}
