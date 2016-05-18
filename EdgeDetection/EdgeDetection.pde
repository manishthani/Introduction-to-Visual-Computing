import java.util.Collections;
import java.util.Random;

PImage img, img2, img3;
Filter filter;
EdgeDetector detector;
//Capture cam;

void settings() {
  size(815, 240);
}

void setup() {
  img = loadImage("board1.jpg");
  filter = new Filter();
  detector = new EdgeDetector();
}

void draw() {
  
  img.resize(320, 240);
  image(img, 0, 0);
  PImage filterImage = filter.sobel(filter.blur(filter.thresholding(img)));
  ArrayList<PVector> lines = detector.hough(filterImage);
  detector.getIntersections(lines);
  image(img2 = detector.gethoughImg(), img.width, 0);
  image(filterImage, img.width + img2.width, 0);
  
  
  // Selection of quads
  /*QuadGraph graph = new QuadGraph();
  graph.build(lines, width, height);
  List<int[]> quads = graph.findCycles();
 
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    
    List<PVector> quadSorted = new ArrayList<PVector>();
    quadSorted.add(l1);
    quadSorted.add(l2);
    quadSorted.add(l3);
    quadSorted.add(l4);
    
    quadSorted = graph.sortCorners(quadSorted);
    if (graph.isConvex(quadSorted.get(0),quadSorted.get(1),quadSorted.get(2),quadSorted.get(3)) 
        && !graph.nonFlatQuad(quadSorted.get(0),quadSorted.get(1),quadSorted.get(2),quadSorted.get(3)) 
        && graph.validArea(quadSorted.get(0),quadSorted.get(1),quadSorted.get(2),quadSorted.get(3), 2*width+2*height, (2*width+2*height)/4) ){
      // (intersection() is a simplified version of the
      // intersections() method you wrote last week, that simply
      // return the coordinates of the intersection between 2 lines)
      ArrayList<PVector> l12 = new ArrayList<PVector>();
      l12.add(l1);
      l12.add(l2);
      
      ArrayList<PVector> l23 = new ArrayList<PVector>();
      l23.add(l2);
      l23.add(l3);
          
      ArrayList<PVector> l34 = new ArrayList<PVector>();
      l34.add(l3);
      l34.add(l4);
      
      ArrayList<PVector> l41 = new ArrayList<PVector>();
      l41.add(l4);
      l41.add(l1);
      
      PVector c12 = detector.getIntersections(l12).get(0);
      PVector c23 = detector.getIntersections(l23).get(0);
      PVector c34 = detector.getIntersections(l34).get(0);
      PVector c41 = detector.getIntersections(l41).get(0);
      // Choose a random, semi-transparent colour
      Random random = new Random();
      fill(color(min(255, random.nextInt(300)),
      min(255, random.nextInt(300)),
      min(255, random.nextInt(300)), 50));
      quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
    }
   }*/
}