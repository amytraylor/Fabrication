//class used to store variable layer heights and extrusion rates for nonplanar mode
class Points{
  PVector pt;
  float layerHeight;
  float extrudeRate;
  Points(PVector _pt, float _layerHeight, float _extrudeRate){
    pt = _pt;
    layerHeight = _layerHeight;    
    extrudeRate = _extrudeRate;
  }  
  
  PVector getVec(){
    return pt;
  }
  float getLayerHeight(){
    return layerHeight;
  }
  
  float getExtrudeRate(){
    return extrudeRate;
  }
}
