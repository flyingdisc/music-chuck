// @Soesilo Wijono
// initialize.ck
// Assignment_7_Flying_DrumCycles
<<< "----Assignment_7_Flying_DrumCycles----" >>>;

// Add all public classes
// BPM conductor / beat-timer class
Machine.add(me.dir() + "/BPM.ck");

// Public classes..
// Notes container class
Machine.add(me.dir() + "/FlyingNotes.ck") => int notesID;

// STK instrument channel classes
Machine.add(me.dir() + "/FlyingMandoClass.ck") => int classMandolinID;
Machine.add(me.dir() + "/FlyingShakeClass.ck") => int classShakeID;

// Add score file
Machine.add(me.dir() + "/score.ck");
