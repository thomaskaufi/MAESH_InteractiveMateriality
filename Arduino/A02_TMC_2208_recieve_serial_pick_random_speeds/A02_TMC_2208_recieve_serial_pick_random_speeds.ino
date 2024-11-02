#include <TMCStepper.h>
#include <SoftwareSerial.h>  // allows for more serial. more serial more better

#define DIR_PIN_1 3   // Direction
#define STEP_PIN_1 4  // Step
#define EN_PIN_1 5    // Enable

#define SW_RX 12                  // TMC2208/TMC2224 SoftwareSerial receive pins
#define SW_TX 10                  // TMC2208/TMC2224 SoftwareSerial transmit pin
#define DRIVER_ADDRESS 0b00       // TMC2209 Driver address according to MS1 and MS2
#define R_SENSE 0.11f             // Match to your driver
#define MICROSTEPS 1              // Set to full step mode
#define STEPS_PER_REVOLUTION 200  // Full steps for one revolution

TMC2209Stepper driver(SW_RX, SW_TX, R_SENSE, DRIVER_ADDRESS);

const int speedOptions[5] = { 1, 5, 10, 15, 25 };  // Different speeds
const int dirOptions[2] = { HIGH, LOW };           // Two directions
volatile bool keepRunning = true;                  // A flag indicating whether the motor should continue running.
int currentSpeed = 15;                             // Default speed ??
int currentDirection = LOW;                        // Default direction ??

void setup() {
  pinMode(EN_PIN_1, OUTPUT);
  pinMode(STEP_PIN_1, OUTPUT);
  pinMode(DIR_PIN_1, OUTPUT);
  digitalWrite(EN_PIN_1, LOW);

  Serial.begin(9600);

  driver.beginSerial(115200);
  driver.begin();
  driver.toff(5);
  driver.rms_current(1200);
  driver.pwm_autoscale(true);

  // Set to full step mode
  driver.microsteps(1);  // Set to full steps (no microstepping)

  randomSeed(analogRead(0));  // Initialize random seed
}

void loop() {
  // Check if data is available from Processing
  if (Serial.available() > 0) {
    int receivedIndex = Serial.parseInt();  // Parse integer from serial input
    Serial.println(receivedIndex);

    // If a valid index (>= 0), set motor running state to true
    if (receivedIndex >= 0) {
      keepRunning = true;                           // Start the motor
      currentSpeed = speedOptions[random(0, 5)];    // Pick a random speed
      currentDirection = dirOptions[random(0, 2)];  // Pick a random direction
      digitalWrite(DIR_PIN_1, currentDirection);    // Set motor direction
    } else {
      //keepRunning = false; // Stop the motor
      keepRunning = true;  // start the motor
      currentSpeed = 15;
      //Serial.println("Motor OFF: No circle hovered.");
    }
  }

  // Rotate the motor if keepRunning is true
  if (keepRunning) {
    rotateMotor();
  }
}

// Function to rotate the stepper motor continuously
void rotateMotor() {
  digitalWrite(STEP_PIN_1, HIGH);
  delayMicroseconds(10);  // Short pulse for the step signal
  digitalWrite(STEP_PIN_1, LOW);
  delay(currentSpeed);  // Adjust delay for motor speed
}
