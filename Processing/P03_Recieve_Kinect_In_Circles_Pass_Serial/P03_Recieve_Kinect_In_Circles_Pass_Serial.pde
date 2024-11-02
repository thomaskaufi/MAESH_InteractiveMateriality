/* Sketch for tracking curso presence in specific areas
 * Giulia Talamini / Thomas Kaufmanas
 * Interactive Materiality 2024
 *
 * Utilizes code from oscP5sendreceive by andreas schlegel and AIRLab Kinect Blob Tracker by Halfdan Hauch
 */

import processing.serial.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress address_location;

//Variables to store Blob Input from OSC
float raw_x = 0;
float raw_y = 0;
float raw_x_inv = 0;
float raw_y_inv = 0;

Serial myPort;
Circle[] circles;       // Array to store the circle objects
int numCircles = 5;     // Number of circles
int hoveredIndex = -1;  // Track the currently hovered circle index
int currentHoveredIndex = -1;  // Variable to track the currently hovered circle in this frame


void setup() {
  size(640, 480);
  frameRate(60);
  circles = new Circle[numCircles];

  oscP5 = new OscP5(this, 6789);
  address_location = new NetAddress("127.0.0.1", 12345);

  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);

  // Create random non-overlapping circles
  for (int i = 0; i < numCircles; i++) {
    Circle newCircle = new Circle(random(50, width - 50), random(50, height - 50), 100);

    boolean overlap;
    do {
      overlap = false;
      for (int j = 0; j < i; j++) {
        if (newCircle.intersects(circles[j])) {
          newCircle = new Circle(random(50, width - 50), random(50, height - 50), 100);
          overlap = true;
          break;
        }
      }
    } while (overlap);

    circles[i] = newCircle;
  }
}

void draw() {
  background(0);

  // Draw and check hover for each circle
  for (int i = 0; i < numCircles; i++) {
    circles[i].display();

    if (circles[i].isHovered(raw_x_inv, raw_y_inv)) {
      circles[i].highlight();
      currentHoveredIndex = i;  // Update the hovered index for this frame
    }
  }

  //only send signal when the hover state changes
  if (currentHoveredIndex != hoveredIndex) {
    if (currentHoveredIndex != -1) {
      println("PROCESSING SENDS" + currentHoveredIndex);
      myPort.write(currentHoveredIndex + "\n");  // Send the hovered index to Arduino
    } else {
      println("processing sees nothing<3");
      myPort.write("-1");  // Send -1 if no circle is hovered
    }
    hoveredIndex = currentHoveredIndex;
  }

  noStroke();
  fill(204);
  circle(raw_x_inv, raw_y_inv, 10);
  legend();
} //End of Draw

// Circle class
class Circle {
  float x, y, radius;

  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.radius = r;
  }

  void display() {
    fill(255);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean isHovered(float mx, float my) {
    return dist(mx, my, x, y) < radius;
  }

  void highlight() {
    fill(255, 0, 0);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean intersects(Circle other) {
    return dist(this.x, this.y, other.x, other.y) < (this.radius + other.radius);
  }
}


//An event based function, triggered whenever there is incomming OSC data
void oscEvent(OscMessage theOscMessage) {


  //println("New Input: " + theOscMessage.get(0).intValue() +" | "+theOscMessage.get(1).intValue());
  //Get() takes parameter index of message object structure:
  // X | Y | Min depth | ID | NR_of_pixels


  raw_x = theOscMessage.get(0).intValue();
  raw_y = theOscMessage.get(1).intValue();

  raw_x_inv = map(raw_x, 0, 640, 640, 0);
  raw_y_inv = map(raw_y, 0, 400, 400, 0);
}

void legend() {
  fill(0);
  rect(19, 5, 250, 55);
  fill(255);
  textSize(18);
  text("Interactive Materiality Sketch 2.0", 20, 20);
  textSize(12);

  text(("raw_X = " + raw_x), 20, 35);
  text(("raw_Y = " + raw_y), 20, 50);
}

void serialEvent(Serial p) {
  // get message till line break (ASCII > 13)
  String message = myPort.readStringUntil(13);
  if (message != null) {
    println(message);
  }
}
