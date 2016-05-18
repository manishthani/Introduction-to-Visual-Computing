class Filter {
    
  // Sobel filter
  public PImage sobel(PImage img) {
  
    PImage result = createImage(img.width, img.height, ALPHA);
    // clear the image
    
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }
   
    float max = 0;
    float [] buffer = new float[img.width * img.height];
    float weight = 1.f;
    float [] sum_h = new float[img.width * img.height];
    float [] sum_v = new float[img.width * img.height];
    float sum;
    float count, N = 3;
    float [][] temp = {{ 0, 0, 0 },
                       { 0, 0, 0 },
                       { 0, 0, 0 }};
    float [][] hKernel = { { 0, 1, 0 },
                          { 0, 0, 0 },
                          { 0, -1, 0 } };
    float[][] vKernel = { { 0, 0, 0 },
                          { 1, 0, -1 },
                          { 0, 0, 0 } };
  
    for(int i = img.width; i < img.width * img.height - img.width; i++) {
      if((i % img.width != 0) && (i % img.width != img.width-1)){
        count = 0;
        temp[0][0] = brightness(img.pixels[i -img.width -1]) * hKernel [0][0]; 
        temp[0][1] = brightness(img.pixels[i -img.width]) * hKernel [0][1];
        temp[0][2] = brightness(img.pixels[i -img.width +1]) * hKernel [0][2];
        temp[1][0] = brightness(img.pixels[i - 1]) * hKernel [1][0];
        temp[1][1] = brightness(img.pixels[i]) * hKernel [1][1];
        temp[1][2] = brightness(img.pixels[i + 1]) * hKernel [1][2];
        temp[2][0] = brightness(img.pixels[i + img.width -1]) * hKernel [2][0];
        temp[2][1] = brightness(img.pixels[i + img.width]) * hKernel [2][1];
        temp[2][2] = brightness(img.pixels[i + img.width +1]) * hKernel [2][2];
           
        for(int j = 0; j < N; j++){
          for (int k = 0; k < N; k++){
            count = count + temp[j][k];
          }
        }
        sum_h[i] = count;
        
        count = 0;
        temp[0][0] = brightness(img.pixels[i -img.width -1]) * vKernel [0][0]; 
        temp[0][1] = brightness(img.pixels[i -img.width]) * vKernel [0][1];
        temp[0][2] = brightness(img.pixels[i -img.width +1]) * vKernel [0][2];
        temp[1][0] = brightness(img.pixels[i - 1]) * vKernel [1][0];
        temp[1][1] = brightness(img.pixels[i]) * vKernel [1][1];
        temp[1][2] = brightness(img.pixels[i + 1]) * vKernel [1][2];
        temp[2][0] = brightness(img.pixels[i + img.width -1]) * vKernel [2][0];
        temp[2][1] = brightness(img.pixels[i + img.width]) * vKernel [2][1];
        temp[2][2] = brightness(img.pixels[i + img.width +1]) * vKernel [2][2];
         
        for(int j = 0; j < N; j++){
          for (int k = 0; k < N; k++){
            count = count + temp[j][k];
          }
        }
        sum_v[i] = count;
        
        sum = sqrt(pow(sum_h[i], 2) + pow(sum_v[i], 2)) / (float)(weight);
        
        max = max(max, sum);
        
        buffer[i] = sum;
      }
    }
    
    for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
      for (int x = 2; x < img.width - 2; x++) { // Skip left and right
        if (buffer[y * img.width + x] > (max * 0.3f)) { // 30% of the max
          result.pixels[y * img.width + x] = color(255);
        }
        else {
          result.pixels[y * img.width + x] = color(0);
        }
      }
    }
    return result;
  }


  // Thresholding
  public PImage thresholding(PImage img) {
    
    float hueMax = 140;
    float hueMin = 80;
    float brightnessMax = 240;
    float brightnessMin = 0;
    float saturationMax = 265;
    float saturationMin = 100;  
    
    PImage result = createImage(img.width, img.height, RGB); // create a new, initially transparent, ’result’ image
    for(int i = 0; i < img.width * img.height; i++) {
      // do something with the pixel img.pixels[i]
      int pixel = img.pixels[i];
      
      if (hue(pixel)>hueMin && hue(pixel) < hueMax  && brightness(pixel) < brightnessMax && brightness(pixel) > brightnessMin
          && saturation(pixel) > saturationMin && saturation(pixel) < saturationMax) result.pixels[i] = color(255,255,255);
      else result.pixels[i] =  color(0,0,0);
    }
    return result;
  }


  // Gaussian blur filtering
  PImage blur (PImage img) {
    float[][] kernel = { { 9, 12, 9 },
                        {12, 15, 12 },
                        { 9, 12, 9 }};
                 
    float [][] temp =  {{ 0, 0, 0 },
                       { 0, 0, 0 },
                       { 0, 0, 0 }};
                       
    PImage result = createImage(img.width, img.height, ALPHA);
    float count, N = 3;
  
    // clear the image
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }
      
    float weight = 100.f;
    
    for(int i = img.width; i < img.width * img.height - img.width; i++) {
      
      if((i % img.width != 0) && (i % img.width != img.width-1)){
        count = 0;
        
        temp[0][0] = brightness(img.pixels[i -img.width -1]) * kernel [0][0]; 
        temp[0][1] = brightness(img.pixels[i -img.width]) * kernel [0][1];
        temp[0][2] = brightness(img.pixels[i -img.width +1]) * kernel [0][2];
        temp[1][0] = brightness(img.pixels[i - 1]) * kernel [1][0];
        temp[1][1] = brightness(img.pixels[i]) * kernel [1][1];
        temp[1][2] = brightness(img.pixels[i + 1]) * kernel [1][2];
        temp[2][0] = brightness(img.pixels[i + img.width -1]) * kernel [2][0];
        temp[2][1] = brightness(img.pixels[i + img.width]) * kernel [2][1];
        temp[2][2] = brightness(img.pixels[i + img.width +1]) * kernel [2][2];
           
        for(int j = 0; j < N; j++){
          for (int k = 0; k < N; k++){
            count = count + temp[j][k];
          }
        }
        result.pixels[i] = color(count / weight);
      }
    }
    return result;
  }
}