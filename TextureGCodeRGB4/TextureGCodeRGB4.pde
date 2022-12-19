//Amy Traylor
//December 29, 2021
//Code maps a bitmap image to a 3D surface


//cameras to view different angles
import damkjer.ocd.*;
Camera camera0, camera1, camera2;
int currentCam = 0;
int camX, camY, camZ, aimX, aimY, aimZ;

GCodeMaker pla, clay;
PVector[] pts;//to contain points
PVector[] ptsLoad;// to add translation for  printer bed = new PVector[pts.length];
float [] cR, cT, cD;//to contain color/brightness data of each point, radius, texture, detail
float [] cLH;// layer height data
//variables to draw 3d form
float theta, radius, angleStep, numPtsPerLayer, layers;
float wave2X, wave2Y, angleStepInnerWave, theta2;

PImage img, imgTexture, imgDetail, imgLayerHeight;
String imgRad, imgText, imgDet;

float layerHeight = 0.2;
float layerHeightClay = 3.0*0.25;
float min =layerHeightClay*0.23;
float max = layerHeightClay*0.27;
int count=0;
//protusion max amount for each pixel
float protrude;
float xpos, ypos, zpos;
float zoom=5;

PGraphics form;
String[] params;




void setup() {
  size(900, 900, P3D);
  form=createGraphics(width, height, P3D);

  //  GCodeMaker(int _mode, float _nozzleSize, float _pathWidth, float _layerHeight, float _extrudeRate, float _filamentDiameter)
  pla = new GCodeMaker(0, 0.4, 0.4, layerHeight, 1, 1.75);
  //GCodeMaker(int _mode, float _nozzleSize, float _pathWidth, float _layerHeightPercent, float _extrudeRate, float _speed, float _extrusionMultiplier, float _filamentDiameter) {
  clay = new GCodeMaker(1, 3, 3, .25, 3, 1000, 1, 3);
  imgRad = "linear_blur_blue-37_55.png";//"linear_blur_green-31_41.png"//"linear_blur_green-32_47.png"
  imgText = "saskia1.png";//radial_blur_red-19_45.png
  imgDet = "radial_blur_red-15_12.png"; //linear_blur_blue-50_22.png";//"linear_blur_blue-37_55.png"
  img = loadImage(imgRad);
  imgTexture= loadImage(imgText);
  imgDetail= loadImage(imgDet);//linear_blur_blue-37_55.png
  //imgLayerHeight = loadImage("layerheight_gradient_green3.png");
  //img.get(0,0,int(img.width), int(img.height*0.75));
  img.resize(180, 90);
  imgTexture.resize(img.width, img.height);
  imgDetail.resize(img.width, img.height);
  //imgLayerHeight.resize(360, 360);
  cR = new float[img.width*img.height];
  cT = new float[imgTexture.width*imgTexture.height];
  cD = new float[imgDetail.width*imgDetail.height];
  //cLH = new float[imgLayerHeight.width*imgLayerHeight.height];
  pts = new PVector[img.height*img.width];
  ptsLoad = new PVector[pts.length];

  for (int i=0; i<pts.length; i++) {
    ptsLoad[i] = new PVector(0, 0, 0);
  }

  radius = 50;
  //radius = (img.width/PI)/2;
  // protrude = radius/50;
  //println(radius);
  theta= 0;
  layers = img.height;
  numPtsPerLayer =img.width;
  angleStep=TWO_PI/numPtsPerLayer;
  //angleStep=7.5*(TWO_PI/360);

  pla.printTitle("TextureGCode_"+day()+hour()+minute()+second(), "Amy Traylor");
  //void printParameters(float radius, float radInc, float layerHeight, int layers, int numPtsPerLayer, float wX2, float wY2, flo
  // void printParameters(String imgRad, String imgText, String imgDet, float radius, float layerHeight, int layers, int numPtsPerLayer, String notes)
  pla.printParameters(imgRad, imgText, imgDet, radius, layerHeight, img.height, img.width, "sin wave applied against silhouette wave with phase, amp mapped");
  pla.start(500, 0, 0, 0, 250, 250, 200);

  clay.printTitle("TextureGCode_"+day()+hour()+minute()+second(), "Amy Traylor");
  //void printParameters(float radius, float radInc, float layerHeight, int layers, int numPtsPerLayer, float wX2, float wY2, flo
  clay.printParameters(imgRad, imgText, imgDet, radius, layerHeightClay, img.height, img.width, "sin wave applied against silhouette wave");
  clay.start(500, 0, 0, 21, 250, 250, 200);

  //camera setup
  //camera0 = new Camera(this, 0, 0, 0, width/2, height/2, 0, 0, 1, 0);
  //camera1 = new Camera(this, 0, height*0.25, 500);
  //camera2 = new Camera(this, width, height/2, -100);
  //camera0.aim(width/2, height/2, 0);
  //camera1.aim(width/2, height*0.25, 0);
  //camera2.aim(width/2, height*0.25, 0);

  params = new String[10];
  params[0] = "radius: " + radius;
  params[1] ="layers: " + layers;
  params[2] ="layer height: " + (layerHeightClay*0.25);
  params[3] ="numPtsPerLayer: " + numPtsPerLayer;
  params[4] ="image silhouette: " + imgRad;
  params[5] ="silhouette range: " ;
  //params[6] ="image texture: " + imgText;
  //params[7] ="texture range: ";
  //params[8] ="image detail: " + imgDet;
  //params[9] ="detail range: ";
  combineImages();

  createBaseRadiusPointsPLA();

  loadPoints();
  pla.end();
  pla.export();

  clay.end();
  clay.export();
}


