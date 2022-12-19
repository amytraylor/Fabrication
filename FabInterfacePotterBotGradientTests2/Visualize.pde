PGraphics drawPoints(PGraphics _form) {

  PGraphics drawForm = createGraphics(width, height, P3D);
  drawForm =_form;
  drawForm.beginDraw();
  drawForm.background(255, 255, 100);
  drawForm.pushMatrix();
  drawForm.translate(width/2+xpos, height/2+50+ypos, 0+zpos);
  float rot = map(mouseY, 0, height, 0.5, 2.0);
  drawForm.rotateX(rot);//1.57);
  drawForm.rotateY(0);
  drawForm.rotateZ(radians(mouseX));
  drawForm.shape(newShape);
  drawForm.popMatrix();
  drawForm.endDraw();
  return drawForm;
}
