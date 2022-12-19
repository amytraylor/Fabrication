void setupPointsCreation() {

  //calls function to create points
  //sub functions create base points, reverse base point order, and add the points together
  joinedBaseForm = createBaseRadiusPoints(layerHeightClay, startingZ);

  //send points to the GCodeMaker class
  loadPoints(joinedBaseForm);
  //creates a PShape from the points so it draws faster
  newShape = createShape();
  //creates shape in another thread so main thread can keep going while we wait
  thread("makeShape");
  //sends cooldown commands to printer
  clay.end();
}

//creates the form points and calls the base points, adds them together
PVector[] createBaseRadiusPoints(float _layerHeight, float _startingZ) {
  boolean droop = false;//turns droop off and on
  boolean droopY = false;
  float currentRad = 0;
  float currentTexture =0;
  int ntotal = img.width*img.height;
  PVector[] ptsOuter = new PVector[ntotal];
  PVector[] ptsInner = new PVector[ntotal];
  PVector[] concatPts = new PVector[ntotal*2];//for two walls
  //global class
  vecs = new Vec4[ntotal*2];
  //PVector[] pts = new PVector[ntotal];
  //  println("finalForm.length = ",finalForm.length);

  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {

      int inc = x+y*img.width;

      //color c = copy(imgText, x, y);
      globalStrokeColor[inc] = imgTexture.get(x, y);
      globalStrokeColorB[inc] = brightness(imgTexture.get(x, y));

      //if (chosenForm ==0) {
      //  currentRad = smoothStep(img, inc, 0, 255, radius, radius);
      //} else if (chosenForm==5) {
      //  currentRad = smoothStep(img, inc, 0, 255, radius/4, radius);
      //} else {
      //  currentRad = smoothStep(img, inc, 0, 255, radius/2, radius);
      //}
      currentRad = smoothStep(img, inc, 255, 0, -radius/4, radius);
      currentTexture = smoothStep(imgTexture, inc, 0, 255, minDetail, maxDetail);
      //float currentDetail = smoothStep(imgDetail, inc, 0, 255, -radius/10, radius/10);
      //float baseRad = smoothStep(img, inc, 0, 255, radius, radius*1.5);

      cR[inc] = currentRad;
      cT[inc] = currentTexture;
      //cD[inc]=  currentDetail;

      phase = (1*TWO_PI)*y/img.height;//first multiplier shows how far it moves over from its neighbor pt
      float ampMap = 3;
      if (chosenForm==0) {
        if (y<=img.height/3) {
          amp = map(y, 0, img.height/3, 0, ampMap);
        } else if (y>img.height/3&&y<img.height*0.66) {
          amp=5;
        } else {
          amp = map(y, img.height*0.66, img.height, ampMap, 0);
        }
      } else {
        amp = map(y, 0, img.height, 0, ampMap);
      }

      freq = 3;//map(y, 0, img.height, 0, 1); //frequency of ripple//was 25
      //println("thetaStart: " + theta);
      //outside
      //float rT = cR[inc]+cT[inc]+amp*sin(theta*freq+phase);
      //float rT = cR[inc]+cT[inc]+  (amp*sin(theta*freq));//no image texture
      float rT = cR[inc]+cT[inc]*sin(theta);
      float xT = rT*sin(theta);
      float yT = rT*cos(theta);

      //inside
      float rT2 = cR[inc]-(cT[inc]+pathWidth)*sin(theta);
      //float rT2 = (cR[inc]-cT[inc])- pathWidth+ (amp*sin(theta*freq));
      float xT2 = rT2*sin(theta);
      float yT2 = rT2*cos(theta);

      int countVal1 = (y*(img.width*2))+x;
      int countVal2 = ((y*(img.width*2))+ img.width)+ x;

      float minLayerHeight = _layerHeight*1.0;
      float maxLayerHeight = _layerHeight*1.0;
      float mapLeft = map(x, 0, img.width/2, maxLayerHeight, minLayerHeight);
      float mapRight = map(x, img.width/2, img.width, minLayerHeight, maxLayerHeight);
      if (x<img.width/2) {
        ptsInner[inc] = new PVector(xT2, yT2, _startingZ+y*mapLeft);
        ptsOuter[inc] = new PVector(xT, yT, _startingZ+y*mapLeft);
      } else {
        ptsInner[inc] = new PVector(xT2, yT2, _startingZ+y*mapRight);
        ptsOuter[inc] = new PVector(xT, yT, _startingZ+y*mapRight);
      }
      if (y==0) {
        //drawBase(bT);
        basePts[x] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z);
      }
      float div = 500;
      if ((y>img.height*0.24)&&droop) {
        concatPts[countVal1] = new PVector(ptsInner[inc].x-inc/div, ptsInner[inc].y-inc/div, ptsInner[inc].z+inc/500);
        concatPts[countVal2] = new PVector(ptsOuter[inc].x-inc/div, ptsOuter[inc].y-inc/div, ptsOuter[inc].z+inc/500);
        vecs[countVal1] = new Vec4(ptsOuter[inc].x-inc/div, ptsOuter[inc].y-inc/div, ptsOuter[inc].z+inc/500, extrusionForm);
        vecs[countVal2] = new Vec4(ptsOuter[inc].x-inc/div, ptsOuter[inc].y-inc/div, ptsOuter[inc].z+inc/500, extrusionForm);
      } else {
        concatPts[countVal1] = new PVector(ptsInner[inc].x, ptsInner[inc].y, ptsInner[inc].z);
        concatPts[countVal2] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z);
        vecs[countVal1] = new Vec4(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z+inc/500, extrusionForm);
        vecs[countVal2] = new Vec4(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z, extrusionForm);
      }
      //println(expand);
      //outside loop at radius*1.5
      float bT = rT;
      //float bxT = bT*sin(theta);
      //float byT = bT*cos(theta);

      //println("x: " + x);
      //println("y: " + y);
      //println("vecs: " + vecs.length);
      //float checkPoint = theta%TWO_PI;
      //float slice = TWO_PI*0.75;
      //float offsetDroop = map(y, 0, numLayers, 0, slice);

      ////println("offset: " + offsetDroop);
      //if (checkPoint>TWO_PI-offsetDroop&&checkPoint<(TWO_PI-(slice-offsetDroop))) {
      //  droop=false;
      //} else {
      //  droop =false;
      //}
      theta+=angleStep;
      // println("theta: " + (theta%TWO_PI));
    }
  }

  globalPtsLength = concatPts.length;
  drawBase(basePts[0].x*1.5, _startingZ);
  //returns base points plus the form points
  return addBasetoForm(concatPts);
  //return addBasetoForm(pts);
}

