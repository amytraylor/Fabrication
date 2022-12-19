void setupPointsCreation() {

  //calls function to create points
  //sub functions create base points, reverse base point order, and add the points together
  createBaseRadiusPoints(layerHeightClay, startingZ);
  makeShape();
}

void readImagePixels() {
  //loops through the entire image and returns a count of how many pixels are black
  //from the right and the left
  for (int i = 0; i<img.height; i++) {
    blackLeft[i] = checkPixelsLeft(i, img);
    blackRight[i] = checkPixelsRight(i, img);
    if (blackLeft[i]<=midPoint) {
      layerRadLeft[i] = midPoint - blackLeft[i];
    } 
    if (blackRight[i]<=midPoint) {
      layerRadRight[i] = midPoint - blackRight[i];
    }
  }
}

void smoothPixels() {
  float[] avgL = new float[img.height];
  float[] avgR = new float[img.height];
  int numAvg = 10;
  for (int n = 0; n<img.height; n++) {
    avgL[n] = runningAverage(layerRadLeft[n], numAvg);
    avgR[n] = runningAverage(layerRadRight[n], numAvg);
  }

  for (int p = 0; p<img.height; p++) {
    layerRadLeft[p] = avgL[p];
    layerRadRight[p] = avgR[p];
  }
}

