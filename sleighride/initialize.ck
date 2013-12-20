// initialize.ck
// Christmas Carol Sleighride, Phil Spector Arangement
// ChucKed by Soesilo Wijono
<<< "----Christmas-Carol-Sleighride----" >>>;

// BPM conductor / beat-timer class
Machine.add(me.dir() + "/BPM.ck");

// Notes container class
Machine.add(me.dir() + "/snotes.ck") => int notesID;

// STK instrument channel class
Machine.add(me.dir() + "/sinstrumentclass.ck") => int classInstrumentID;

// Add score file
Machine.add(me.dir() + "/score.ck");