void draw() {
  background(255, 255, 100);
  //switch(currentCam) {
  //case 0:
  //  camera0.feed();
  //  break;
  //case 1:
  //  camera1.feed();
  //  break;
  //case 2:
  //  camera2.feed();
  //  break;
  //}

  drawPoints();
  // drawText();


  image(form, 0, 0, width, height);

  float tS = 25;
  textSize(18);
  fill(0);
  for (int i=0; i<6; i++) {//params.length
    text(params[i], 25, tS*i);
  }
  text("amp = map(y, 0, img.height, 0, 5) " +5, 25, tS*6);
  //text("amp mapped y from 0 to 5, 5 to 0: ", 25, tS*6);
   text("freq: " + 25, 25, tS*7);
 // text("sin of layerheight, 0.23 to 0.27", 25, tS*7);
  //text("rT = cR[inc] ", 25, tS*8);
  text("cR[inc]+amp*sin(freq*theta) ", 25, tS*8);
  //text("phase = (5*TWO_PI)*y/img.height", 25, tS*9);
}

void createBaseRadiusPointsPLA() {
  int moveOverOnBed = 0; //pla is 100, clay is 200
  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      int inc = x+y*img.width;

      //if (y>10) {
      //  layerHeightClay = map(sin(x), -1, 1, min, max );
      //} else {
      //  layerHeightClay = max;
      //}

      //layerHeight = map(inc, 0, (img.width+img.height*img.width), 0.2, 0.35);
      float currentRad = smoothStep(img, inc, 0, 255, radius*0.75, radius*1.0);
      float currentTexture = smoothStep(imgTexture, inc, 0, 255, 0, 5);
      float currentDetail = smoothStep(imgDetail, inc, 0, 255, -radius/5, radius/5);
      params[5] ="silhouette range: " + (radius*0.33) +"," + radius*1.0;
      params[7] ="texture range: " + (-radius/100) +"," + (radius/100);
      params[9] ="detail range: " + (-radius/10) +"," + (radius/10);
      //float currentLayerHeight = smoothStep(imgLayerHeight, inc, 0.15, 0.3);
      cR[inc] = currentRad;
      cT[inc] = currentTexture;
      cD[inc]=  currentDetail;

     // float phase = (5*TWO_PI)*y/img.height;//first multiplier shows how far it moves over from its neighbor pt
      //float amp = 5;
      float amp = map(y, 0, img.height, 0, 5);
      if (y<img.height/2) {
        amp = map(y, 0, img.height/2, 0, 5);
      } else {
        amp = map(y, img.height/2, img.height, 5, 0);
      }
      //float sinY = (sin(y)/img.height);
      //float ampInverse = amp-(amp*sinY);
      // float amp = 5-(5*sinY);//map(y, 0, img.height, 0, 5); //amp of ripple//was 5
      float freq = 3; //frequency of ripple//was 25
      //float rT = cR[inc]+sin(freq*theta);
      float rT = cR[inc]+ cT[inc]+cD[inc] +amp*sin(freq*theta);
      // float rT = cR[inc]+(y*0.05)+amp*sin(freq*theta+phase);
      //float rT = cR[inc];
      float xT = rT*sin(theta);
      float yT = rT*cos(theta);

      pts[inc] = new PVector(moveOverOnBed+xT, moveOverOnBed+yT, 21+y*layerHeightClay);
    }
    //theta+=1;
    theta+=angleStep;
    theta2+=angleStepInnerWave;
    //println(theta2);
  }
}



