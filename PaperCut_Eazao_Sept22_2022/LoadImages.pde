void loadImages() {
  input = createGraphics(width/3, height);
  form=createGraphics(width/3, height);
  guiImages = new PImage[6];
  inputImages = new PImage[6];
  formImages = new PImage[6];
  formGrads = new PImage[6];
  buttonLocs = new PVector[6];
  buttonLocsForm = new PVector[6];

  guiImages[0] = loadImage("Pattern-EMC.jpg");
  guiImages[1] = loadImage("IMG_1523 copy.JPG");
  guiImages[2] = loadImage("CutPattern-5-blur.jpg");
  guiImages[3] = loadImage("CutPattern-4-blur.jpg");//ArcPurpleLime
  guiImages[4] = loadImage("CutPattern-3.jpg");
  guiImages[5] = loadImage("Doodle 6.jpg");

  formImages[0] = loadImage("Doodle 1.jpg");
  formImages[1] = loadImage("testVessel3.png");
  formImages[2] = loadImage("Form-3.jpg");
  formImages[3] = loadImage("IMG_1505.JPG");
  formImages[4] = loadImage("Forms-EMC-05.png");
  formImages[5] = loadImage("Form-5.jpg");

  for ( int i = 0; i<formGrads.length; i++) {
    guiImages[i].resize(numPtsPerLayer, numLayers);
    //formImages[i].resize(numPtsPerLayer, numLayers);
    guiImages[i].filter(GRAY);
    formImages[i].filter(GRAY);
    formImages[i].filter(THRESHOLD);
  }
  for (int p=0; p<formGrads.length; p++) {
    formGrads[p] = formImages[p];
    formGrads[p] = flipImage(formGrads[p]);
    inputImages[p] = guiImages[p];
    inputImages[p] = flipImage(inputImages[p]);
  }
}
