//June 1, 2022
//Custom Data type for points
//Add horizontal points on base before you add sides


ArrayList <String> gcode;
GCodeMaker pla;
PImage img, imgTexture, imgLH, redImage, newTexture;
PShape newShape, baseShape;

PVector[] ptsPLA, joinedBaseForm;
Points[] ptsData;
PVector[] basePts, totalBase; // = new PVector[int(numPtsPerLayer)];
float [] cR, cT, cD;//to contain color/brightness data of each point, radius, texture, detail
float[] globalStrokeColorB;
color[] globalStrokeColor;
//variables to draw 3d form
float theta, theta2, angleStep, angleStep2;
float radius = 90;
int numPtsPerLayer = 360;
int numLayers = 450;
float nozzleSizePLA = 0.4;
float layerHeightPLA = 0.2;
float extrudeRatePLA = 1;
float startingZ =0; //in case you are printing on a matrix
float endZ = 150;//default value
float pathWidth = nozzleSizePLA*1.25;
int loops;// = int((radiu
int chosenForm =5;
float minDetail=0, maxDetail=0;
boolean colorImage = true;
float amp=0, phase=0, freq=0;

ArrayList<PVector> getSeams = new ArrayList<PVector>();

void setup() {
  size(800, 800, P3D);
  //surface.setResizable(true);
  pla = new GCodeMaker(nozzleSizePLA, nozzleSizePLA, layerHeightPLA, extrudeRatePLA, 1);
  pla.start(500, 0, 0, 0, 250, 250, 200);
  newShape = createShape();
  baseShape = createShape();
 
  img = loadImage("linear_blur_green-24_23.png");  //linear_blur_green-24_23//checkImage-57_5.png
  imgTexture = loadImage("SinWave-720.png");  
  imgLH = loadImage("SinWave-419.png");
  img.resize(numPtsPerLayer, numLayers);
  imgTexture.resize(numPtsPerLayer, numLayers);
  imgLH.resize(numPtsPerLayer, numLayers);
  redImage = createImage(img.width, img.height, RGB);
  globalStrokeColorB= new float[img.width*img.height];
  globalStrokeColor= new color[img.width*img.height];
  cR = new float[numPtsPerLayer*numLayers];
  cT = new float[numPtsPerLayer*numLayers];
  ptsData = new Points[numPtsPerLayer*numLayers];
  
  //getSeams = getRedPos(imgTexture);
  //println(getSeams);
  theta= 0;
  theta2= 0;
  angleStep=TWO_PI/(numPtsPerLayer+1);
  //not related to angleStep1
  angleStep2=TWO_PI/numPtsPerLayer;

  basePts = new PVector[numPtsPerLayer];
  joinedBaseForm = createBaseRadiusPoints(layerHeightPLA, 0);
  loadPoints(joinedBaseForm);
  makeShape();
}

void draw() {

  background(50);
  pushMatrix();
  translate(width/2, height*0.58, 500);
  float rot = map(mouseY, 0, height, 0.5, TWO_PI);
  pushMatrix();
  //translate(width/2, height*0.6, 300);
  rotateX(rot);//1.57);
  rotateY(0);
  rotateZ(radians(mouseX));
  shape(newShape, 0, 0);
  //shape(newShape, 0, 0);
  popMatrix();

  float rot2 = map(mouseY, 0, height, 0.5, TWO_PI);
  pushMatrix();
  //translate(width/2, height*0.62, 300);
  rotateX(rot2);//1.57);
  rotateY(0);
  rotateZ(radians(mouseX));
  shape(baseShape, 0, 0);
  //shape(newShape, 0, 0);
  popMatrix();
  popMatrix();
  //image(redImage, 0, 0, width, height);
}

void keyPressed() {

  if (key=='s'||key=='S') {
    pla.end();
    pla.export();
    saveFrame("Form_Image"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+".png");
  }
}