//takes lowest layer of form and makes a base of decrementing loops
void drawBase(float rad, float z) {
 inc = pathWidth*0.5;//was 2.5 and thats too largwe
  loops = int(rad/inc);
  totalBase = new PVector[loops*numPtsPerLayer];

  for (int l=0; l<loops; l++) {
    for (int i=0; i<numPtsPerLayer; i++) {
      int count = l*numPtsPerLayer+i;
      totalBase[count] = new PVector(rad*sin(theta2), rad*cos(theta2), z);
      theta2+=angleStep2;
    }
    if (rad>0) {
      rad-=inc;
    }
  }
}

//joins base points to form points
PVector[] addBasetoForm(PVector[] pts) {
  //println("pts at beginning of add base:"+pts.length);
  PVector[] newPts = reversePVectorArray(totalBase);
  joinedBaseForm = addPVectorArrays(newPts, pts);
  return joinedBaseForm;
}

//stores all points as a PShape
void makeShape() {
  //float[] doubleColor = new float[globalStrokeColor.length*2];
  int[] doubleColor = concat(globalStrokeColor, globalStrokeColor);
  newShape.beginShape();
  newShape.strokeWeight(2);
  newShape.noFill();
  //println(joinedBaseForm.length);
  for (int i=0; i<joinedBaseForm.length; i++) {
    //if (i%2==0) {

    if (i<totalBase.length) {
      newShape.stroke(255);
    } else {
      if (colorImage) {
        int d = i-totalBase.length;
        newShape.stroke(doubleColor[d]);// globalStrokeColor[inc]
      } else {
        float c = map(i, 0, joinedBaseForm.length, 50, 205);
        newShape.stroke(c);
        //float c = map(i, 0, joinedBaseForm.length, 50, 205);
        //newShape.stroke(c);
      }
    }
    newShape.vertex(joinedBaseForm[i].x, joinedBaseForm[i].y, joinedBaseForm[i].z);
    // }
  }

  newShape.endShape(CLOSE);
}

//send points to the GCodeMaker class
void loadPoints(PVector[] finalPts) {
  PVector[] move = new PVector[finalPts.length];

  //need to move the form inland on the printer
  int moveOverOnBed = 200; //pla is 100, clay is 200
  for (int i=0; i<finalPts.length; i++) {
    move[i] = new PVector(finalPts[i].x + moveOverOnBed, finalPts[i].y+moveOverOnBed, finalPts[i].z);
  }

  //println("ttl: " + totalBase.length);
  //println("move.length: " + move.length);
  //println("m-t: " +(move.length-totalBase.length));
  for (int i=0; i<move.length-1; i++) {
    if (i<totalBase.length) {
      //clay.writePoints(move[i], move[i+1]);
      clay.writePoints(move[i], move[i+1], 4);
    } else {
      int vecsCount = i-(totalBase.length-1);
      clay.writePoints(move[i], move[i+1], vecs[vecsCount].getRate());
      //println(vecs[vecsCount].getRate());
    }
  }
}
