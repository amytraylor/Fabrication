PVector[] addPVectorArrays(PVector[] array1, PVector[] array2) {
  PVector[] array3;

  try {
    for (int n=0; n<array1.length; n++) {
      assert(array1[n] != null);
    }
  }
  catch( AssertionError e ) {
    println("array1 contains null elements");
  }

  try {
    for (int n=0; n<array2.length; n++) {
      assert(array2[n] != null);
    }
  }

  catch( AssertionError e ) {
    println("array2 contains null elements");
  }

  array3=new PVector[array1.length+array2.length];

  for (int n=0; n<array3.length; n++) {
    array3[n] = new PVector(2, 2, 2);
  }

  for (int p=0; p<array3.length; p++) {
    if (p<array1.length) {
      array3[p] = array1[p];
    } else {
      int t = p-array1.length;
      array3[p] = array2[t];
    }
  }

  return array3;
  //printArray(array3);
}

PVector[] reversePVectorArray( PVector[] v ) {
  int n = v.length;
  PVector[] u = new PVector[n];
  for (int i=0; i<n; ++i) {
    int j = n-i-1;
    u[j] = new PVector(v[i].x, v[i].y, v[i].z);
  }
  return u;
}

float smoothStep(PImage img, int inc, float origMin, float origMax, float minDist, float maxDist) {
  int pixLength = img.pixels.length;
  float val1, val2, val3, val4, val5, avg = 0;
  //covers all rows but first and last
  if (inc>img.width&&inc<pixLength-img.width) {
    val1 = brightness(img.pixels[inc]);
    val2 = brightness(img.pixels[inc-1]);
    val3 = brightness(img.pixels[inc+1]);
    val4 = brightness(img.pixels[inc-img.width]);
    val5 = brightness(img.pixels[inc+img.width]);
    avg = (val1 + val2 + val3 + val4 + val5)/5;
    //covers first row
  } else if (inc<pixLength-img.width&&inc!=0) {
    val1 = brightness(img.pixels[inc]);
    val2 = brightness(img.pixels[inc-1]);
    val3 = brightness(img.pixels[inc+1]);
    //val4 = brightness(img.pixels[inc-img.width]);
    val5 = brightness(img.pixels[inc+img.width]);
    avg = (val1 + val2 + val3 + val5)/4;
    //covers first pixel
  } else if (inc == 0) {
    val1 = brightness(img.pixels[inc]);
    //val2 = brightness(img.pixels[inc-1]);
    val3 = brightness(img.pixels[inc+1]);
    //val4 = brightness(img.pixels[inc-img.width]);
    val5 = brightness(img.pixels[inc+img.width]);
    avg = (val1 + val3 + val5)/3;
    //covers last pixel
  } else if (inc==pixLength) {
    val1 = brightness(img.pixels[inc]);
    val2 = brightness(img.pixels[inc-1]);
    //val3 = brightness(img.pixels[inc+1]);
    val4 = brightness(img.pixels[inc-img.width]);
    //val5 = brightness(img.pixels[inc+img.width]);
    avg = (val1 + val2 + val4)/3;
  } else {
    //assume all that are left is the last row, excluding the last pixel
    //which is inc>pixLength-img.width && inc!=pix.length
    val1 = brightness(img.pixels[inc]);
    val2 = brightness(img.pixels[inc-1]);
    //val3 = brightness(img.pixels[inc+1]);
    val4 = brightness(img.pixels[inc-img.width]);
    //val5 = brightness(img.pixels[inc+img.width]);
    avg = (val1 + val2 + val4)/3;
  }
  avg = map(avg, origMin, origMax, minDist, maxDist);
  return avg;
}

PImage flipImage(PImage _img) {
  PImage img = createImage(_img.width, _img.height, RGB);
  img.loadPixels();
  _img.loadPixels();
  for (int y=img.height-1; y>0; y--) {
    for (int x=img.width-1; x>0; x--) {
      int countDown = x+y*img.width;
      int countUp = (img.width*img.height)-countDown;
      img.pixels[countUp] = _img.pixels[countDown];
    }
  }

  return img;
}

float checkPixelsLeft(int yPos, PImage formImg) {
  PImage img = formImg;
  int countBlack = 0;

  for (int x=0; x<img.width; x++) {
    int count = x+yPos*img.width;
    float b = brightness(img.pixels[count]);
    if (b<200) {
      countBlack++;
    } else {
      return countBlack;
    }
  }
  return countBlack;
}

float checkPixelsRight(int yPos, PImage formImg) {
  PImage img = formImg;
  int countBlack = 0;

  for (int x=0; x<img.width; x++) {
    int count = (yPos*img.width+img.width-x)-1;

    float b = brightness(img.pixels[count]);
    if (b<200) {
      countBlack++;
    } else {
      return countBlack;
    }
  }
  return countBlack;
}



float runningAverage(float current, int num) {
  ArrayList<Float> runAvg = new ArrayList<Float>();
  //int count =0;
  //num = window size
  //current is current index of incoming array
  //count is total samples received

  if (runAvg.size()<num) {
    runAvg.add(current);
    //count++;
  } else {
    runAvg.remove(0);
    //count--;
  }
  float avg = 0;
  //println(count);
  for (int i=0; i<runAvg.size(); i++) {
    avg+=runAvg.get(i);
  }
  //println("runAvg.size: " + runAvg.size());
  //println("avg: " + avg/count);
  float count = runAvg.size()/1.0;
  return avg/count;
}

float avg(float[] window) {
  float sum = 0;
  for (int i=0; i<window.length; i++) {
    sum+=window[i];
  }
  return sum/window.length;
}

float getRadius(int circ) {
  float rad = 0;
  rad = (circ/PI)/2;
  return rad;
}

float getRadius(float d) {
  float rad = 0;
  rad = d/2;
  return rad;
}
