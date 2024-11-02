/* Receive Blob Data
 * Thomas Kaufmanas
 * Based on oscP5sendreceive by andreas schlegel
 *
 * This example receives Blob Data from the AIRLab Kinect Blob Tracker PDE software by Halfdan Hauch
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress address_location;

float raw_x = 0;
float raw_y = 0;
FloatList raw_data;
boolean new_data = false;





void setup() {
  size(640, 480);
  frameRate(60);
  oscP5 = new OscP5(this, 6789);
  address_location = new NetAddress("127.0.0.1", 12345);
  raw_data = new FloatList();

  background(0);
  legend();
}


void draw() {

  if (new_data) {
    noStroke();
    fill(204);
    circle(raw_x, raw_y, 10);

    new_data = false;

    legend();
  }



  //raw_data.clear(); //If storing data in array, remember to sequentially clear it!
}




/*
An event based function, triggered whenever there is incomming OSC data
 */
void oscEvent(OscMessage theOscMessage) {


  println("New Input: " + theOscMessage.get(0).intValue() +" | "+theOscMessage.get(1).intValue());
  //Get() takes parameter index of message object structure:
  // X | Y | Min depth | ID | NR_of_pixels


  raw_x = theOscMessage.get(0).intValue();
  raw_y = theOscMessage.get(1).intValue();

  //raw_data.append(raw); //Add raw data to array

  new_data = true;
}




/*
Text overlay. Useful to call when refreshing the window
 */
void legend() {
  fill(0);
  rect(19, 5, 250, 55);
  fill(255);
  textSize(18);
  text("Interactive Materiality Sketch 1.0", 20, 20);
  textSize(12);

  text(("raw_X = " + raw_x), 20, 35);
  text(("raw_Y = " + raw_y), 20, 50);
}
