// score.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono

0.32 => float beat;
60.0 / beat => float beatPerMinute;
QBPM tempo;
tempo.tempo(beatPerMinute);

now => time startTime;
now + tempo.oAllDur::second => time laterTime;

// STK instruments
Machine.add(me.dir() + "/smandolin.ck") => int mandolinID;
Machine.add(me.dir() + "/spiano.ck") => int pianoID;
Machine.add(me.dir() + "/sclarinet.ck") => int clarinetID;
Machine.add(me.dir() + "/sshakers.ck") => int shakersID;
Machine.add(me.dir() + "/ssaxofony.ck") => int saxofonyID;
Machine.add(me.dir() + "/sstifkarp.ck") => int stifkarpID;

// keep parent alive
while (true)
{
    if ( now >= laterTime ) 
        break;
    tempo.eighthNote => now;
}    

Machine.remove(mandolinID);
Machine.remove(pianoID);
Machine.remove(clarinetID);
Machine.remove(shakersID);
Machine.remove(saxofonyID);
Machine.remove(stifkarpID);

// print time elapsed
<<< "----Total Duration: ", (now-startTime)/second, "seconds" >>>;
