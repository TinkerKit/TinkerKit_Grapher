// Inital attempt at separating UI and logic

int[][] colors = new int[numInputs][3];

void setupFonts() {
  
   //  println(PFont.list());
  titleFont = createFont("Helvetica", 18);
  labelFont = createFont("Helvetica", 14); 
  
}


void setupColors() {
  // Thanks to colorbrewer for this pallete
  colors[0][0] = 102;  
  colors[0][1] =194; 
  colors[0][2] = 165;

  colors[1][0] = 252;  
  colors[1][1] = 141; 
  colors[1][2]= 98;

  colors[2][0] = 141;  
  colors[2][1] = 160; 
  colors[2][2]= 203;

  colors[3][0] = 231;  
  colors[3][1] = 138; 
  colors[3][2]= 195;

  colors[4][0] = 166;  
  colors[4][1] = 216; 
  colors[4][2]= 84;

  colors[5][0] = 255;  
  colors[5][1] = 217; 
  colors[5][2]= 47;
}

void setColor(int c) {
  stroke(colors[c][0], colors[c][1],colors[c][2]); 

}


void drawLegend(int s, int v) {

  textFont(labelFont, 14);
  textAlign(LEFT);
  
  int tX = legendX + 10;
  int tY = legendY + 40 + (s* 20);
  
  
  fill(colors[s][0], colors[s][1],colors[s][2]);
  text("I" + s ,tX,tY);
  textAlign(RIGHT);
  tX += 48;
  text(str(v), tX,tY);
  tX += 36;
  text(str(minval[s]), tX,tY);
  tX += 36;
  text(str(maxval[s]), tX,tY);
  tX += 36;
  text(str(average[s]), tX,tY);

  noFill();
  
}


void dottedLine(float x1, float y1, float x2, float y2, float steps){
  for(int i=0; i<=steps; i++) {
    float x = lerp(x1, x2, i/steps);
    float y = lerp(y1, y2, i/steps);
    noStroke();
    ellipse(x, y,2,2);
  }
}

float realToScreenX(float x) {
  float shift = x + startX;
  return map(x,startX,endX, lBorder, windowWidth-(rBorder));
}

float realToScreenY(float y) {
  return map(y,startY, endY, windowHeight-yBorder,yBorder);
}


void drawGraph() {
  background(5);
  strokeWeight(1.5);
  stroke(10);
  fill(40);
  // draw boundary
  rect(lBorder,yBorder,graphWidth, graphHeight);

  textAlign(CENTER);
  fill(240);
  textFont(titleFont);
  text(title, windowWidth/2, yBorder/2);

  textFont(labelFont);
  stroke(90);
  strokeWeight(1);
  
  //draw grid  
  fill(70);
  stroke(0);
  textAlign(RIGHT);
  for (int i = startY; i <= endY; i+= gridSpaceY) {
    line(lBorder - 3, realToScreenY(i), lBorder + graphWidth - 1,  realToScreenY(i));
    text(str(i), lBorder - 10, realToScreenY(i));
  }

  textAlign(LEFT);
  for (int i = startX; i <= endX ; i+= gridSpaceX) {
    line(realToScreenX(i), yBorder+1, realToScreenX(i), yBorder + graphHeight + 3);
    textFont(labelFont, 8);
    text(str((i)), realToScreenX(i), yBorder + graphHeight + 20);
    
  }
  textFont(labelFont, 12);
  // Draw Axis Labels
  fill(70);
  text(yLabel, lBorder - 70,  yBorder + 100 );

  textAlign(CENTER);
  text(xLabel,  windowWidth/2, yBorder + graphHeight + 50);


  // draw legend box
  stroke(70);
  fill(32);
  rect(legendX,legendY,legendWidth, legendHeight);
  textFont(labelFont, 14);
  textAlign(LEFT);
  
  int tX = legendX + 10;
  int tY = legendY + 20;
  fill(240);

  text("In" ,tX,tY);
  textAlign(RIGHT);
  tX += 48;
  text("val", tX,tY);
  tX += 36;
  text("min", tX,tY);
  tX += 36;
  text("max", tX,tY);
  tX += 36;
  text("avg", tX,tY);
  
  textAlign(LEFT);
  tX = legendX + 10;
  tY = yBorder + legendHeight + 20;
  if (activateOutputs) 
     text("outputs are ON", tX,tY);
  else 
     text("outputs are OFF", tX,tY);
  tY += 24;
  /*if (activateOutputs) 
     text("outputs are ON", tX,tY);
  else 
     text("outputs are OFF", tX,tY); */
  
  
  noFill();
  strokeWeight(1); 
}

void drawHelp() {
  stroke(200);
  fill(70,128);
  int helpX = lBorder + 50;
  int helpY = (windowHeight-helpHeight)/2;
  rect(helpX,helpY,helpWidth, helpHeight);
  textFont(titleFont);
  textAlign(LEFT);
  fill(255);
  helpX += 20; 
  helpY += 40;
  text("Help", helpX,helpY);
  
  helpY += 40;
  text("h - show/hide help", helpX,helpY);
  //helpY += 24;
  //text("s - save data to a csv file", helpX,helpY);
  //helpY += 24;
  //text("p - take screenshot", helpX,helpY);
  helpY += 24;
  text("r - reset min/max values", helpX,helpY);
  helpY += 24;
  text("a - turn outputs on", helpX,helpY);
  helpY += 24;
  text("0,1,2,3,4,5 - turn on/off the corresponding input", helpX,helpY);
  
  
}

void plotCurve(int s) {
      long avg = 0;
       setColor(s);
      beginShape();
      for (int i = 0; i < c[s].length ; i++) {
        vertex(realToScreenX(i),realToScreenY(c[s].get(i)));
        //rect(i * xstep + xBorder, height - c[s].get(i) + yBorder,10,10);
        avg = avg + c[s].get(i);
      } 
      endShape(); 
      average[s] = int(avg/samples);
}

