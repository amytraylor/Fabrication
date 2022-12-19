
ArrayList <String> gcode;
GCodeMaker clay;
Points[] ptsData;
PImage img, imgTexture, newTexture;
PShape newShape;
PVector[] ptsClay, joinedBaseForm;//to contain points
float[] blackLeft;
float[] blackRight;
float[] layerRadLeft, layerRadRight;
int midPoint;
PVector[] basePts, totalBase; 
float [] cR, cT;//to contain color/brightness data of each point, radius, texture, detail
float[] globalStrokeColorB;
color[] globalStrokeColor;
//variables to draw 3d form
float theta, theta2, angleStep, angleStep2;
float amp, freq, phase;
float endZ = 0;
float secondLayerHeight;
int loops = 0;

//GUI
PGraphics input, form, form2;
PVector[] buttonLocs, buttonLocsForm, pts;
PImage[] inputImages, formImages, formGrads, guiImages;
int chosenImage = 0, chosenForm = 3;
float minDetail = -1.5, maxDetail = 1.5;
boolean busy = false;
boolean colorImage = false;
//int count=0;
float xpos, ypos, zpos;
float zoom=25;
int count = 0;
//End GUI



void setupImagePoints() {
  gcode = new ArrayList<String>();
  newShape = createShape();
  input = createGraphics(int(width*0.3), height);
  form=createGraphics(int(width*0.3), height);
  form2=createGraphics(width, height, P3D);

  // GCodeMakerClay float _nozzleSize, float _layerHeightClay, float _extrudeRateTop, extrude rate bottom, float _speed
  clay = new GCodeMaker(nozzleSizeClay, layerHeightClay, extrusionForm, extrusionBase, claySpeed);

  img = formGrads[chosenForm];
  img.resize(numPtsPerLayer, numLayers);
  imgTexture= inputImages[chosenImage];
  imgTexture.resize(numPtsPerLayer, numLayers);
  //imgDetail= inputImages[5];
  //imgDetail.resize(numPtsPerLayer, numLayers);
  cR = new float[numPtsPerLayer*numLayers];
  cT = new float[numPtsPerLayer*numLayers];
  //cD = new float[numPtsPerLayer*numLayers];
  globalStrokeColorB= new float[numPtsPerLayer*numLayers];
  globalStrokeColor= new color[numPtsPerLayer*numLayers];
  ptsClay = new PVector[img.height*img.width];
  blackLeft = new float[img.height];
  blackRight = new float[img.height];
  layerRadLeft = new float[img.height];
  layerRadRight = new float[img.height];
  midPoint = img.width/2;
  theta= 0;
  theta2= 0;
  angleStep=TWO_PI/numPtsPerLayer;
  angleStep2=TWO_PI/numPtsPerLayer;

  basePts = new PVector[numPtsPerLayer];
  secondLayerHeight = startingZ+layerHeightClay;

  clay.printTitle("TextureGCode_"+day()+hour()+minute()+second(), "Amy Traylor");
  clay.start(claySpeed, 0, 0, startingZ, 250, 250, 200);
}
