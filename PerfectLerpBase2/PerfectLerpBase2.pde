//May 31, 2022
//Look into stringing behavior
//Look at gcode for setting bed limits
//retraction?


ArrayList <String> gcode;
GCodeMaker pla;
PImage img, imgTexture;
PShape newShape, baseShape;

PVector[] ptsPLA, joinedBaseForm;
PVector[] basePts, totalBase; // = new PVector[int(numPtsPerLayer)];
float [] cR, cT, cD;//to contain color/brightness data of each point, radius, texture, detail
float[] globalStrokeColorB;
color[] globalStrokeColor;
//variables to draw 3d form
float theta, theta2, angleStep, angleStep2;
float radius = 36;
int numPtsPerLayer = 360;
int numLayers = 360;
float nozzleSizePLA = 0.4;
float layerHeightPLA = 0.15;
float startingZ =0; //in case you are printing on a matrix
float pathWidth = nozzleSizePLA*1.25;
int loops;// = int((radiu
int chosenForm =1;
float minDetail=2, maxDetail=0;
boolean colorImage = true;
float amp=0, phase=0, freq=0;

void setup() {
  size(800, 800, P3D);
  //surface.setResizable(true);
  pla = new GCodeMaker(nozzleSizePLA, nozzleSizePLA, layerHeightPLA, 1, 1);
  pla.start(500, 0, 0, 0, 250, 250, 200);
  newShape = createShape();
  baseShape = createShape();
  img = loadImage("linear_blur_green-24_23.png");  
  imgTexture = loadImage("albers-1111532.png");  
  img.resize(numPtsPerLayer, numLayers);
  imgTexture.resize(numPtsPerLayer, numLayers);
  globalStrokeColorB= new float[img.width*img.height];
  globalStrokeColor= new color[img.width*img.height];
  cR = new float[numPtsPerLayer*numLayers];
  cT = new float[numPtsPerLayer*numLayers];

  theta= 0;
  theta2= 0;
  angleStep=TWO_PI/numPtsPerLayer;
  angleStep2=TWO_PI/numPtsPerLayer;

  basePts = new PVector[numPtsPerLayer];
  joinedBaseForm = createBaseRadiusPoints(0.2, 0);
  loadPoints(joinedBaseForm);
  makeShape();
}

void draw() {

  background(50);
  translate(width/2, height*0.5, 500);
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
}

void keyPressed() {

  if (key=='s'||key=='S') {
    pla.end();
    pla.export();
    saveFrame("Form_Image"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+".png");
  }
}
