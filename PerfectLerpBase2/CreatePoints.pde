//creates the form points and calls the base points, adds them together
PVector[] createBaseRadiusPoints(float _layerHeight, float _startingZ) {
  float currentRad = 0;
  float currentTexture =0;
  int ntotal = img.width*img.height;
  PVector[] pts = new PVector[ntotal];
  //  println("finalForm.length = ",finalForm.length);

  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      int inc = x+y*img.width;
      //color c = copy(imgText, x, y);
      globalStrokeColor[inc] = imgTexture.get(x, y);
      globalStrokeColorB[inc] = brightness(imgTexture.get(x, y));

      if (chosenForm ==0) {
        currentRad = radius;//smoothStep(img, inc, 0, 255, radius, radius);
      } else if (chosenForm==5) {
        currentRad = smoothStep(img, inc, 0, 255, radius/4, radius);
      } else {
        currentRad = smoothStep(img, inc, 0, 255, radius/2, radius);
      }
      currentTexture = smoothStep(imgTexture, inc, 0, 255, minDetail, maxDetail);
      //float currentDetail = smoothStep(imgDetail, inc, 0, 255, -radius/10, radius/10);
      //float baseRad = smoothStep(img, inc, 0, 255, radius, radius*1.5);

      cR[inc] = currentRad;
      cT[inc] = currentTexture;
      //cD[inc]=  currentDetail;

      phase = (3*TWO_PI)*y/img.height;//first multiplier shows how far it moves over from its neighbor pt

      if (chosenForm==0) {
        if (y<=img.height/3) {        
          amp = map(y, 0, img.height/3, 1, 5);
        } else if (y>img.height/3&&y<img.height*0.66) {
          amp=5;
        } else {
          amp = map(y, img.height*0.66, img.height, 5, 0);
        }
      } else {
        amp = map(y, 0, img.height, 3, 5);
      }

      freq = 11;//map(y, 0, img.height, 0, 1); //frequency of ripple//was 25

      //float rT = cR[inc]+cT[inc]+amp*sin(theta*freq+phase);
      ////float rT = cR[inc]+cT[inc];
      //float xT = rT*sin(theta);
      //float yT = rT*cos(theta);

      float rT1 = cR[inc]+cT[inc]+amp*sin(theta*freq+phase);
      float rT2 = rT1+radius*2;
      float R = rT1+((rT2-rT1)*(sin(theta/2)*sin(theta/2)));
      //println("R:" + R);
      float xT = R*sin(theta);
      float yT = R*cos(theta);

      pts[inc] = new PVector(xT, yT, _startingZ+y*_layerHeight);
      if (y==0) {
        //drawBase(bT);
        basePts[x] = new PVector(pts[inc].x, pts[inc].y, _startingZ);
      }
    }

    theta+=angleStep;
  }

  //globalPtsLength = pts.length;
  drawBase(basePts);
  //returns base points plus the form points
  return addBasetoForm(pts);
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

    if (i<totalBase.length) {
      newShape.stroke(255, i, 255-i);
    } else {
      if (colorImage) {
        newShape.stroke(globalStrokeColor[i-totalBase.length]);
      } else {
        newShape.stroke(globalStrokeColorB[i-totalBase.length]);
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

  for (int i=0; i<move.length-1; i++) {
    pla.writePoints(move[i], move[i+1]);
  }
}
