/*
Bare Minimum Example for controlling stepper motor via the TMC2208 driver.
"Is the thing alive"-code pretty much

Thomas Kaufmanas

*/

#include <TMCStepper.h>
#include <SoftwareSerial.h>

#define DIR_PIN_1   3   // Direction
#define STEP_PIN_1  4  // Step
#define EN_PIN_1    5    // Enable


#define SW_RX       12
#define SW_TX       10
#define R_SENSE      0.11f

TMC2208Stepper driver(SW_RX, SW_TX, R_SENSE);

int speed1 = 1000;
long timer1 = 0;
int interval1 = 5;

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
}

void loop() {

  digitalWrite(STEP_PIN_1, HIGH);
  delayMicroseconds(10);
  digitalWrite(STEP_PIN_1, LOW);
  delayMicroseconds(speed1);
  //Serial.println("hhh"); //Serial print will slow the clockspeed, and thus the stepper!
}
