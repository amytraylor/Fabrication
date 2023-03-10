class GCodeMaker {
  ArrayList <String> gcode;
  float nozzleSize;
  float pathWidth;
  float layerHeight, layerHeightClay;
  float layerHeightPercent;
  float extrudeRate, extrudeRatePLA;
  float speed;
  float extrusionMultiplier;
  float extrusion;

  float extruded_path_section;
  float filament_section;


  //PLA
  GCodeMaker(float _nozzleSize, float _pathWidth, float _layerHeight, float _extrudeRatePLA, float _extrusionMultiplier) {
    nozzleSize = _nozzleSize;
    pathWidth = _pathWidth;
    layerHeight = _layerHeight;
    extrudeRatePLA= _extrudeRatePLA;
    extrusion = 0;
    extrusionMultiplier =1.0;

    gcode = new ArrayList<String>();
  }

  void printTitle(String title, String name) {
    gCommand(";_______________________________");
    gCommand(";" + title);
    gCommand(";" + name);
  }

  void printParameters(float radius, float radInc, float layerHeight, int layers, int numPtsPerLayer, float wX2, float wY2, float div) {
    gCommand(";radius " + radius);
    gCommand(";layerHeight " + layerHeight);
    gCommand(";layers " + layers);
    gCommand(";numPtsPerLayer " + numPtsPerLayer);
    gCommand(";_______________________________//");
  }

  void printParameters(String imgRad, String imgText, String imgDet, float radius, float layerHeight, int layers, int numPtsPerLayer, String notes) {
    gCommand(";image silhouette " + imgRad);
    gCommand(";image texture " + imgRad);
    gCommand(";image detail " + imgRad);

    gCommand(";radius " + radius);
    gCommand(";layerHeight " + layerHeight);
    gCommand(";layers " + layers);
    gCommand(";numPtsPerLayer " + numPtsPerLayer);
    gCommand(";extrusionMultiplier" + extrusionMultiplier);
    gCommand(";notes: " + notes);
    gCommand(";_______________________________//");
  }

  void start(int _feedRate, float _startX, float _startY, float _startZ, int _widthTable, int _lengthTable, int _heightPrinter) {
    //I removed everything that seemed extraneous
    int feedRate = _feedRate;
    float startX = _startX;
    float startY = _startY;
    float startZ = _startZ;
    int widthTable = _widthTable;
    int lengthTable = _lengthTable;
    int heightPrinter = _heightPrinter;

    //gCommand("G91"); //Relative mode
    gCommand("M83");  //relative coords for E
    gCommand("G21");   //set units to mm

    gCommand("M104 S"+ 210);  //set hotend
    gCommand("M140 S"+60);    //set bed temp
    gCommand("M109 S"+ 210);    //wait for hotend temp
    gCommand("M190 S"+60);    //wait for bed temp

    //gCommand("G1 Z1"); //Up one millimeter
    gCommand("G28"); //Home X and Y axes
    gCommand("G90"); //Absolute mode
    //gCommand("G1 X" + (widthTable/2) + " Y"+ (lengthTable/2)); //Go to the center (modify according to your printer)
    //gCommand("G1 Z0"); //Go to height 0
    gCommand("G1 F" + feedRate);    //set the feedrate
    gCommand("G92 E0"); //Reset extruder value to 0
  }

  void writePoints(PVector pts0, PVector pts1) {
    extrusion=(extrudePLA(new PVector(pts0.x, pts0.y, pts0.z), new PVector(pts1.x, pts1.y, pts1.z))*extrusionMultiplier);
    gCommand("G1 X" + pts0.x + " Y" + pts0.y + " Z" + pts0.z +" E" + extrusion);
  }

  void writePoints(PVector pts0, PVector pts1, float extrusionMulti) {
    extrusion=(extrudePLA(new PVector(pts0.x, pts0.y, pts0.z), new PVector(pts1.x, pts1.y, pts1.z))*extrusionMulti);
    gCommand("G1 X" + pts0.x + " Y" + pts0.y + " Z" + pts0.z +" E" + extrusion);
  }

  void end() {

    gCommand("G91"); //Relative mode
    gCommand("G1 E-4 F3000"); //Retract filament to avoid filament drop on last layer
    gCommand("G1 Z" + (endZ*1.25)); //Facilitate object removal
    gCommand("G1 E4"); //Restore filament position
    gCommand("M 107"); //Turn fans off
  }

  void export() {
    String name_save = "Form_Image"+chosenForm+"_minD"+minDetail+"_maxD" + maxDetail+"_"+day()+"_"+hour()+minute()+second()+"_.gcode";
    //convert from arraylist to array to save struings
    String[] arr_gcode = gcode.toArray(new String[gcode.size()]);
    saveStrings(name_save, arr_gcode);
  }


  float extrudePLA(PVector p1, PVector p2) {
    float points_distance = dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    extruded_path_section = pathWidth*layerHeight;
    float volume_extruded_path = extruded_path_section*points_distance;
    return volume_extruded_path;
  }

  void gCommand(String command) {
    gcode.add(command);
  }
}
