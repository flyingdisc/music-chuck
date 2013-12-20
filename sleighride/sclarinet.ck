// sclarinet.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelClarinet extends ChannelInstrument 
{
    // STK instrument, Clarinet
    // with JC reverberator and Delay as STK audio effect
    Clarinet clarinet @=> stkInst => JCRev rev => iPan => dac;
    stkInst => Delay d => rev;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain)   // overload
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        24 => panningPeriod;  // set panning sine wave period to n loop
        gain => stkInst.gain;   // default gain
        2 => mulFactor;
        1 => isPanning;
        // STK effect parameters
        0.1 => rev.mix;      // reverb mix level
        0.2::second => d.max => d.delay;    // delay time
        0.1 => d.gain;       // delay gain
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        Math.random2f(0.7, 0.9) => clarinet.reed;
        Math.random2f(0.5, 0.9) => clarinet.pressure;
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

// instantiation object of ChannelClarinet class
ChannelClarinet cc1;
ChannelClarinet cc2;

// create Clarinet STK instruments on 2 channels
cc1.createChannel(5, 0.3); 
cc2.createChannel(8, 0.3); 

// initial values of timing for channel's first notes
cc1.setNewDuration();
cc2.setNewDuration();

spork ~ playClarinet(cc1);
spork ~ playClarinet(cc2);

// keep parent alive
while (true) tempo.quarterNote/16 => now;

fun void playClarinet(ChannelClarinet cc)
{
    while (true) 
    {
        cc.playInstrument();
        
        if ( now >= laterTime ) 
            break;

        tempo.quarterNote/16 => now;
    }
}
