  Mover mover;
  int yMouse = 0;
  int xMouse = 0;
  boolean first = true;
  float angleX = 0;
  float angleZ = 0;
  float speed = 0.1;
  
  boolean shiftPressed = false;
 

  void settings() {
    size(1000, 1000, P3D);
  }
  void setup() {
    mover = new Mover();
  }
  
  void draw() {
    background(255);
    mover.update(angleX,angleZ);
    mover.checkEdges();
    mover.checkCylinderCollision();
    mover.display(shiftPressed);
  }
  

  void mouseDragged() {
    if (first) {
      xMouse = mouseX;
      yMouse = mouseY;
      first = false;
    }
    else {
      if(!shiftPressed){
        if(yMouse < mouseY && (degrees(angleX) < 60)) angleX+=speed;
        else if(yMouse > mouseY && (degrees(angleX) > -60) )  angleX -= speed;
        yMouse = mouseY; 
        if(xMouse < mouseX && (degrees(angleZ) < 60)) angleZ+=speed;
        else if(xMouse > mouseX && (degrees(angleZ) > -60))  angleZ -= speed;
        xMouse = mouseX;
      }
        
    }
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (e < 0 && speed > 0.1) speed -= 0.001;
    else if (e > 0  && speed < 0.5)speed += 0.001;
  }
  
  void keyPressed(){
    if(key == CODED) {
      if (keyCode == SHIFT) {
         shiftPressed = true;
      }
    }
  }
  void keyReleased() {
    if(key == CODED) {
      if (keyCode == SHIFT) {
         shiftPressed = false;
      }
    }  
  }
  
  void mouseClicked() {
    int x = mouseX - width/2;
    int y = mouseY - height/2;
    if(shiftPressed && mover.cylinders.overlapCheck(x, y)) {
      if((abs(x) < mover.halfBoard && abs(y) < mover.halfBoard) && (dist(x, y, mover.location.x, mover.location.z) > (mover.radius + mover.cylinders.cylinderBaseSize))){
        mover.cylinders.addCylinderAt(x, y);
      }
    }
  }
  