// score.ck
// Assignment_7_Flying_DrumCycles

// save the time for 30 seconds later as the assignment limit
now => time start30;
now + 30::second => time later30;

// assignment quarter notes = 0.625 second
0.625 => float tQuarter;

// beats per minute = 60 seconds / quarter
60.0 / tQuarter => float beatPerMinute;

// object of FlyingBPM (BPM.ck) class, as conductor for tempo
FlyingBPM tempo;
tempo.tempo(beatPerMinute);

// adding all shreds
// Drums
Machine.add(me.dir() + "/FlyingSnare.ck") => int snareID;
Machine.add(me.dir() + "/FlyingKick.ck") => int kickID;
Machine.add(me.dir() + "/FlyingHihat.ck") => int hihatID;
Machine.add(me.dir() + "/FlyingCowbell.ck") => int cowbellID;

// STK instruments & oscillator
Machine.add(me.dir() + "/FlyingMandolin.ck") => int mandolinID;
Machine.add(me.dir() + "/FlyingShaker.ck") => int shakerID;
Machine.add(me.dir() + "/FlyingOscClass.ck") => int channeloscID;

// keep parent alive
while (true)
{
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    tempo.quarterNote => now;
}    

// remove all shreds
Machine.remove(snareID);
Machine.remove(kickID);
Machine.remove(hihatID);
Machine.remove(cowbellID);

Machine.remove(mandolinID);
Machine.remove(shakerID);
Machine.remove(channeloscID);

// print time elapsed
<<< "----Total Duration: ", (now-start30)/second, "seconds" >>>;