//get spacing from top gui to align bottom gui
float guiSpacer = 0;
color green = #035010;
color red = #FC0D0D;
color purple = #7E00D3;
float textBoxH = 85;
int buttonW, buttonH; 


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
  //input.textAlign(CENTER, CENTER);

  buttonW = input.width/3;
  buttonH = int(buttonW*1.33);

  float imgW = buttonW;
  float imgH = buttonH;
  guiSpacer = imgH*2+textBoxH;
  for (int x=0; x<3; x++) {//0, 1, 2, 
    for (int y=0; y<2; y++) {
      int count = x*2+y;

      float xPos = imgW/2 + imgW*x;
      float yPos = imgH/2 + imgH*y+textBoxH/2;
      buttonLocs[count] = new PVector(xPos, yPos);
      input.image(guiImages[count], buttonLocs[count].x, buttonLocs[count].y, imgW, imgH);
    }
  }
  for (int x=0; x<3; x++) {
    for (int y=0; y<2; y++) {
      int count = x*2+y;
      if (mousePressed) {
        boolean check = checkDist(buttonLocs[count].x, buttonLocs[count].y+guiSpacer, imgW, imgH, 0, 0);

        if (check==true) {
          chosenImage=count;
          check=false;
        }
      }
    }
  }



  input.rectMode(CENTER);
  input.stroke(purple);
  input.strokeWeight(5);
  input.noFill();
  input.rect(buttonLocs[chosenImage].x, buttonLocs[chosenImage].y, imgW, imgH);
  input.textSize(30);
  input.text("Texture", input.width*0.2, textBoxH-5, imgW, imgH);
  input.endDraw();
  imageMode(CORNER);
  image(input, 0, guiSpacer, input.width, input.height);
}

void baseForm() {

  form.beginDraw();
  form.imageMode(CENTER);
  form.background(255, 0);
  //form.fill(0);
  form.textSize(35);
  //form.textAlign(CENTER, CENTER);

  buttonW = form.width/3;
  buttonH = int(buttonW*1.33);
  float imgW = buttonW;
  float imgH = buttonH;

  //float offsetY =guiSpacer;
  guiSpacer = imgH*2+textBoxH;

  for (int x=0; x<3; x++) {//0, 1, 2, 
    for (int y=0; y<2; y++) {
      int count = x*2+y;

      float xPos = imgW/2 + imgW*x;
      float yPos = imgH/2 + imgH*y+textBoxH/2;
      buttonLocsForm[count] = new PVector(xPos, yPos);
      form.image(formImages[count], buttonLocsForm[count].x, buttonLocsForm[count].y, imgW, imgH);
    }
  }
  for (int x=0; x<3; x++) {
    for (int y=0; y<2; y++) {
      int count = x*2+y;
      if (mousePressed) {
        boolean check = checkDist(buttonLocsForm[count].x, buttonLocsForm[count].y, imgW, imgH, 0, guiSpacer);
        if (check==true) {
          //println(check);
          chosenForm=count;
          check=false;
        }
      }
    }
  }


  form.rectMode(CENTER);
  form.stroke(purple);
  form.strokeWeight(5);
  form.noFill();
  form.rect(buttonLocsForm[chosenForm].x, buttonLocsForm[chosenForm].y, imgW, imgH);
  form.fill(0);
  form.text("Form ", form.width*0.2, textBoxH-5, imgW, imgH);
  form.endDraw();
  //imageMode(CORNER);
  image(form, 0, 0, form.width, height);
}

boolean checkDist(float xpos, float ypos, float buttonW, float buttonH, float offsetX, float offsety) {
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

  fill(green);
  rect(0, height*0.9, buttonW*1.5, buttonH);
  fill(255);
  textSize(25);
  text("  REDRAW", 0, height*0.95);
  fill(purple);
  rect(buttonW*1.5, height*0.9, buttonW*1.5, buttonH);
  fill(255);
  textSize(25);
  text("  SAVE", buttonW*1.5, height*0.95);

  //fill(0);
  //textSize(25);
  //fill(0, 55, 55);
  //text("Use UP and DOWN arrows", 10, height*0.65);
  //text("to change depth of detail", 10, height*0.65+30);
  //textSize(20);
  //fill(0);
  //text("Retracts/Expands White: " + minDetail, 10, height*0.66+60);
  //text("Retracts/Expands Black: " + maxDetail, 10, height*0.66+90);
  //textSize(25);
  //fill(0);
  //text("Press 'e' to save image and gcode", 10, height*0.66+150);
  //text("Choose one image and one form, then click the redraw button", 10, height*0.66, 400, 400);
}
