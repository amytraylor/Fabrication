//Amy Traylor
//Santa Fe Demo Version Sept 22, 2022

//set these at the beginning
float nozzleSizeClay = 1.5;
float layerHeightClay = nozzleSizeClay*0.85;
float startingZ =layerHeightClay/2;//eazao on eazao board, layerHeightClay*1.25
float pathWidth = nozzleSizeClay;
float extrudeRateClay = 1.0;
float extrusionForm = extrudeRateClay;
float extrusionBase = extrusionForm/5.0;
int claySpeed = 1200;

int numPtsPerLayer = 720; //180 also works
float heightVessel = 120;//mm//was 80
int numLayers = int(heightVessel/layerHeightClay);

//CHANGEME!!!
float minRadius = heightVessel/10;
float maxRadius = heightVessel/3.0;
float radiusOval = minRadius/3;
//for nonplanar
float numHumps = 1;

//Modes
boolean doubleWall = false;
boolean nonPlanar = false;
boolean oval = false;
//choose 1 or 2 base layers. I recommend 2
int numBaseLayers = 2;
//END CHOOSEME!!!

//set printer parameters
int printerW = 150;
int printerL = 150;
int printerH = 150;



void setup() {
  size(1200, 900, P3D);
  //fullScreen(P3D);
  //LoadImages tab
  loadImages();
  //SetupImagePoints tab
  setupImagePoints();
  readImagePixels();
  //smoothPixels();
  //CreateLoadPoints tab
  setupPointsCreation();
}


void draw() {

  background(#E8E1EA);

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
      println("busy");
    } else {
      count=0;
      busy=false;
    }
  }


  surface.setTitle("FrameRate: " + frameRate);
}

void mousePressed() {
  if (mouseY>height*0.9&&mouseX<buttonW) {
    setup();
    redraw();
  }
  if (mouseY>height*0.9&&mouseX<buttonW*2&&mouseX>buttonW) {
    //send points to the GCodeMaker class
    loadPoints(joinedBaseForm);
    //sends cooldown commands to printer
    clay.end();
    clay.export();
    saveFrame("Form_Image"+chosenImage+"Form"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+".png");
  }
}

void keyPressed() {

  if (key=='e'||key=='E') {
    //send points to the GCodeMaker class
    loadPoints(joinedBaseForm);
    //sends cooldown commands to printer
    clay.end();
    clay.export();
    saveFrame("Form_Image"+chosenImage+"Form"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+".png");
  }


  if (keyCode==LEFT&&busy==false) {
    busy=true;
    if (minDetail>-25) {
      minDetail-=1;
    }
    setup();
    redraw();
  }
  if (keyCode==RIGHT&&busy==false) {
    busy=true;
    if (minDetail<25) {
      minDetail+=1;
    }
    setup();
    redraw();
  }

  if (keyCode==DOWN&&busy==false) {
    busy=true;
    if (maxDetail>-5) {
      maxDetail-=1;
    }
    setup();
    redraw();
  }
  if (keyCode==UP&&busy==false) {
    busy=true;
    if (maxDetail<5) {
      maxDetail+=1;
    }
    setup();
    redraw();
  }

  if (key=='w') {
    ypos-=zoom;
    println("ypos: " + ypos);
  }
  if (key=='s') {
    ypos+=zoom;
    println("ypos: " + ypos);
  }
  if (key=='a') {
    xpos-=zoom;
    println("xpos: " + xpos);
  }
  if (key=='d') {
    xpos+=zoom;
    println("xpos: " + xpos);
  }
  if (key=='z') {
    zpos-=zoom;
    println("zpos: " + zpos);
  }
  if (key=='x') {
    zpos+=zoom;
    println("zpos: " + zpos);
  }
}
