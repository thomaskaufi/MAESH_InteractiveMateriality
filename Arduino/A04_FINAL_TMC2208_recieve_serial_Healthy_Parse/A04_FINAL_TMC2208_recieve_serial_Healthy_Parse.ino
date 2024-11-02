/*
Code to run stepper at different speed based on serial message from processing sketch.
Runs with a manual parse function to avoid blocking clockspeed when recieving serial.

Giulia Talamini and Thomas Kaufmanas
*/


#include <TMCStepper.h>
#include <SoftwareSerial.h>

#define DIR_PIN_1 3
#define STEP_PIN_1 4
#define EN_PIN_1 5
#define SW_RX 12
#define SW_TX 10
#define R_SENSE 0.11f

TMC2208Stepper driver(SW_RX, SW_TX, R_SENSE);

volatile bool keepRunning = true;
int currentSpeed = 1;  //DEFAULT is the idle speed
int currentDirection = HIGH;

const byte numChars = 32;
char receivedChars[numChars];
boolean newData = false;

void setup() {
  pinMode(EN_PIN_1, OUTPUT);
  pinMode(STEP_PIN_1, OUTPUT);
  pinMode(DIR_PIN_1, OUTPUT);
  digitalWrite(EN_PIN_1, LOW);

  Serial.begin(9600);

  //driver.beginSerial(115200);
  driver.begin();
  driver.toff(5);
  driver.rms_current(1200);
  driver.pwm_autoscale(true);
  driver.microsteps(1);
}

void loop() {

  recvWithEndMarker();
  showNewNumber();
  if (keepRunning) {
    rotateMotor();
  }
}

void rotateMotor() {
  //digitalWrite(DIR_PIN_1, currentDirection);
  digitalWrite(STEP_PIN_1, HIGH);
  delayMicroseconds(10);
  digitalWrite(STEP_PIN_1, LOW);
  delay(currentSpeed);
  //Serial.println("runninn");
}

void recvWithEndMarker() {
  static byte ndx = 0;
  char endMarker = '\n';
  char rc;

  if (Serial.available() > 0) {
    rc = Serial.read();

    if (rc != endMarker) {
      receivedChars[ndx] = rc;
      ndx++;
      if (ndx >= numChars) {
        ndx = numChars - 1;
      }
    } else {
      receivedChars[ndx] = '\0';  // terminate the string
      ndx = 0;
      newData = true;
    }
  }
}

void showNewNumber() {
  if (newData == true) {
    int receivedLayer = atoi(receivedChars);
    if (receivedLayer == 1) {
      currentSpeed = 5;  // Fast speed
      keepRunning = true;
      //Serial.println("outerrr");
    } else if (receivedLayer == 3) {
      currentSpeed = 17;  // Medium speed
      keepRunning = true;
    } else if (receivedLayer == 5) {
      currentSpeed = 8;  // Slow speed
      keepRunning = true;
    } else if (receivedLayer == -1) {
      keepRunning = true;
      currentSpeed = 1;
      //Serial.println("noneeee");
    }
  }

  newData = false;
}
