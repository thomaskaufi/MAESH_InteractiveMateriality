Square[] squares;    // Array to store the square objects
int numSquares;      // Total number of squares
int hoveredIndex = -1;  // Track the previously hovered square index
int cols, rows;      // Number of columns and rows
float squareSize = 120; // Size of each square

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
    
    if (squares[i].isHovered(mouseX, mouseY)) {
      currentHoveredIndex = i;  // Update the currently hovered square index
    }
  }

  // If the hovered square has changed, print and update hoveredIndex
  if (currentHoveredIndex != -1 && currentHoveredIndex != hoveredIndex) {
    println("Hovered over square layer: " + squares[currentHoveredIndex].layer);  // Print the layer of the hovered square
    hoveredIndex = currentHoveredIndex;  // Update the hovered index
  }
}

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

  boolean isHovered(float mx, float my) {
    // Check if the mouse is within the square's boundaries
    return mx >= x && mx <= x + size && my >= y && my <= y + size;
  }
}
