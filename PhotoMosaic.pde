PImage main;
PImage smallerMain;
PImage[] allImages;
float[] brightness;
PImage[] brightImages;

int scale = 8;
int w,h;
  
void setup(){
  size(800,600);
  main = loadImage("main.JPG");
  
  File[] files = listFiles(sketchPath("data"));
  allImages = new PImage[files.length];
  //allImages = new PImage[600];
  brightness = new float[allImages.length];
  brightImages = new PImage[256];
  
  for (int i = 0; i < allImages.length; i ++){
    String fileName = files[i].toString();  
    PImage img = loadImage(fileName);
    
    allImages[i] = createImage(scale,scale,RGB);
    allImages[i].copy(img,0,0,img.width,img.height,0,0,scale,scale);
    allImages[i].loadPixels();
    float avg = 0;
    for (int j = 0; j < allImages[i].pixels.length; j ++){
      float b = brightness(allImages[i].pixels[j]);
      avg += b;
    }
    avg /= allImages[i].pixels.length;
    brightness[i] = avg;
  }
  printArray(allImages);
  
  for (int i = 0; i < brightImages.length; i ++){
    float record = 256;
    for (int j = 0; j < brightness.length; j ++){
      float diff = abs(i - brightness[j]);
      if (diff < record){
        record = diff;
        brightImages[i] = allImages[j];
      }
    }
  }
  
  w = main.width/scale;
  h = main.height/scale;
  smallerMain = createImage(w,h,RGB);
  smallerMain.copy(main,0,0,main.width,main.height,0,0,w,h);
}


void draw(){
  smallerMain.loadPixels();
  for (int x = 0; x < w; x ++){
    for (int y = 0; y < h; y ++){
      int index = x + y * w; 
      color c = smallerMain.pixels[index];
      int imageIndex = int(brightness(c));
      image(brightImages[imageIndex],x*scale,y*scale,scale,scale);
      //fill();
      //noStroke();
      //rect(x*scale,y*scale,scale,scale);
    }
  }
    
  //image(main,0,0);
  //image(smallerMain,0,0);
  noLoop();
  
}