//creates the form points and calls the base points, adds them together
void createBaseRadiusPoints(float _layerHeight, float _startingZ) {
  float currentRad = 0;
  float currentTexture =0;
  boolean changePath = false;
  int count = 0;
  int ntotal = img.width*img.height;
  PVector[] pts = new PVector[ntotal];

  //for double walls  
  float mapWallDist = 0;
  float theta3 = 0;
  float angleStep3 = TWO_PI/(numPtsPerLayer-1);
  PVector[] ptsOuter = new PVector[ntotal];
  PVector[] ptsInner = new PVector[ntotal];
  PVector[] concatPts = new PVector[ntotal*2];//for two walls
  newTexture = createImage(img.width*2, img.height, RGB);
  //for nonPlanar
  float mappedLayerHeight = 0;
  float mappedExtrudeRate = 1;
  float[] runningZ = new float[img.width];
  //end nonplanar


  float minRadL = min(layerRadLeft);
  float minRadR = min(layerRadRight);
  float maxRadL = max(layerRadLeft);
  float maxRadR = max(layerRadRight);

  for (int m = 0; m<layerRadLeft.length; m++) {
    layerRadLeft[m] = map(layerRadLeft[m], minRadL, maxRadL, minRadius, maxRadius);
    layerRadRight[m] = map(layerRadRight[m], minRadR, maxRadR, minRadius, maxRadius);
  }

  if (doubleWall) {
    ptsData = new Points[concatPts.length];
  } else {
    ptsData = new Points[pts.length];
  }

  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      int inc = x+y*img.width;

      //color c = copy(imgText, x, y);
      globalStrokeColor[inc] = imgTexture.get(x, y);
      globalStrokeColorB[inc] = brightness(imgTexture.get(x, y));

      currentTexture = smoothStep(imgTexture, inc, 255, 0, minDetail, maxDetail);

      cR[inc] = currentRad;
      cT[inc] = currentTexture;

      if (nonPlanar) {
        float minScale = 0.85;
        float maxScale = 1.0;
        float n = sin((numHumps*TWO_PI*x)/(numPtsPerLayer-1));
        mappedLayerHeight = map(sin(n), -1, 1, layerHeightClay*minScale, layerHeightClay*maxScale);
        mappedExtrudeRate = map(mappedLayerHeight, layerHeightClay*minScale, layerHeightClay*maxScale, extrudeRateClay*minScale, extrudeRateClay*maxScale);
        _layerHeight = mappedLayerHeight;
      } else {
        mappedLayerHeight = layerHeightClay;
        mappedExtrudeRate = extrudeRateClay;
      }

      float r1 = layerRadRight[y];
      float r2 = layerRadLeft[y];
      float r3 = layerRadRight[y];
      float r4 = layerRadLeft[y];

      if (doubleWall) {

        float diffRad = layerRadLeft[y] +(layerRadRight[y]-layerRadLeft[y])*(sin(theta3/2)*sin(theta3/2));

        float rad = 0;
        if (oval) {
          //CHANGEME
          //rad = 0.5*(radiusOval-radiusOval)*sin(theta3)+(layerRadRight[y]-layerRadLeft[y])*cos(theta3);
          //rad = radiusOval + (diffRad - radiusOval)*(sin((theta3+PI/2)/2)*sin((theta3+PI/2)/2));
          rad = radiusOval + (diffRad - radiusOval)*(sin(theta3+(angleStep3/2)/2)*sin(theta3+(angleStep3)/2));
          //rad = radiusOval + (diffRad - radiusOval)*(sin(theta3/2)*sin(theta3/2));
          //rad = radiusOval + (diffRad - radiusOval)*(sin(theta3+(angleStep3/4)/2)*sin(theta3+(angleStep3)/2));
        } else {
          rad = diffRad;
        }

        float rT = rad+cT[inc]+amp;
        float xT = rT*sin(theta3);
        float yT = rT*cos(theta3);
        //CHANGEME
        mapWallDist = map(y, 0, img.height, 0.98, 0.98);
        float rT2 = rT-pathWidth*0.75;//was * mapWallDist
        float xT2 = rT2*sin(theta3);
        float yT2 = rT2*cos(theta3);

        int countVal1 = (y*(img.width*2))+x;
        int countVal2 = ((y*(img.width*2))+ img.width)+ x;

        runningZ[x]+=_layerHeight;
        if (numBaseLayers==2) {
          ptsInner[inc] = new PVector(xT2, yT2, _startingZ+secondLayerHeight + runningZ[x]);
          ptsOuter[inc] = new PVector(xT, yT, _startingZ+secondLayerHeight +runningZ[x]);
        } else {
          ptsInner[inc] = new PVector(xT2, yT2, _startingZ+ runningZ[x]);
          ptsOuter[inc] = new PVector(xT, yT, _startingZ+runningZ[x]);
        }
        //divisor controls number of seams
        int change = int(img.width/freq);
        if (inc%change==0) {
          changePath = true;
        }
        if (changePath) {
          if (count<change) {
            count+=1;
          } else {
            count=0;
            changePath=false;
          }
        }
        if (changePath) {
          concatPts[countVal1] = new PVector(ptsInner[inc].x, ptsInner[inc].y, ptsInner[inc].z);
          concatPts[countVal2] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z);
        } else {
          concatPts[countVal2] = new PVector(ptsInner[inc].x, ptsInner[inc].y, ptsInner[inc].z);
          concatPts[countVal1] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, ptsOuter[inc].z);
        }
        ptsData[countVal1] = new Points(concatPts[inc], mappedLayerHeight, mappedExtrudeRate);
        ptsData[countVal2] = new Points(concatPts[inc], mappedLayerHeight, mappedExtrudeRate);
        newTexture.pixels[countVal1] = globalStrokeColor[inc];
        newTexture.pixels[countVal2] = globalStrokeColor[inc];

        if (y==0) {
          //stores points only for base layer
          basePts[x] = new PVector(ptsOuter[inc].x, ptsOuter[inc].y, _startingZ);
        }
      } else {
        float diffRad = layerRadLeft[y] +(layerRadRight[y]-layerRadLeft[y])*(sin(theta3/2)*sin(theta3/2));
        float rad = 0;
        float radiusOval = 0;
        if (oval) {
          radiusOval= diffRad/2;
          //CHANGEME
          //rad = 0.5*(radiusOval-radiusOval)*sin(theta3)+(layerRadRight[y]-layerRadLeft[y])*cos(theta3);
          //rad = radiusOval + (diffRad - radiusOval)*(sin((theta3+PI/2)/2)*sin((theta3+PI/2)/2));
          rad = radiusOval + (diffRad - radiusOval)*(sin(theta3+(angleStep3/4)/2)*sin(theta3+(angleStep3)/2));
        } else {
          rad = diffRad;
        }
        float rT = rad+cT[inc]+amp;
        float xT = rT*sin(theta);
        float yT = rT*cos(theta);
        runningZ[x]+=_layerHeight;
        if (numBaseLayers==2) {
          pts[inc] = new PVector(xT, yT, _startingZ+secondLayerHeight+runningZ[x]);
        } else {
          pts[inc] = new PVector(xT, yT, _startingZ+runningZ[x]);
        }
        ptsData[inc] = new Points(pts[inc], mappedLayerHeight, mappedExtrudeRate);
        //stores points only for base layer
        if (y==0) {
          basePts[x] = new PVector(pts[inc].x, pts[inc].y, _startingZ);
        }
      }
    }

    theta+=angleStep;
    theta3+=angleStep3;
  }

  drawBase(basePts);
  if (doubleWall) {
    addBasetoForm(concatPts);
  } else {
    addBasetoForm(pts);
  }
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
  float lerpInc = pathWidth*0.75;
  loops = int(maxRad/lerpInc);
  totalBase = new PVector[loops*numPtsPerLayer];

  float lerp = 0;
  float inc = 1.0/loops;
  for (int l=0; l<loops; l++) {
    for (int i=0; i<numPtsPerLayer; i++) {
      int count = l*numPtsPerLayer+i;
      float x = lerp(baseCopy[i].x, center.x, lerp);
      float y = lerp(baseCopy[i].y, center.y, lerp);
      float z = baseCopy[i].z;//lerp(baseCopy[i].z, center.z, lerp);
      totalBase[count] = new PVector(x, y, z);
      theta2+=angleStep2;
    }
    lerp+=inc;
  }
}

