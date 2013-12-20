// sshakers.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelShakers extends ChannelInstrument 
{
    // STK instrument, shakers
    // and John Chowning (JC) reverberator as STK audio effect
    Shakers shakers @=> stkInst => JCRev rev => iPan => dac;
    
    // STK instrument's variables
    float minObject, maxObject;
    float minDecay, maxDecay;
    int optPreset;
    float optEnergy;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain,        // overload
                          int optpreset, float optenergy, 
                          float minobject, float maxobject, 
                          float mindecay, float maxdecay)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        184 => panningPeriod;  // set panning sine wave period to n loop
        gain => stkInst.gain;   // default gain
        2 => mulFactor;
        1 => isPanning;
        
        optpreset => optPreset;
        optenergy => optEnergy;
        minobject => minObject;
        maxobject => maxObject;
        mindecay => minDecay;
        maxdecay => maxDecay;
        
        // STK effect parameters
        0.2 => rev.mix;      // reverb mix level
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        optPreset => shakers.preset;
        Math.random2f(minObject, maxObject) => shakers.objects;
        Math.random2f(minDecay, maxDecay) => shakers.decay;
        optEnergy => shakers.energy;
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

// instantiation object
ChannelShakers csh1;

// create a shakers STK instrument on a channel
csh1.createChannel(1, 0.4, 20, 1.0, 40.0, 80.0, 0.4, 1.0);

// initial values of timing for channel's first notes
csh1.setNewDuration();

// ---------- spork to call functions concurrently ---------
spork ~ playShakers(csh1);

// keep parent alive
while (true) tempo.quarterNote/16 => now;

fun void playShakers(ChannelShakers csh)
{
    while (true) 
    {
        csh.playInstrument();  
        
        if ( now >= laterTime ) 
            break;
    
        tempo.quarterNote/16 => now;
    }
}
