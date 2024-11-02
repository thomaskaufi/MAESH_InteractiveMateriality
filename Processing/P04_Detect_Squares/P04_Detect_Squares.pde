Square[] squares;    // Array to store the square objects
int numSquares;      // Total number of squares
int hoveredIndex = -1;  // Track the previously hovered square index
int cols, rows;      // Number of columns and rows
float squareSize = 40; // Size of each square

void setup() {
  size(600, 600);

  // Calculate number of columns and rows based on window size and square size
  cols = floor(width / squareSize);
  rows = floor(height / squareSize);
  numSquares = cols * rows;  // Total number of squares
  
  squares = new Square[numSquares];

  // Create squares in a grid layout
  int index = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float x = j * squareSize;
      float y = i * squareSize;
      squares[index] = new Square(x, y, squareSize);
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
    
    if (squares[i].isHovered(mouseX, mouseY)) {
      currentHoveredIndex = i;  // Update the currently hovered square index
    }
  }

  // If the hovered square has changed, print and update hoveredIndex
  if (currentHoveredIndex != -1 && currentHoveredIndex != hoveredIndex) {
    println("Hovered over square index: " + currentHoveredIndex);  // Print when a new square is hovered
    hoveredIndex = currentHoveredIndex;  // Update the hovered index
  }
}

// Square class
class Square {
  float x, y, size;

  Square(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void display() {
    fill(100);  // Default color
    rect(x, y, size, size);
  }

  boolean isHovered(float mx, float my) {
    // Check if the mouse is within the square's boundaries
    return mx >= x && mx <= x + size && my >= y && my <= y + size;
  }
}
