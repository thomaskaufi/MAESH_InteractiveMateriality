/*
Code to run stepper at different speed based on serial message from processing sketch.

Giulia Talamini and Thomas Kaufmanas
*/


#include <TMCStepper.h>
#include <SoftwareSerial.h>

#define DIR_PIN_1          3
#define STEP_PIN_1         4
#define EN_PIN_1           5
#define SW_RX              12
#define SW_TX              10
#define DRIVER_ADDRESS     0b00
#define R_SENSE            0.11f
#define MICROSTEPS         1
#define STEPS_PER_REVOLUTION 200

TMC2209Stepper driver(SW_RX, SW_TX, R_SENSE, DRIVER_ADDRESS);

volatile bool keepRunning = false;
int currentSpeed;
int currentDirection = HIGH;

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
  driver.microsteps(1);
}

void loop() {
  if (Serial.available() > 0) {
    int receivedLayer = Serial.parseInt();
    Serial.println(receivedLayer);  // For debugging

    if (receivedLayer == 1) {
      currentSpeed = 10;  // Fast speed
      keepRunning = true;
    } else if (receivedLayer == 3) {
      currentSpeed = 25;  // Medium speed
      keepRunning = true;
    } else if (receivedLayer == 5) {
      currentSpeed = 50;  // Slow speed
      keepRunning = true;
    } else {
      keepRunning = false;  // Stop the motor if no square is hovered
    }
  }

  if (keepRunning) {
    rotateMotor();
  }
}

void rotateMotor() {
  digitalWrite(DIR_PIN_1, currentDirection);
  digitalWrite(STEP_PIN_1, HIGH);
  delayMicroseconds(10);
  digitalWrite(STEP_PIN_1, LOW);
  delay(currentSpeed);
}