void loadPoints() {
  //float moveOverOnBed = 0;

  for (int i=0; i<pts.length-1; i++) {
    if (i==pts.length) {
      pla.writePoints(pts[i], pts[i-1]);
      clay.writePoints(pts[i], pts[i-1]);

      //extrusion=(extrudePLA(new PVector(pts[i].x, pts[i].y ), new PVector(pts[i+1].x, pts[i+1].y ))*extrusion_multiplier);
    } else {

      pla.writePoints(pts[i], pts[i+1]);
      clay.writePoints(pts[i], pts[i+1]);
      // extrusion=(extrudePLA(new PVector(pts[i].x, pts[i].y ), new PVector(pts[0].x, pts[0].y ))*extrusion_multiplier);
    }
  }
}

void drawPoints() {
  form.beginDraw();
  form.background(255, 255, 100);
  form.pushMatrix();
  form.translate(width/2+xpos, height/2+50+ypos, 600+zpos);
  //form.translate((300-250)+xpos, (300-150)+ypos, zpos);
  //translate(300+xpos, 300+ypos, zpos);
  float rot = map(mouseY, 0, height, 0.5, 2.0);
  //println(rot);
  form.rotateX(rot);//1.57);
  form.rotateY(0);
  form.rotateZ(radians(mouseX));
  //if(count<v.length){
  //println(radians(mouseX));
  for (int count=0; count<pts.length; count++ ) {
    //println(pts[count].z);
    form.stroke(map(pts[count].x, -radius, radius, 0, 100), map(pts[count].y, -radius/2, radius/2, 0, 100), map(pts[count].z, 0, radius, 0, 100));
    form.strokeWeight(2);
    if (count==0) {
      form.line(pts[count].x, pts[count].y, pts[count].z, pts[count+1].x, pts[count+1].y, pts[count+1].z);
    } else {
      form.line(pts[count].x, pts[count].y, pts[count].z, pts[count-1].x, pts[count-1].y, pts[count-1].z);
    }
    //if (count%numPtsPerLayer==0) {
    //  pushMatrix();
    //  translate(pts[count].x, pts[count].y, pts[count].z);
    //  fill(0, 255, 0);
    //  ellipse(0, 0, 10, 10);
    //  popMatrix();
    //}
  }

  form.popMatrix();
  form.endDraw();
}

void mouseMoved() {
  //camera0.circle(radians(mouseX - pmouseX));
  //camera1.circle(radians(mouseX - pmouseX));
  //camera2.circle(radians(mouseX - pmouseX));
}

void keyPressed() {
  if (key=='0')currentCam=0;
  if (key=='1')currentCam=1;
  if (key=='2')currentCam=2;

  if (key=='s') {
    saveFrame("textureGcode-"+day()+"_"+hour()+minute()+second()+".png");
  }

  if (keyCode==UP) {
    ypos-=zoom;
    println("ypos: " + ypos);
  }
  if (keyCode==DOWN) {
    ypos+=zoom;
    println("ypos: " + ypos);
  }
  if (keyCode==LEFT) {
    xpos-=zoom;
    println("xpos: " + xpos);
  }
  if (keyCode==RIGHT) {
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
