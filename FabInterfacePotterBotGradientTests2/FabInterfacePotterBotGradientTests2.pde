//Amy Traylor
//April 2, 2022
//Extrusion rate is a function of layerHeight!
//4 was fine with 0.75 but two is too much with nozzleSizeClay*0.4, or 0.6


//GUI
PGraphics input, output, form;
PVector[] buttonLocs, buttonLocsForm, pts;
PImage[] inputImages, formImages, formGrads, guiImages;
int chosenImage = 0, chosenForm = 0;
float minDetail = 9, maxDetail = -3;
boolean busy = false;
boolean colorImage = false;
int count=0;
//End GUI


void setup() {
  size(1200, 900, P3D);

  //LoadImages tab
  loadImages();
  //SetupImagePoints tab
  setupImagePoints();
  //CreateLoadPoints tab
  setupPointsCreation();
}


void draw() {

  background(255, 255, 100);

  //Visualize tab
  drawPoints(form2);
  image(form2, 200, 0, width, height);
  //end Visualize tab

  //GUI tab
  drawGraphics();
  buttonsAndInstructions();

  if (busy) {
    if (count<10) {
      count+=1;
    } else {
      count=0;
      busy=false;
    }
  }

  //println(busy);
  surface.setTitle("FrameRate: " + frameRate);
}

void mousePressed() {
  if (mouseY>height*0.9&&mouseX<width*0.30&&mouseX>width*0.15) {
    setup();
    redraw();
  }
  if (mouseY>height*0.9&&mouseX<width*0.15) {
    if (colorImage) {
      colorImage=false;
    } else {
      colorImage=true;
    }
    setup();
    redraw();
  }
}

void keyPressed() {

  if (key=='e'||key=='E') {
    clay.export();
    saveFrame("Form_Image"+chosenImage+"Form"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+".png");
  }


  if (keyCode==LEFT&&busy==false) {
    busy=true;
    if (minDetail>-25) {
      minDetail-=1;
      //println("minDetail: " + minDetail);
    }
    setup();
    redraw();
    //busy=false;
  }
  if (keyCode==RIGHT&&busy==false) {
    busy=true;
    if (minDetail<25) {
      minDetail+=1;
      //println("minDetail: " + minDetail);
    }
    setup();
    redraw();
    //busy=false;
  }

  if (keyCode==DOWN&&busy==false) {
    busy=true;
    if (maxDetail>-5) {
      maxDetail-=1;
      //println("maxDetail: " + maxDetail);
    }
    setup();
    redraw();
    //busy=false;
  }
  if (keyCode==UP&&busy==false) {
    busy=true;
    if (maxDetail<5) {
      maxDetail+=1;
      //println("maxDetail: " + maxDetail);
    }
    setup();
    redraw();
    //busy=false;
  }

  if (key=='W'||key=='w') {
    ypos-=zoom;
    println("ypos: " + ypos);
  }
  if (key=='S'||key=='s') {
    ypos+=zoom;
    println("ypos: " + ypos);
  }
  if (key=='A'||key=='a') {
    xpos-=zoom;
    println("xpos: " + xpos);
  }
  if (key=='D'||key=='d') {
    xpos+=zoom;
    println("xpos: " + xpos);
  }
  if (key=='z'||key=='Z') {
    zpos-=zoom;
    println("zpos: " + zpos);
  }
  if (key=='x'||key=='X') {
    zpos+=zoom;
    println("zpos: " + zpos);
  }
}
