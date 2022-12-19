String dataPath = "K:/OneDrive/Pictures/gradients/";

void loadImages() {
  input = createGraphics(width/3, height);
  //output=createGraphics(width/3, height, P3D);
  form=createGraphics(width/3, height);
  guiImages = new PImage[6];
  inputImages = new PImage[6];
  formImages = new PImage[6];
  formGrads = new PImage[6];
  buttonLocs = new PVector[6];
  buttonLocsForm = new PVector[6];

  guiImages[0] = loadImage(dataPath+"albers-1111532.png");
  guiImages[1] = loadImage(dataPath+"4Faces_748by199_black_flipped.png");
  guiImages[2] = loadImage(dataPath+"PinkPomTighterWeave360by206.png");
  guiImages[3] = loadImage(dataPath+"SquiggleTrail_mostawesomemulti_360by360blur.png");//ArcPurpleLime
  guiImages[4] = loadImage(dataPath+"flower_repeat.png");
  guiImages[5] = loadImage(dataPath+"embryos2blurskinny.png");

  inputImages[0] = guiImages[0];
  inputImages[1] = guiImages[1];
  inputImages[2] = guiImages[2];
  inputImages[3] = guiImages[3];
  inputImages[4] = guiImages[4];
  inputImages[5] = guiImages[5];

  //inputImages[0] = loadImage("albers-1111532_crop_blur5.png");
  //inputImages[1] = loadImage("albers-1112012_crop_squares_blur5.png");
  //inputImages[2] = loadImage("turtle-grid-103853_blur5.png");
  //inputImages[3] = loadImage("slitscan_blur20_mirror_4colors_restrictive_diffusion.gif");//
  //inputImages[4] = loadImage("flower_repeat_crop_blur3.png");
  //inputImages[5] = loadImage("hashPlaid1TealonTeal-01_crop_blur5.png");

  formImages[0] = loadImage(dataPath+"Form5.png");
  formImages[1] = loadImage(dataPath+"Form1.png");
  formImages[2] = loadImage(dataPath+"Form4.png");
  formImages[3] = loadImage(dataPath+"Form3.png");
  formImages[4] = loadImage(dataPath+"Form6.png");
  formImages[5] = loadImage(dataPath+"Form2.png");

  //formGrads[0] = loadImage("linear_blur_green-24_23.png");
  //formGrads[1] = loadImage("linear_blur_green-25_24.png");
  //formGrads[2] = loadImage("linear_blur_green-29_0.png");
  //formGrads[3] = loadImage("linear_blur_green-30_58.png");
  //formGrads[4] = loadImage("linear_blur_green-31_41.png");
  //formGrads[5] = loadImage("linear_blur_green-32_19.png");

  formGrads[0] = loadImage(dataPath+"curve_gradient16_13.png");
  formGrads[1] = loadImage(dataPath+"checkImage-35_53.png");
  formGrads[2] = loadImage(dataPath+"checkImage-35_53.png");
  formGrads[3] = loadImage(dataPath+"curve_gradient16_48.png");
  formGrads[4] = loadImage(dataPath+"dots_gradient.png");
  formGrads[5] = loadImage(dataPath+"triangle_gradient-31_25.png");
  
  //formImages[0] = formGrads[0];
  //formImages[1] = formGrads[1];
  //formImages[2] = formGrads[2];
  //formImages[3] = formGrads[3];
  //formImages[4] = formGrads[4];
  //formImages[5] = formGrads[5];
}
