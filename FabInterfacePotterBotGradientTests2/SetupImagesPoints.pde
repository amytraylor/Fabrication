ArrayList <String> gcode;
GCodeMaker clay;
PVector[] ptsClay, joinedBaseForm;//to contain points
int globalPtsLength = 0;
PVector[] basePts, totalBase; // = new PVector[int(numPtsPerLayer)];
float [] cR, cT, cD;//to contain color/brightness data of each point, radius, texture, detail
float[] globalStrokeColorB;
color[] globalStrokeColor;
//variables to draw 3d form
float theta, theta2, angleStep, angleStep2;
int numPtsPerLayer = 360; 
int numLayers = 120;
float radius =90;
//int resolution = 180;

float amp, freq, phase;

PImage img, imgTexture, imgDetail;
//String imgRad, imgText, imgDet;

float nozzleSizeClay = 3.0;
float layerHeightClay = nozzleSizeClay*0.65;
float startingZ =layerHeightClay*1.25;//layerHeightClay; //in case you are printing on a matrix
float pathWidth = nozzleSizeClay*1.25;
float extrusionForm = 3.0;
float extrusionBase = 6.0;
float inc = 0; //inc to offset loops in base, set in function
int claySpeed = 1000;
int loops;// = int((radius*2)/nozzleSizePLA);


float xpos, ypos, zpos;
float zoom=5;

PGraphics form1, form2;
PShape newShape;// = createShape();
String[] params;
Vec4[] vecs;

void setupImagePoints() {
  gcode = new ArrayList<String>();
  //form1=createGraphics(width, height, P3D);
  form2=createGraphics(width, height, P3D);

  // GCodeMakerClay float _nozzleSize, float _layerHeightClay, extrudetop, float _extrudeRate, float _speed
  clay = new GCodeMaker(nozzleSizeClay, layerHeightClay, extrusionForm, extrusionBase, claySpeed);

  img = formGrads[chosenForm];
  img.resize(numPtsPerLayer, numLayers);
  imgTexture= inputImages[chosenImage];
  imgTexture.resize(numPtsPerLayer, numLayers);
  cR = new float[numPtsPerLayer*numLayers];
  cT = new float[numPtsPerLayer*numLayers];
  globalStrokeColorB= new float[img.width*img.height];
  globalStrokeColor= new color[img.width*img.height];
  ptsClay = new PVector[img.height*img.width];
  

  theta= TWO_PI/6;
  theta2= TWO_PI/6;
  angleStep=TWO_PI/numPtsPerLayer;
  angleStep2=TWO_PI/numPtsPerLayer;
  //println("angleStep: " + angleStep);

  basePts = new PVector[numPtsPerLayer];


  clay.printTitle("TextureGCode_"+day()+hour()+minute()+second(), "Amy Traylor");
 // pla.printParameters(imgRad, imgText, imgDet, radius, layerHeightPLA, img.height, img.width, "");
  clay.start(claySpeed, 0, 0, startingZ, 250, 250, 200);
}
