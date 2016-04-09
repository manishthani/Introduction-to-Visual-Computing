float[][] transform = scaleMatrix(1,1,1);
float[] cubeDimensions = new float[]{100,100,200};
int yMouse = 0;
boolean first = true;
float scale = 1.0;
float rotationX = 0;
float rotationY = 0;

void settings() {
  size(500, 500, P2D);
}
void setup () {}
void draw() {
    background(255, 255, 255);
 
    My3DPoint eye = new My3DPoint(0, 0, -5000);
    My3DPoint origin = new My3DPoint(0, 0, 0);
    My3DBox input3DBox = new My3DBox(origin, cubeDimensions[0], cubeDimensions[1], cubeDimensions[2]);
    input3DBox = transformBox(input3DBox, transform);
    
    float[][] transform2 = translationMatrix(width/2 - cubeDimensions[0]/2, height/2 - cubeDimensions[1]/2, cubeDimensions[2]/2);
    input3DBox = transformBox(input3DBox, transform2);
    
    projectBox(eye, input3DBox).render();
}

void mouseDragged() 
{
 if (first) {
    yMouse = mouseY;
    first = false;
  }
  else {
    if(yMouse < mouseY) scale -= 0.1;
    else scale += 0.1;
    transform = scaleMatrix(scale,scale,scale);
    yMouse = mouseY;
  }
}

void keyPressed() {
  if (key == CODED) {
    float angle = radians(5.0f);
    if (keyCode == UP) {
      rotationX += angle;
      transform = rotateXMatrix (rotationX);
    } 
    else if (keyCode == DOWN) {
      rotationX -= angle;
      transform = rotateXMatrix (rotationX);
    } 
    if (keyCode == LEFT) {
      rotationY += angle;
      transform = rotateYMatrix(rotationY);
    } 
    else if (keyCode == RIGHT) {
      rotationY -= angle;
      transform = rotateYMatrix(rotationY);
    } 
  } 
}

float[][]  rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), sin(angle) , 0},
                        {0, -sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) {
    return(new float[][] {{cos(angle), 0 , sin(angle) , 0},
                        {0, 1, 0 , 0},
                        { -sin(angle),0 , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateZMatrix(float angle) {
    return(new float[][] {{cos(angle), -sin(angle), 0 , 0},
                        {sin(angle), cos(angle),0, 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});
}
float[][] scaleMatrix(float x, float y, float z) { 
      return(new float[][] {{x, 0, 0 , 0},
                            {0, y,0, 0},
                            {0, 0 , z , 0},
                            {0, 0 , 0 , 1}});
}
float[][] translationMatrix(float x, float y, float z) { 
      return(new float[][] {{1, -0, 0 , x},
                            {0, 1,0, y},
                            {0, 0 , 1 , z},
                            {0, 0 , 0 , 1}});
}


float[] matrixProduct(float[][] a, float[] b) { 
  float result[] = new float[a.length];
  for (int i = 0; i < a.length; ++i){
    float partial = 0;
    for(int j = 0; j < b.length; ++j){
      partial += a[i][j] * b[j];
    }
    result[i] = partial; 
  }
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  for (int i = 0; i < box.p.length; ++i){
    float point[] = new float[] {box.p[i].x, box.p[i].y, box.p[i].z,1};
    box.p[i] = euclidian3DPoint(matrixProduct(transformMatrix, point));
  }  
  return box;
}

My3DPoint euclidian3DPoint (float[] a) {
      My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
      return result;
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float[] point = {p.x - eye.x ,p.y-eye.y, p.z-eye.z, -p.z/eye.z+1};
  
  point[0] /= point[3];
  point[1] /= point[3];
  point[2] /= point[3];

  return new My2DPoint(point[0],point[1]);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s = {projectPoint(eye,box.p[0]), projectPoint(eye, box.p[1]),
                  projectPoint(eye,box.p[2]), projectPoint(eye, box.p[3]),
                  projectPoint(eye,box.p[4]), projectPoint(eye, box.p[5]),
                  projectPoint(eye,box.p[6]), projectPoint(eye, box.p[7])
                };
  return new My2DBox(s);
}