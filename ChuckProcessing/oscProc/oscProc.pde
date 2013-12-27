// oscProc.pde
// @soesilo wijono
// a very basic example of communication from/to ChucK

// http://www.sojamo.de/libraries/oscP5/
// http://electro-music.com/forum/post-322758.html, etc..

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation;

String oscServer = "127.0.0.1";
int oscServerPortSend = 6449;
int oscServerPortReceive = 6450;

String pattern = "";
String tagType = "";
float val = 0;

void setup() {
  size(400, 400);
  frameRate(24);
  smooth();
  
  textAlign(LEFT, TOP);
  background(0);
  
  // Instantiation of a new oscP5 object
  oscP5 = new OscP5(this, oscServerPortReceive);

  // Address of the osc receiver
  myBroadcastLocation = new NetAddress(oscServer, oscServerPortSend);
  
}

void draw() {
  background(0);
  // any drawing ..
  
  // display message
  fill(255);
  text("### received an osc message.", 10, 10);
  text(" addrpattern: " + pattern, 10, 30);
  text(" typetag: " + tagType, 10, 50);
  text(" value: " + val, 10, 70);
}


void oscEvent(OscMessage theOscMessage) {
  pattern = theOscMessage.addrPattern();
  tagType = theOscMessage.typetag();
  val = theOscMessage.get(0).floatValue();
} 

void keyPressed() {
  switch(key) {
    case('s'): case('S'):
      OscMessage myOscMessage = new OscMessage("/hello");
      // add a value to the OscMessage
      myOscMessage.add("Hello world! " + val);
      // send the OscMessage to a remote location specified in myNetAddress
      oscP5.send(myOscMessage, myBroadcastLocation);
      break;
    
    default:
      break;
  }
}
