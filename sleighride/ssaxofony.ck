// ssaxofony.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

class ChannelSaxofony extends ChannelInstrument 
{
    // STK instrument Saxofony
    // with JC reverberator and Delay as STK audio effect
    Saxofony saxofon @=> stkInst => JCRev rev => iPan => dac;
    stkInst => Delay d => rev;
    0.7 => iPan.pan;  // right panning
    
    // STK instrument's variables
    float minStiffness, maxStiffness;
    float minAperture, maxAperture;
    float minBlowPos, maxBlowPos;
    float minPressure, maxPressure;
    
    // create an instrument channel with supplied index
    fun void createChannel(int idx, float gain,       // overload
                float minstiffness, float maxstiffness,
                float minaperture, float maxaperture,
                float minblowpos, float maxblowpos,
                float minpressure, float maxpressure)
    {
        idx => channelIndex;
        0 => channelCounter;
        0 => panningCounter;
        0 => panningPeriod;   // no use
        gain => stkInst.gain;   // default gain
        1 => mulFactor;
        0 => isPanning;
        
        minstiffness => minStiffness;
        maxstiffness => maxStiffness;
        minaperture => minAperture;
        maxaperture => maxAperture;
        minblowpos => minBlowPos;
        maxblowpos => maxBlowPos;
        minpressure => minPressure;
        maxpressure => maxPressure;
        
        // STK effect parameters
        0.1 => rev.mix;      // reverb mix level
        0.1::second => d.max => d.delay;    // delay time
        0.1 => d.gain;       // delay gain
    }
    
    // set stk instrument parameters
    fun void setStkParams() {
        Math.random2f(minStiffness, maxStiffness) => saxofon.stiffness; // reed stiffness
        Math.random2f(minAperture, maxAperture) => saxofon.aperture;  // reed aperture
        Math.random2f(minBlowPos, maxBlowPos) => saxofon.blowPosition;  // lip stiffness
        Math.random2f(minPressure, maxPressure) => saxofon.pressure;  // volume
    }
}

QBPM tempo;
now + tempo.oAllDur::second => time laterTime;

// instantiation object
ChannelSaxofony csx1;

// create a  STK instrument on a channel
//                         stiffness aperture  blow      pressure
csx1.createChannel(6, 0.3, 0.4, 0.5, 0.4, 0.5, 0.2, 0.8, 0.5, 0.9);

// initial values of timing for channel's first notes
csx1.setNewDuration();

spork ~ playSaxofony(csx1);

// keep parent alive
while (true) tempo.quarterNote/16 => now;

// function to play brass notes
fun void playSaxofony(ChannelSaxofony csx)
{
    //------ loop over all notes ---------
    while (true) 
    {
        csx.playInstrument();
        
        if ( now >= laterTime ) 
            break;
    
        tempo.quarterNote/16 => now;
    }
}
