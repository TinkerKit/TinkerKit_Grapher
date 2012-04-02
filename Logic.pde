// Inital attempt at separating UI and logic

void initArduino() {
  arduino.pinMode(5, Arduino.INPUT);
  arduino.pinMode(6, Arduino.INPUT);
  arduino.pinMode(7, Arduino.INPUT);

  arduino.pinMode(2, Arduino.OUTPUT);
  arduino.pinMode(3, Arduino.OUTPUT);
  arduino.pinMode(4, Arduino.OUTPUT); 
 
}

void resetMinMax() {
 
  for (int i = 0; i < numInputs; i++) {
   minval[i] = 1024;
   maxval[i] = 0; 
    
  }
  
  
}
