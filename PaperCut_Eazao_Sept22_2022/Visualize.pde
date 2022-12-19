PGraphics drawPoints(PGraphics _form) {

  PGraphics drawForm = createGraphics(width, height, P3D);
  drawForm =_form;
  drawForm.beginDraw();
  //drawForm.spotLight(255, 0, 0, 0, height/2, 800, -1, 0, 0, PI/2, mouseX);
  drawForm.background(#E8E1EA);
  drawForm.pushMatrix();
  drawForm.translate(width/2+xpos, height/2+60+ypos, 575+zpos);
  float rot = map(mouseY, 0, height, 0.5, 2.0);

  drawForm.rotateX(rot);//1.57);
  drawForm.rotateY(0);
  drawForm.rotateZ(radians(mouseX));
  drawForm.shape(newShape);
  drawForm.popMatrix();
  drawForm.endDraw();
  return drawForm;
}
