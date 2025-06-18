# MAESH_InteractiveMateriality
Source codes from course project "MÆSH", Interactive Materiality Q1 24/25 TU/e.
All sketches are named A/P# with respect to software and time of progression in process.
As such each sketch as a rule of thumb builds on the previous sketch.

Relies on the Kinect Blob Tracking library by Halfdan Hauch:
https://github.com/airlabitu/Processing-kinect-blob-tracker

Thomas Kaufmanas, Giulia Talamini, Anton Hallstrup.
November, 2024.


## Contents
### Arduino
- A01_TMC2208_Bare_Minimum | *Bare minimum example to run stepper motor with the TMC-driver with as little code as possible*
- A02_TMC_2208_recieve_serial_pick_random_speeds | *Recieves serial data from processing sketch and chooses a random speed and direction*
- A03_TMC2208_recieve_serial_case_speed | *Recieves serial data from processing sketch and chooses case speed*
- A04_FINAL_TMC2208_recieve_serial_Healthy_Parse | *Receieves serial data with custom parse function to avoid blocking motor*

### Processing
- P01_Detect_Circles | *Detect XY point in randomly generated circles*
- P02_Recieve_Kinect_Blobs_OSC_Bare_Minimum | *Recieve XY point from Kinect Blob Tracker via OSC*
- P03_Recieve_Kinect_In_Circles_Pass_Serial | *Recieve XY point from Kinect Blob Tracker via OSC, pass to arduino via Serial*
- P04_Detect_Squares | *Detect XY point in a grid layout*
- P05_Detect_Squares_Layers | *Detect XY point in layers of grid, respective to the center*
- P06_DEMODAY_Squares_Layered_OSC_in_Serial_Out | *Combines P02 and P06*

