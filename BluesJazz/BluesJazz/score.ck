// @Soesilo Wijono
// score.ck
// Assignment_6_Blues_Jazz_Meet_Traditional
<<< "----Assignment_6_Blues_Jazz_Meet_Traditional----" >>>;

// save the time for 30 seconds later as the assignment limit
now => time start30;
now + 30::second => time later30;

Machine.add(me.dir() + "/drums.ck") => int drumsID;
Machine.add(me.dir() + "/bass.ck") => int bassID;
Machine.add(me.dir() + "/piano.ck") => int pianoID;

// ----------quarter note, in second--------------
.625 => float quarter;
quarter/16 => float unit_quarter;

// keep parent alive
while (true)
{
    // ------ if time >= 30 seconds then break ---------------
    if ( now >= later30 ) 
        break;
    
    unit_quarter::second => now;
}    

Machine.remove(drumsID);
Machine.remove(bassID);
Machine.remove(pianoID);

// print time elapsed
<<< "----Total Duration: ", (now-start30)/second, "seconds" >>>;