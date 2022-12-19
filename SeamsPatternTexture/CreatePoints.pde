//creates the form points and calls the base points, adds them together
PVector[] createBaseRadiusPoints(float _layerHeight, float _startingZ) {
  int countVal1 = 0;
  int countVal2 = 0;
  boolean wait=false;
  int counter=0;
  int changePath = 1;//used to make a seam
  float currentRad = 0;
  float currentTexture =0;
  int ntotal = img.width*img.height;
  //PVector[] pts = new PVector[ntotal];
  PVector[] ptsOuter = new PVector[ntotal];
  PVector[] ptsInner = new PVector[ntotal];
  PVector[] concatPts = new PVector[(img.width*2)*img.height];//for two walls
  float[] runningZ = new float[img.width];
  float mapWallDist = 0;
  float layerHeightInc =_layerHeight/img.width;
  //println(layerHeightInc);
  newTexture = createImage(img.width*2, img.height, RGB);
  //  println("finalForm.length = ",finalForm.length);

  for (int y=0; y<img.height; y++) {
    theta = 0;
    for (int x=0; x<img.width; x++) {
      int inc = x+y*img.width;
      //println("x: " + x);
      //println("y: " + y); 
      //println("inc: " + inc);

      globalStrokeColor[inc] = imgTexture.pixels[inc];//imgTexture.get(x, y);
      globalStrokeColorB[inc] = brightness(imgTexture.pixels[inc]);


      if (chosenForm ==0) {
        currentRad = smoothStep(img, inc, 0, 255, radius, radius);
      } else if (chosenForm==5) {
        currentRad = smoothStep(img, inc, 0, 255, radius/3, radius);
      } else {
        currentRad = smoothStep(img, inc, 0, 255, radius*0.85, radius);
      }
      //currentTexture = smoothStep(imgTexture, inc, 0, 255, minDetail, maxDetail);

      cR[inc] = currentRad;
      cT[inc] = currentTexture;

      //outside
      float rT = cR[inc]+cT[inc]*sin(theta);
      float xT = rT*sin(theta);
      float yT = rT*cos(theta);

      //inside
      //float rT2 = cR[inc]*sin(theta);
      mapWallDist = map(y, 0, img.height, 0.9, 1.0);
      float rT2 = rT*mapWallDist;
      float xT2 = rT2*sin(theta);
      float yT2 = rT2*cos(theta);

      countVal1 = y*(img.width*2)+x;
      countVal2 = countVal1 + img.width;

      //float z = _layerHeight*(y+(x/img.width));
      runningZ[x]+=_layerHeight;
      ptsInner[inc] = new PVector(xT2, yT2, _startingZ+runningZ[x]);
      ptsOuter[inc] = new PVector(xT, yT, _startingZ+runningZ[x]);

      float r = red(globalStrokeColor[inc]);
      float g = green(globalStrokeColor[inc]);
      //float b = blue(globalStrokeColor[inc]);
      //redImage.pixels[inc] = color(r, g, b);

      //for (int i=0; i<getSeams.size(); i++) {
      //  if (inc%getSeams.get(i).z==0) {
      //    changePath*=-1;
      //  }
      //}
      if (r>50) {
        changePath*=-1;
      }

      if (changePath==1) {
        float ranPath = 0;
        if (g<200) {
          ranPath=random(-0.1, 0.1);
        } else {
          ranPath = 0;
        }
        concatPts[countVal1] = new PVector(ptsOuter[inc].x+ranPath, ptsOuter[inc].y+ranPath, ptsOuter[inc].z);
        concatPts[countVal2] = new PVector(ptsInner[inc].x+ranPath, ptsInner[inc].y+ranPath, ptsInner[inc].z);
        newTexture.pixels[countVal1] = globalStrokeColor[inc];
        newTexture.pixels[countVal2] = globalStrokeColor[inc];
      } else {
        concatPts[countVal1] = new PVector(ptsInner[inc].x, ptsInner[inc].y, ptsInner[inc].z);
        concatPts[countVal2] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z);
        newTexture.pixels[countVal1] = globalStrokeColor[inc];
        newTexture.pixels[countVal2] = globalStrokeColor[inc];
      }
      if (y==0) {
        //drawBase(bT);
        basePts[x] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, _startingZ);
      }
      theta+=angleStep;//inside for loop for x raster first
    }
    //theta+=angleStep;
  }

  //globalPtsLength = pts.length;
  drawBase(basePts);
  //returns base points plus the form points
  return addBasetoForm(concatPts);
}

