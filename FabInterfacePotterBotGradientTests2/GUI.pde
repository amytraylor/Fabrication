//get spacing from top gui to align botton gui
float guiSpacer = 0;

void drawGraphics() {
  imageInput();  
  baseForm();
}

void imageInput() {
  input.beginDraw();
  input.imageMode(CENTER);
  input.background(255, 0);
  input.fill(0);
  input.textSize(35);
  input.textAlign(CENTER, CENTER);


  float imgW = input.width/3;
  float imgH = imgW;
  guiSpacer = imgH*2;
  for (int x=0; x<3; x++) {//0, 1, 2, 
    for (int y=0; y<2; y++) {
      int count = x*2+y;

      float xPos = imgW/2 + imgW*x;
      float yPos = imgH/2 + imgH*y;
      buttonLocs[count] = new PVector(xPos, yPos);
      input.image(guiImages[count], buttonLocs[count].x, buttonLocs[count].y, imgW, imgH);
    }
  }
  for (int x=0; x<3; x++) {
    for (int y=0; y<2; y++) {
      int count = x*2+y;
      if (mousePressed) {
        boolean check = checkDist(buttonLocs[count].x, buttonLocs[count].y, imgW, imgH, 0, 0);

        if (check==true) {
          chosenImage=count;
          check=false;
        }
      }
    }
  }

  input.text("Image #: " + chosenImage, buttonLocs[chosenImage].x, buttonLocs[chosenImage].y, imgW, imgH);

  input.rectMode(CENTER);
  input.stroke(255, 0, 0);
  input.strokeWeight(5);
  input.noFill();
  input.rect(buttonLocs[chosenImage].x, buttonLocs[chosenImage].y, imgW, imgH);
  input.endDraw();
  imageMode(CORNER);
  image(input, 0, 0, input.width, height);
}

void baseForm() {
  float offsetY =guiSpacer;
  form.beginDraw();
  form.imageMode(CENTER);
  form.background(255, 0);
  form.fill(0);
  form.textSize(35);
  form.textAlign(CENTER, CENTER);


  float imgW = form.width/3;
  float imgH = imgW;
  for (int x=0; x<3; x++) {//0, 1, 2, 
    for (int y=0; y<2; y++) {
      int count = x*2+y;

      float xPos = imgW/2 + imgW*x;
      float yPos = imgH/2 + imgH*y;
      buttonLocsForm[count] = new PVector(xPos, yPos);
      form.image(formImages[count], buttonLocsForm[count].x, buttonLocsForm[count].y, imgW, imgH);
      //println(buttonLocsForm[count]);
    }
  }
  for (int x=0; x<3; x++) {
    for (int y=0; y<2; y++) {
      int count = x*2+y;
      if (mousePressed) {
        boolean check = checkDist(buttonLocsForm[count].x, buttonLocsForm[count].y+offsetY, imgW, imgH, 0, offsetY);

        if (check==true) {
          println(check);
          chosenForm=count;
          check=false;
        }
      }
    }
  }

  form.text("Form #: " + chosenForm, buttonLocsForm[chosenForm].x, buttonLocsForm[chosenForm].y, imgW, imgH);
  form.rectMode(CENTER);
  form.stroke(255, 0, 0);
  form.strokeWeight(5);
  form.noFill();
  form.rect(buttonLocsForm[chosenForm].x, buttonLocsForm[chosenForm].y, imgW, imgH);
  form.endDraw();
  imageMode(CORNER);
  image(form, 0, guiSpacer, form.width, height);
}

boolean checkDist(float xpos, float ypos, float buttonW, float buttonH, float o1, float o2) {
  boolean current=false;
  float dist = dist(mouseX, mouseY, xpos, ypos);
  //println(dist);
  if (dist<(buttonH/2)&&dist<(buttonW/2)) {    
    return current=true;
  } else {
    return current=false;
  }
}

void buttonsAndInstructions() {

  //redraw button
  int buttonW = 200;
  int buttonH = int(height*0.1);
  fill(255, 0, 0);
  rect(buttonW, height*0.9, buttonW, buttonH);
  fill(255);
  textSize(20);
  text("  REDRAW", buttonW, height*0.95);

  //color toggle button
  if (colorImage==false) {
    fill(255);
  } else {
    fill(0, 200, 100);
  }
  rect(0, height*0.9, buttonW, buttonH);
  fill(0);
  text("Toggle Color/BW", 10, height*0.95);

  fill(0);
  textSize(25);
  fill(0, 55, 55);
  text("Use UP and DOWN arrows", 10, height*0.65);
  text("to change depth of detail", 10, height*0.65+30);
  textSize(20);
  fill(0);
  text("Detail: " + minDetail, 10, height*0.66+60);
  text("Radius: " + maxDetail, 10, height*0.66+90);
  textSize(25);
  fill(0, 55, 55);
  text("Press 'e' to export image and gcode", 10, height*0.66+150);


  text("Choose one image and one form, then click the redraw button", width/2, 50, 400, 400);

}
