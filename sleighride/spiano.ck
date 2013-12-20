// spiano.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelPiano extends ChannelInstrument 
{
    // STK instrument, Wurley
    // with JC reverberator and Delay as STK audio effect
    Wurley piano @=> stkInst => JCRev rev => dac;
    stkInst => Delay d => rev;
    
    // STK instrument's variables
    float minTouch, maxTouch;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain, 
                    float mintouch, float maxtouch)   // overload
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        0 => panningPeriod;  // not used
        gain => stkInst.gain;   // default gain
        1 => mulFactor;
        0 => isPanning;
        
        mintouch => minTouch;
        maxtouch => maxTouch;
        
        // STK effect parameters
        0.1 => rev.mix;      // reverb mix level
        0.2::second => d.max => d.delay;    // delay time
        0.2 => d.gain;       // delay gain
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        Math.random2f(minTouch, maxTouch) => piano.afterTouch;
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

// instantiation object of ChannelPiano class
ChannelPiano cp1;

// create a piano STK instrument on a channel
cp1.createChannel(9, 0.6, 0.3, 0.8);

// initial values of timing for channel's first notes
cp1.setNewDuration();

spork ~ playPiano(cp1);

// keep parent alive
while (true) tempo.quarterNote/16 => now;

fun void playPiano(ChannelPiano cp)
{
    while (true) 
    {
        cp.playInstrument();
        
        if ( now >= laterTime ) 
            break;
    
        tempo.quarterNote/16 => now;
    }
}