//takes lowest layer of form and makes a base of decrementing loops
void drawBase(PVector [] base) {
  PVector [] baseCopy = new PVector[base.length];
  arrayCopy(base, baseCopy);
  PVector center = new PVector(0, 0, 0);

  float [] lerpDist = new float[numPtsPerLayer];

  for (int i=0; i<numPtsPerLayer; i++) {
    lerpDist[i] = dist(base[i].x, base[i].y, base[i].z, center.x, center.y, center.z);
  }
  float maxRad = max(lerpDist);
  float lerpInc = pathWidth;
  loops = int(maxRad/lerpInc);

  totalBase = new PVector[loops*numPtsPerLayer];
  //printArray(lerpFactor);
  float lerp = 0;
  float inc = 1.0/loops;
  for (int l=0; l<loops; l++) {
    for (int i=0; i<numPtsPerLayer; i++) {
      int count = l*numPtsPerLayer+i;      
      float x = lerp(baseCopy[i].x, center.x, lerp);
      float y = lerp(baseCopy[i].y, center.y, lerp);
      float z = lerp(baseCopy[i].z, center.z, lerp);
      totalBase[count] = new PVector(x, y, z);
      theta2+=angleStep2;
    }
    lerp+=inc;
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

  newShape.beginShape();
  newShape.strokeWeight(2);
  newShape.noFill();
  //println(joinedBaseForm.length);
  for (int i=0; i<joinedBaseForm.length; i++) {
    //if (i%2==0) {

    if (i<totalBase.length) {
      newShape.stroke(255, i, 255-i);
    } else {
      if (colorImage) {
        //if (colorImage&&i<(joinedBaseForm.length-totalBase.length)/2) {
        //int d = int(i%(img.width*2));//because of 2 walls
        int d = i-totalBase.length;
        newShape.stroke(newTexture.pixels[d]);
      } else {
        //newShape.stroke(globalStrokeColorB[i-totalBase.length]);
        //float c = map(i, 0, joinedBaseForm.length, 50, 205);
        newShape.stroke(255);
      }
    }
    newShape.vertex(joinedBaseForm[i].x, joinedBaseForm[i].y, joinedBaseForm[i].z);
    // }
  }

  newShape.endShape(CLOSE);

  baseShape.beginShape();
  baseShape.strokeWeight(5);
  baseShape.noFill();
  for (int i=0; i<numPtsPerLayer; i++) {

    //strokeWeight(25);
    baseShape.stroke(0, 255, 0);
    baseShape.vertex(basePts[i].x, basePts[i].y, basePts[i].z);
  }
  baseShape.endShape();
  strokeWeight(25);
  point(0, 0, 0);
}

//send points to the GCodeMaker class
void loadPoints(PVector[] finalPts) {
  PVector[] move = new PVector[finalPts.length];

  //need to move the form inland on the printer
  int moveOverOnBed = 100; //pla is 100, clay is 200
  for (int i=0; i<finalPts.length; i++) {
    move[i] = new PVector(finalPts[i].x + moveOverOnBed, finalPts[i].y+moveOverOnBed, finalPts[i].z);
    
  }
  endZ = finalPts[finalPts.length-1].z;
  //for (int i=0; i<move.length-1; i++) {
  //  if (i<totalBase.length) {
  //    pla.writePoints(move[i], move[i+1], extrudeRatePLA);
  //  } else {
  //    int d = i-totalBase.length;
  //    pla.writePoints(move[i], move[i+1], ptsData[d].getExtrudeRate());
  //  }
  //}

  for (int i=0; i<move.length-1; i++) {
    pla.writePoints(move[i], move[i+1]);
  }
}
