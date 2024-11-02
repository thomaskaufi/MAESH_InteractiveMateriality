/* Sketch for tracking cursor presence in specific areas
 * By Guilia Talamini
 *
 */



Circle[] circles;    // Array to store the circle objects
int numCircles = 20;  // Number of circles
int hoveredIndex = -1;  // Track the currently hovered circle index

void setup() {
  size(600, 600);
  circles = new Circle[numCircles];

  // Create random non-overlapping circles
  for (int i = 0; i < numCircles; i++) {
    Circle newCircle = new Circle(random(50, width - 50), random(50, height - 50), 50);

    boolean overlap;
    do {
      overlap = false;
      for (int j = 0; j < i; j++) {
        if (newCircle.intersects(circles[j])) {
          newCircle = new Circle(random(50, width - 50), random(50, height - 50), 50);
          overlap = true;
          break;
        }
      }
    } while (overlap);
    
    circles[i] = newCircle;
  }
}

void draw() {
  background(255);
  int currentHoveredIndex = -1;  // Variable to track the currently hovered circle in this frame

  // Draw and check hover for each circle
  for (int i = 0; i < numCircles; i++) {
    circles[i].display();
    
    if (circles[i].isHovered(mouseX, mouseY)) {
      circles[i].highlight();
      currentHoveredIndex = i;  // Update the hovered index for this frame
      println("Hovered over circle index: " + i);  // Print which circle is hovered
    }
  }

  // If no circle is hovered, reset hoveredIndex
  if (currentHoveredIndex == -1 && hoveredIndex != -1) {
    println("No circle hovered");
  }

  // Update the main hoveredIndex to track the hovered circle
  hoveredIndex = currentHoveredIndex;
}

// Circle class
class Circle {
  float x, y, radius;

  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.radius = r;
  }

  void display() {
    fill(100);
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
