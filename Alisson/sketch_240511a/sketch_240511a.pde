PImage imageOriginal;
PImage segmentationObject;
PImage segmentationContour;
PImage backgroundRemoved;

void setup() {
  size(800, 600);
  
  // Carrega as imagens
  imageOriginal = loadImage("image.jpg");
  segmentationObject = loadImage("SegmentationObject.png");
  
  // Cria uma cópia da imagem original para trabalhar com a remoção do fundo
  backgroundRemoved = imageOriginal.copy();
  
  // Carrega o contorno da imagem de segmentação
  segmentationContour = createImage(segmentationObject.width, segmentationObject.height, RGB);
  segmentationContour.loadPixels();
  
  // Identifica o contorno na imagem de segmentação
  for (int x = 0; x < segmentationObject.width; x++) {
    for (int y = 0; y < segmentationObject.height; y++) {
      int index = x + y * segmentationObject.width;
      color currentPixel = segmentationObject.pixels[index];
      color nextPixel = (x < segmentationObject.width - 1) ? segmentationObject.pixels[index + 1] : segmentationObject.pixels[index];
      color belowPixel = (y < segmentationObject.height - 1) ? segmentationObject.pixels[index + segmentationObject.width] : segmentationObject.pixels[index];
      
      if (currentPixel != nextPixel || currentPixel != belowPixel) {
        segmentationContour.pixels[index] = color(255,255,255); // Define o contorno como branco
      } else {
        segmentationContour.pixels[index] = color(0);
      }
    }
  }
  
  segmentationContour.updatePixels();
  
  // Remove o fundo da imagem original
  for (int x = 0; x < backgroundRemoved.width; x++) {
    for (int y = 0; y < backgroundRemoved.height; y++) {
      int index = x + y * backgroundRemoved.width;
      color currentPixel = imageOriginal.pixels[index];
      color currentSegmentationPixel = segmentationObject.pixels[index];
      
      if (currentSegmentationPixel == color(0)) {
        backgroundRemoved.pixels[index] = color(0); // Define o fundo como preto
      }
    }
  }
  backgroundRemoved.updatePixels();
}

void draw() {
  background(255);
  
  // Exibe as imagens
  image(imageOriginal, 0, 0, width/2, height/2);
  image(segmentationObject, width/2, 0, width/2, height/2);
  image(segmentationObject, 0, height/2, width/2, height/2);
  image(backgroundRemoved, width/2, height/2, width/2, height/2);
}
