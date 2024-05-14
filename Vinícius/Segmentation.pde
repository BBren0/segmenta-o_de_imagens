PImage imageOriginal;
PImage segmentationObject;
PImage segmentationContour;
PImage backgroundRemoved;

void setup() {
  size(800, 600);
  
  // Carrega as imagens
  imageOriginal = loadImage("Image.jpg");
  segmentationObject = loadImage("SegmentationObject.png");
  backgroundRemoved = imageOriginal.copy();
  
  // Cria e processa a imagem de contorno
  segmentationContour = createImage(segmentationObject.width, segmentationObject.height, RGB);
  createContour(segmentationObject, segmentationContour);
  
  // Processa o preenchimento e a remoção de fundo
  floodFill(segmentationContour, 229, 181, color(128, 0, 0), color(0));
  removeBackground(segmentationObject, backgroundRemoved);
  
  noLoop();
}

void draw() {
  background(255);
  image(imageOriginal, 0, 0, width/2, height/2);
  image(segmentationObject, width/2, 0, width/2, height/2);
  image(segmentationContour, 0, height/2, width/2, height/2);
  image(backgroundRemoved, width/2, height/2, width/2, height/2);
}

void createContour(PImage img, PImage contour) {
  img.loadPixels();
  contour.loadPixels();
  
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int index = x + y * img.width;
      color currentPixel = img.pixels[index];
      color nextPixel = (x < img.width - 1) ? img.pixels[index + 1] : img.pixels[index];
      color belowPixel = (y < img.height - 1) ? img.pixels[index + img.width] : img.pixels[index];
      
      if (currentPixel != nextPixel || currentPixel != belowPixel) {
        contour.pixels[index] = color(255, 255, 255); // Contour color
      } else {
        contour.pixels[index] = color(0);
      }
    }
  }
  contour.updatePixels();
}

void floodFill(PImage img, int x, int y, color newColor, color oldColor) {
  ArrayList<int[]> queue = new ArrayList<int[]>();
  queue.add(new int[]{x, y});

  while (!queue.isEmpty()) {
    int[] pos = queue.remove(0);
    int px = pos[0];
    int py = pos[1];

    if (px < 0 || py < 0 || px >= img.width || py >= img.height) continue;
    if (img.pixels[py * img.width + px] != oldColor) continue;

    img.pixels[py * img.width + px] = newColor;
    queue.add(new int[]{px + 1, py});
    queue.add(new int[]{px - 1, py});
    queue.add(new int[]{px, py + 1});
    queue.add(new int[]{px, py - 1});
  }
  img.updatePixels();
}

void removeBackground(PImage segImg, PImage bgRemoved) {
  segImg.loadPixels();
  bgRemoved.loadPixels();
  
  for (int i = 0; i < segImg.pixels.length; i++) {
    if (segImg.pixels[i] == color(0)) {
      bgRemoved.pixels[i] = color(0); // Define o fundo como cinza
    }
  }
  bgRemoved.updatePixels();
}
