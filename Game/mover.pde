class Mover {
  PVector location;
  PVector velocity;
  PVector gravity; 
  float gravityConstant = 0.04;
  boolean stop = false;
  float heightBoard = 14;
  float sizeBoard = 500;
  float halfBoard = sizeBoard/2;
  float radius = 20;
  
  boolean editionMode = false;
  
  PShape sphere;
  Cylinders cylinders;
 
   
  Mover() {
    location = new PVector(0,10,0);
    velocity = new PVector(0,0,0);
    gravity = new PVector(0,0.1,0);
    
    cylinders = new Cylinders();
    cylinders.setupCylinder();
    
    sphere = new PShape();
  }
  
  void update(float angleX, float angleZ) {
    

   gravity.x = sin(angleZ) * gravityConstant;
   gravity.z = sin(angleX) * gravityConstant;
   
   float normalForce = 1.1;
   float mu = 0.07;
   float frictionMagnitude = normalForce * mu;
   PVector friction = velocity.copy();
   
   friction.mult(-1);
   friction.normalize();
   friction.mult(frictionMagnitude);

   if(!editionMode){
     velocity.add(gravity);
     velocity.add(friction);
     location.add(velocity);
   }
  }
  void display(boolean shiftPressed) {
    editionMode = shiftPressed;
    lights();
    translate(width/2, height/2, 0);
    if (!shiftPressed){  
      
      rotateX(-angleX);
      rotateZ(angleZ);
      
      // Draw board
      fill(152,152,255);
      noStroke();
      box(sizeBoard, heightBoard, sizeBoard);
      
      translate(0,-(radius + (heightBoard/2)),0); 
      
      // Draw sphere and movement
      pushMatrix();
      translate(location.x, 0, location.z);
      fill(255,255,51);
      noStroke();
      sphere = createShape(SPHERE, radius);
      shape(sphere);
      popMatrix();
      
    }
    else {
      velocity.x = 0;
      velocity.z = 0;
      editionMode();
    }
    // Cylinders
    fill(153, 76,0);
    noStroke();
    cylinders.drawCylinders(shiftPressed);
  }
  
  void editionMode(){
    rectMode(CENTER);
    fill(0,0,102);
    noStroke();
    rect(0, 0, sizeBoard,sizeBoard );

    fill(204,204,0);
    noStroke();
    ellipse(location.x,location.z,radius*2,radius*2);

  }
  
  void checkEdges() {
      if (abs(location.x) >  halfBoard ) {
          location.x = (location.x > halfBoard) ? halfBoard: -halfBoard;
        if (abs(velocity.x) < 0.001){
          velocity.x = 0;
        }
        else
          velocity.x = velocity.x * -1;
      }
      if (abs(location.z) > halfBoard ) {
          location.z = (location.z > halfBoard) ? halfBoard: -halfBoard;
        if (abs(velocity.z) < 0.001){
          velocity.z = 0;
        }
        else
          velocity.z = velocity.z * -1;        
      }
   
  }
  
  void checkCylinderCollision() {
    ArrayList<PVector> cylinderList = cylinders.cylinderList;
    for(PVector cylinder: cylinderList){
      
      if( dist (cylinder.x,0,cylinder.y, location.x, 0, location.z ) <= radius + cylinders.cylinderBaseSize){
        
        // Collision
        PVector normal = new PVector (cylinder.x - location.x , 0, cylinder.y - location.z);
       
        PVector collisionPoint = new PVector (location.x - cylinder.x, 0, location.z - cylinder.y);
        collisionPoint.setMag(radius + cylinders.cylinderBaseSize);
        collisionPoint.x = collisionPoint.x + cylinder.x;
        collisionPoint.z = collisionPoint.z + cylinder.y;
        
        normal.normalize();
        normal.mult(-1);
   
        PVector normal2 = normal.copy();

        velocity.sub((normal.mult((normal2.dot(velocity)))).mult(2)); 
        location = collisionPoint;
        
      }
    }
  }
}