//joins base points to form points
void addBasetoForm(PVector[] pts) {
  if (numBaseLayers==2) {
    //add second base layer
    PVector[] secondLayerBase = new PVector[totalBase.length];
    for (int i=0; i<totalBase.length; i++) {
      secondLayerBase[i] = new PVector(totalBase[i].x, totalBase[i].y, totalBase[i].z+secondLayerHeight);
    }

    PVector[] newBasePts = reversePVectorArray(secondLayerBase);
    joinedBaseForm = addPVectorArrays(addPVectorArrays(totalBase, newBasePts), pts);
  } else {
    PVector[] newBasePts = reversePVectorArray(totalBase);
    joinedBaseForm = addPVectorArrays(newBasePts, pts);
  }
}

//stores all points as a PShape
void makeShape() {
  newShape.beginShape();
  newShape.strokeWeight(2);
  newShape.noFill();
  //globalStrokeColorB[joinedBaseForm.length-1] = color(255, 0, 0);
  for (int i=0; i<joinedBaseForm.length; i++) {
    if (i<(totalBase.length*numBaseLayers)) {
      //newShape.fill(globalStrokeColorB[i]);//grey
      newShape.stroke(globalStrokeColorB[i]);//grey
    } else {
      if (doubleWall) {
        int d = i-(totalBase.length*numBaseLayers);
        //newShape.fill(newTexture.pixels[d]);
        newShape.stroke(newTexture.pixels[d]);
      } else {
        int d = i-(totalBase.length*numBaseLayers);
        //newShape.fill(globalStrokeColorB[d]);
        newShape.stroke(globalStrokeColorB[d]);
      }
    }
    float lineOffSet = 0.5;
    //newShape.vertex(joinedBaseForm[i].x-lineOffSet, joinedBaseForm[i].y-lineOffSet, joinedBaseForm[i].z-lineOffSet);
    //newShape.vertex(joinedBaseForm[i].x-lineOffSet, joinedBaseForm[i].y-lineOffSet, joinedBaseForm[i].z+lineOffSet);
    //newShape.vertex(joinedBaseForm[i].x+lineOffSet, joinedBaseForm[i].y+lineOffSet, joinedBaseForm[i].z+lineOffSet);
    //newShape.vertex(joinedBaseForm[i].x+lineOffSet, joinedBaseForm[i].y+lineOffSet, joinedBaseForm[i].z-lineOffSet);

    newShape.vertex(joinedBaseForm[i].x, joinedBaseForm[i].y, joinedBaseForm[i].z);
  }

  newShape.endShape();
}

//send points to the GCodeMaker class
void loadPoints(PVector[] finalPts) {
  PVector[] move = new PVector[finalPts.length];

  //need to move the form inland on the printer
  int moveOverOnBed = printerW/2; 
  for (int i=0; i<finalPts.length; i++) {
    move[i] = new PVector(finalPts[i].x + moveOverOnBed, finalPts[i].y+moveOverOnBed, finalPts[i].z);
  }
  //stores the last z position of the form 
  //so you can move the extruder head up from that point at the end of the print
  endZ = finalPts[finalPts.length-1].z;

  for (int i=0; i<move.length-1; i++) {
    if (i<(totalBase.length*numBaseLayers)) {
      clay.writePoints(move[i], move[i+1], extrudeRateClay);
    } else {
      int d = i-(totalBase.length*numBaseLayers);
      clay.writePoints(move[i], move[i+1], ptsData[d].getExtrudeRate());
    }
  }
}
