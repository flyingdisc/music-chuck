// smandolin.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelMandolin extends ChannelInstrument 
{
    // STK instrument, mandolin with panning
    // and John Chowning (JC) reverberator as STK audio effect
    Mandolin mandolin @=> stkInst => JCRev rev => iPan => dac;
    
    // STK instrument's variables
    float minPluck, maxPluck;
    float minDamping, maxDamping;
    float minBody, maxBody;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain,   // overload
                    float minpluck, float maxpluck, 
                    float mindamping, float maxdamping,
                    float minbody, float maxbody, int ispan)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        96 => panningPeriod;  // set panning sine wave period to n loop
        gain => stkInst.gain;   // default gain
        2 => mulFactor;
        ispan => isPanning;
        
        minpluck => minPluck;
        maxpluck => maxPluck;
        mindamping => minDamping;
        maxdamping => maxDamping;
        minbody => minBody;
        maxbody => maxBody;
        
        // STK effect parameters
        0.05 => rev.mix;      // reverb mix level
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        Math.random2f(minPluck, maxPluck) => mandolin.pluckPos;  // pluck position
        0 => mandolin.stringDetune; // detune string pairs
        Math.random2f(minDamping, maxDamping) => mandolin.stringDamping; 
        Math.random2f(minBody, maxBody) => mandolin.bodySize;    // mandolin body size percentage
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

ChannelMandolin cm1;
ChannelMandolin cm2;
ChannelMandolin cm3;

// create mandolin STK instruments on 3 channels
cm1.createChannel(2, 0.3, 0.3, 0.6, 0.7, 0.9, 0.3, 0.5, 1);
cm2.createChannel(3, 0.3, 0.5, 0.8, 0.4, 0.6, 0.2, 0.3, 0);
cm3.createChannel(4, 0.3, 0.2, 0.3, 0.7, 0.8, 0.3, 0.4, 1);

cm1.setNewDuration();
cm2.setNewDuration();
cm3.setNewDuration();

// ---------- spork to call functions concurrently ---------
spork ~ playMandolin(cm1);
spork ~ playMandolin(cm2);  // bass
spork ~ playMandolin(cm3); 

// keep parent alive
while (true) tempo.quarterNote/16 => now;

fun void playMandolin(ChannelMandolin cm)
{
    while (true) 
    {
        cm.playInstrument();  
        
        if ( now >= laterTime ) 
            break;
    
        tempo.quarterNote/16 => now;
    }
}
