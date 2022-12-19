class GCodeMaker {
  ArrayList <String> gcode;
  //zero for PLA and 1 for clay
  int mode;
  float nozzleSize;
  float pathWidth;
  float layerHeightClay;
  float layerHeightPercent;
  float extrudeRate, extrudeRateBase;
  float speed;
  float extrusionMultiplier;
  float extrusion;

  float extruded_path_section;
  float filament_section;

  //Clay
  GCodeMaker(float _nozzleSize, float _layerHeightClay, float _extrudeRate, float _extrudeRateBase, float _speed) {
    mode =1;
    nozzleSize = _nozzleSize;
    layerHeightClay = _layerHeightClay;
    extrudeRate= _extrudeRate; //usually 3 to start
    extrudeRateBase = _extrudeRateBase;
    //println("top: " + extrudeRate);
    speed = _speed;
    extrusion = 0;
    gcode = new ArrayList<String>();
  }


  void printTitle(String title, String name) {
    gCommand(";_______________________________");
    gCommand(";" + title);
    gCommand(";" + name);
  }

  void start(int _feedRate, float _startX, float _startY, float _startZ, int _widthTable, int _lengthTable, int _heightPrinter) {
    //I removed everything that seemed extraneous
    int feedRate = _feedRate;
    //float startX = _startX;
    //float startY = _startY;
    float startZ = _startZ;
    //int widthTable = _widthTable;
    //int lengthTable = _lengthTable;
    //int heightPrinter = _heightPrinter;
    gCommand("; feed rate: " + feedRate);
    gCommand("; startingZ: " + startZ);
    gCommand("; ER: "+extrudeRate);
    gCommand("; ER_Base: " + extrudeRateBase);
    gCommand("; nozzle size: "+nozzleSize);
    gCommand("; layer height: "+layerHeightClay);
    gCommand("; numPtsPerLayer: " +  numPtsPerLayer);
    gCommand("; numLayers: " + numLayers);
    gCommand("; radius: " + radius);
    gCommand("; inc: " + inc);
    gCommand("; minDetail: " + minDetail);
    gCommand("; maxDetail: " + maxDetail);
    gCommand(";_______________________________");
    gCommand("M105");//metric values
    gCommand("M109 S0");//metric values
    gCommand("M82");//metric values
    gCommand("G21");//metric values
    gCommand("G90 ");//absolute positioning
    gCommand("M82") ;//set extruder to absolute mode
    // gCommand("G28 X0 Y0 ");//move X/Y to min endstops
    // gCommand("G28 Z0") ;//move Z to min endstops
    gCommand("G1 X200 Y200 Z150.0 F1500 ") ;//move the platform down 15mm
    gCommand("G1 F40000 E2000");
    gCommand("G92 E0 ");//zero the extruded length
    gCommand("G1 F200 E3 ");//extrude 3mm of feed stock
    gCommand("G92 E0 ");//zero the extruded length again
    gCommand("M302");
    gCommand("G1 F1500");

    gCommand("M302 S0") ; //always allow extrusion (disable checking)
    gCommand("M163 S0 P0.9 "); //Set Mix Factor
    gCommand("M163 S1 P0.1") ;// Set Mix Factor
    gCommand("M164 S0");
    gCommand("G92 E0 ");//zero the extruded length again
    gCommand("M107");//zero the extruded length again
    gCommand("G1 F" + feedRate);
  }

  void writePoints(PVector pts0, PVector pts1) {
    extrusion+=(extrudeClay(new PVector(pts0.x, pts0.y, pts0.z ), new PVector(pts1.x, pts1.y, pts1.z )));
    gCommand("G1 X" + pts0.x + " Y" + pts0.y + " Z" + pts0.z +" E" + extrusion);
  }

  void writePoints(PVector pts0, PVector pts1, float extrude) {
    extrusion+=(extrudeClay(new PVector(pts0.x, pts0.y, pts0.z ), new PVector(pts1.x, pts1.y, pts1.z ), extrude));
    gCommand("G1 X" + pts0.x + " Y" + pts0.y + " Z" + pts0.z +" E" + extrusion);
  }

  void end() {
    //gCommand("M83");
    gCommand("G91"); //Relative mode
    gCommand("G1 F1500 Z+2"); //Retract clay
    //gCommand("G1 X50 Y100 Z100"); //Facilitate object removal
    gCommand("G28 X0");
    gCommand("G90");
  }

  void export() {
    String name_save = "gcode_CLAY" +day()+""+hour()+""+minute()+"_"+second()+"_.gcode";
    //convert from arraylist to array to save struings
    String[] arr_gcode = gcode.toArray(new String[gcode.size()]);
    saveStrings(name_save, arr_gcode);
  }

  float extrudeClay(PVector p1, PVector p2) {
    float points_distance = dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);

    //println("layerDaRest: " + (points_distance*extrudeRate));
    return points_distance*extrudeRate;

    //println("ER:"+extrudeRate);
    //return points_distance*extrudeRate;
  }

  float extrudeClay(PVector p1, PVector p2, float extrude) {
    float points_distance = dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      //println("layerDaRest: " + (points_distance*extrudeRate));
      return points_distance*extrude;

    //println("ER:"+extrudeRate);
    //return points_distance*extrudeRate;
  }


  void gCommand(String command) {
    gcode.add(command);
  }
}
