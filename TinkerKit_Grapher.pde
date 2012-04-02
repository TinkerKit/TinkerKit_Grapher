// TinkerKit Grapher
// v6 by Massimo Banzi
// Last modified 02.04.2012
//
// Works well on a mac. on Windows the serial
// port needs to be specified in the code unti
// we implement a gui for it
// requires firmata running on Arduino at 57600bps
//
// some parts of this code were taken from
// BBCC_Plotter by Tim Hirzel, Feb 2008
//
// works on Processing 1.5.1

import processing.serial.*;
import cc.arduino.*;

// true generates sample data, false connects to Arduino
boolean simulation = false;

int windowWidth = 800;
int windowHeight = 600;

int numInputs = 6;

int samples = 128;
//int ystep = 40;
//int xstep = windowWidth/samples;

//int xBorder = 120;
int lBorder = 80;
int rBorder = 200;

int yBorder = 80;

int minval[] = new int[numInputs];
int maxval[] = new int[numInputs];
int average[] = new int[numInputs];

boolean toPlot[] = {
  true, true, false, false, false, false};
  
int outMapping[] = {3,5,6,9,10,11};
boolean activateOutputs = false;

// These are calculated here, but could be changed if you wanted

int graphWidth = windowWidth - (lBorder+rBorder);
int graphHeight = windowHeight - (yBorder * 2);

// ******* Legend  ********
// Define the location and size of the Legend area
int legendWidth = rBorder -10 ;
int legendHeight = 180;
int legendX = windowWidth - rBorder + 5;
int legendY =  yBorder;

// ******* Help Window  ********
// Define the size of the help area.  It always sits in the middle
int helpWidth = 400;
int helpHeight = 300;
boolean showHelp = false;

int gridSpaceX = 4;  
int gridSpaceY = 50; 
int startX = 0;
int endX = 128;

int startY = 0;
int endY = 1024;

// leave these to be calculated
float pixPerRealY = float(graphHeight)/(endY - float(startY));
float pixPerRealX = float(graphWidth)/(endX - float(startX));

int ExpectUpdateSpeed = 1000;
int val = 0;

String title = "TinkerKit Lab";    // Plot Title
String names = "I0 I1 I2 I3 I4 I5";                    // The names of the values that get sent over serial
String yLabel = "I\nn\np\nu\nt\n \nv\na\nl\nu\ne\n";  // this is kind of a hack to make the vertical label
String xLabel = "Samples";                               // X axis label


CircularBuffer c[] = new CircularBuffer[numInputs];

PFont titleFont;
PFont labelFont;
Arduino arduino;

void setup() {
  size(windowWidth, windowHeight);        // window size
  setupColors();
  setupFonts();
  resetMinMax();
  smooth();

  if (!simulation) {
    arduino = new Arduino(this, Serial.list()[0], 57600); 
    initArduino();
  }
  for (int s = 0; s < numInputs; s++) {
    c[s] = new CircularBuffer(samples);
  }

}

void draw() {
  drawGraph();

  for (int s = 0; s < numInputs; s++) {
    if (toPlot[s]) {
      if (simulation) 
        val = int(random(-10,10) + (20+20*s)*(1+ sin((frameCount/10.0)+s)));
      else {
        val = arduino.analogRead(s);
        if (activateOutputs) arduino.analogWrite(outMapping[s],val/4);
      }
     

      c[s].put(val);
      
      if ( val < minval[s]) minval[s] = val;
      if ( val > maxval[s]) maxval[s] = val;
      

      drawLegend(s,val);

      plotCurve(s);
    }
  }
  //delay(1000);
  if (showHelp) drawHelp();
}

void keyPressed() {
  
  if (key == 'h') showHelp = !showHelp;
  if (key == 'r') resetMinMax(); 
  if (key == '0') toPlot[0] = !toPlot[0];
  if (key == '1') toPlot[1] = !toPlot[1];
  if (key == '2') toPlot[2] = !toPlot[2];
  if (key == '3') toPlot[3] = !toPlot[3];
  if (key == '4') toPlot[4] = !toPlot[4];
  if (key == '5') toPlot[5] = !toPlot[5];
  if (key == 'a') activateOutputs = !activateOutputs;
  

}







