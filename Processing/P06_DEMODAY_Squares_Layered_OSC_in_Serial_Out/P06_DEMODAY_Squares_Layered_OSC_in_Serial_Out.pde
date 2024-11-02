/* Sketch for tracking kinect blob presence in specific areas
 * Giulia Talamini / Thomas Kaufmanas
 * Interactive Materiality 2024
 *
 * Utilizes code from oscP5sendreceive by andreas schlegel and AIRLab Kinect Blob Tracker by Halfdan Hauch
 */
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress address_location;

//Variables to store Blob Input from OSC
float raw_x = 0;
float raw_y = 0;
float raw_x_inv = 0;
float raw_y_inv = 0;
float raw_y_push = 0;

import processing.serial.*;

Serial myPort;
Square[] squares;  // Array to store the square objects
int numSquares;    // Total number of squares
int hoveredIndex = -1;  // Track the previously hovered square index
int cols, rows;    // Number of columns and rows
float squareSize = 120; // Size of each square

void setup() {
  size(600, 600);

  // Initialize serial communication with Arduino
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);

  // Calculate number of columns and rows based on window size and square size
  cols = floor(width / squareSize);
  rows = floor(height / squareSize);
  numSquares = cols * rows;  // Total number of squares

  squares = new Square[numSquares];

  oscP5 = new OscP5(this, 6789);
  address_location = new NetAddress("127.0.0.1", 12345);

  // Create squares in a grid layout
  int index = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float x = j * squareSize;
      float y = i * squareSize;
      int layer = determineLayer(i, j);  // Determine which layer the square belongs to
      squares[index] = new Square(x, y, squareSize, layer);
      index++;
    }
  }
}

void draw() {
  background(255);
  int currentHoveredIndex = -1;  // Variable to track the currently hovered square in this frame

  // Draw and check hover for each square
  for (int i = 0; i < numSquares; i++) {
    squares[i].display();

    if (squares[i].isHovered(raw_x, raw_y_push)) {
      squares[i].highlight();  // Highlight hovered square
      currentHoveredIndex = i;  // Update the hovered square index
    }
  }

  // Only send signal when the hover state changes
  if (currentHoveredIndex != hoveredIndex) {
    if (currentHoveredIndex != -1) {
      int hoveredLayer = squares[currentHoveredIndex].layer;
      println("Hovered over square in layer: " + hoveredLayer);
      myPort.write(hoveredLayer + "\n");  // Send the layer value (1, 3, or 5) to Arduino
    } else {
      println("No square hovered");
      myPort.write("-1\n");  // Send -1 if no square is hovered
    }
    hoveredIndex = currentHoveredIndex;  // Update the last hovered index
  }

  noStroke();
  fill(204);
  circle(raw_x, raw_y_push, 10);
  legend();
} //End of draw

// Function to determine which layer the square belongs to
int determineLayer(int row, int col) {
  int centerRow = floor(rows / 2);
  int centerCol = floor(cols / 2);

  // Calculate the Manhattan distance from the center
  int distance = max(abs(row - centerRow), abs(col - centerCol));

  // Assign layers based on distance
  if (distance == 0) {
    return 5;  // Middle square
  } else if (distance == 1) {
    return 3;  // Surrounding layer
  } else {
    return 1;  // Outermost layer
  }
}

// Square class
class Square {
  float x, y, size;
  int layer;  // Variable to store which layer the square belongs to

  Square(float x, float y, float size, int layer) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.layer = layer;
  }

  void display() {
    fill(100);  // Default color
    rect(x, y, size, size);
  }

  void highlight() {
    fill(255, 0, 0);  // Highlight color
    rect(x, y, size, size);
  }

  boolean isHovered(float mx, float my) {
    // Check if the mouse is within the square's boundaries
    return mx >= x && mx <= x + size && my >= y && my <= y + size;
  }
}

void oscEvent(OscMessage theOscMessage) {


  //println("New Input: " + theOscMessage.get(0).intValue() +" | "+theOscMessage.get(1).intValue());
  //Get() takes parameter index of message object structure:
  // X | Y | Min depth | ID | NR_of_pixels


  raw_x = theOscMessage.get(0).intValue();
  raw_y = theOscMessage.get(1).intValue();
  raw_y_push = raw_y + 120;

  raw_x_inv = map(raw_x, 0, 640, 640, 0);
  raw_y_inv = map(raw_y, 0, 400, 400, 0);
}

void legend() {
  fill(0);
  rect(19, 5, 250, 55);
  fill(255);
  textSize(18);
  text("Interactive Materiality Sketch 4.3", 20, 20);
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
