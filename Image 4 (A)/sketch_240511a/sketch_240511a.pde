PImage imageOriginal;
PImage segmentationObject;
PImage segmentationContour;
PImage backgroundRemoved;
PImage groundtruth;

void setup() {
  size(500, 400);
  
  // Carrega as imagens
  imageOriginal = loadImage("2007_009911.jpg");
  segmentationObject = loadImage("segmentatio.obje.png");
  
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
  image(backgroundRemoved,backgroundRemoved.width,backgroundRemoved.height);
}

void draw() {
  background(255);
  
  // Exibe as imagens
  //image(imageOriginal, 0, 0, width/2, height/2);
  //image(segmentationObject, width/2, 0, width/2, height/2);
  //image(segmentationObject, 0, height/2, width/2, height/2);
  //image(backgroundRemoved, width/2, height/2, width/2, height/2);
  //save("backgroundRemoved.png");
  //PImage escalaDeCinza = cinza(imageOriginal);
  //PImage gaussiano = gaussiano(escalaDeCinza);
  //PImage thresholding = thresholding(gaussiano);
  //PImage filtroMediano = filtroMediano(thresholding);
  //PImage identificacao_de_bordas = identificacao_de_bordas(filtroMediano,250,189);
  
  
  
  PImage backgroundRemoved = loadImage("identificacao_de_bordas.png");
  calcularMetricas(backgroundRemoved,segmentationObject);
}

PImage cinza(PImage img) {

  PImage out = createImage(img.width, img.height, RGB);

  for (int y=0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      int valor = (int) ((red(img.pixels[pos]) + green(img.pixels[pos]) + blue(img.pixels[pos]))/3);
      out.pixels[pos]= color(valor);
    }
  }
  
  image(out, 0,0);
  save("cinza.png");
  return out;
}


PImage gaussiano(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels();
  result.loadPixels();

  float[][] kernel = {
    {1/16.0, 2/16.0, 1/16.0},
    {2/16.0, 4/16.0, 2/16.0},
    {1/16.0, 2/16.0, 1/16.0}
  };

  for (int y = 1; y < img.height - 1; y++) {
    for (int x = 1; x < img.width - 1; x++) {
      float sumR = 0;
      float sumG = 0;
      float sumB = 0;

      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int posX = x + kx;
          int posY = y + ky;
          int pos = posY * img.width + posX;
          float coef = kernel[ky + 1][kx + 1];

          sumR += red(img.pixels[pos]) * coef;
          sumG += green(img.pixels[pos]) * coef;
          sumB += blue(img.pixels[pos]) * coef;
        }
      }

      // Colocar o valor calculado no pixel central
      int newColor = color(sumR, sumG, sumB);
      result.pixels[y * img.width + x] = newColor;
    }
  }

  result.updatePixels();
  image(result,0,0);
  save("gaussiano.png");
  return result;
}


import java.util.ArrayDeque;
import java.util.Deque;

class Point {
    int x, y;
    
    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

void preenchimento(PImage img, int startX, int startY, int newColor, int oldColor) {
    Deque<Point> stack = new ArrayDeque<>();
    stack.push(new Point(startX, startY));

    img.loadPixels();
    while (!stack.isEmpty()) {
        Point p = stack.pop();
        int x = p.x;
        int y = p.y;
        if (x < 0 || x >= img.width || y < 0 || y >= img.height) continue;

        int currentColor = img.pixels[y * img.width + x];
        if (currentColor != oldColor || currentColor == newColor) continue;

        img.pixels[y * img.width + x] = newColor;

        stack.push(new Point(x + 1, y));
        stack.push(new Point(x - 1, y));
        stack.push(new Point(x, y + 1));
        stack.push(new Point(x, y - 1));
    }
    img.updatePixels();
}

PImage identificacao_de_bordas(PImage img, int startX, int startY) {
    PImage result = createImage(img.width, img.height, RGB);
    img.loadPixels();
    result.loadPixels();

    // filtro de Sobel
    boolean[][] isEdge = new boolean[img.width][img.height];
    float[][] gx = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    float[][] gy = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    for (int y = 1; y < img.height - 1; y++) {
        for (int x = 1; x < img.width - 1; x++) {
            float sumX = 0;
            float sumY = 0;
            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    int nx = x + i;
                    int ny = y + j;
                    int pos = ny * img.width + nx;
                    float val = brightness(img.pixels[pos]);
                    sumX += val * gx[j+1][i+1];
                    sumY += val * gy[j+1][i+1];
                }
            }
            float edgeStrength = sqrt(sq(sumX) + sq(sumY));
            if (edgeStrength > 150) {
                result.pixels[y * img.width + x] = color(255); // Borda 
                isEdge[x][y] = true;
            } else {
                result.pixels[y * img.width + x] = color(0); // Fora
            }
        }
    }

    
    preenchimento(result, startX, startY, color(139, 0, 0), color(0));
    result.updatePixels();
    image(result, 0, 0);
    save("identificacao_de_bordas.png");
    return result;
}


PImage thresholding(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels();
  result.loadPixels();
  
  int threshold = 130;

  // Processamento de cada pixel para limiarização
  for (int i = 0; i < img.pixels.length; i++) {
    // Calcula o brilho do pixel atual
    float brightness = brightness(img.pixels[i]);

    // Aplica o limiar
    if (brightness >= threshold) {
      result.pixels[i] = color(0); // Define o pixel como branco
    } else {
      result.pixels[i] = color(255,165,0); // Define o pixel como preto
    }
  }

  result.updatePixels(); // Atualiza os pixels da imagem resultante
  image(result,0,0);
  save("limiar.png");
  return result;
}

PImage filtroMediano(PImage img) {
    PImage result = createImage(img.width, img.height, RGB);
    img.loadPixels();
    result.loadPixels();

    for (int y = 1; y < img.height - 1; y++) {
        for (int x = 1; x < img.width - 1; x++) {
            int[] window = new int[9];
            int i = 0;
            for (int ky = -1; ky <= 1; ky++) {
                for (int kx = -1; kx <= 1; kx++) {
                    int pos = (y + ky) * img.width + (x + kx);
                    window[i++] = img.pixels[pos];
                }
            }
            // Ordenando manualmente o array pequeno para encontrar o mediano
            window = sortNine(window);
            result.pixels[y * img.width + x] = window[4]; // O valor mediano
        }
    }

    result.updatePixels();
    return result;
}

// Função para ordenar manualmente um array de 9 elementos
int[] sortNine(int[] arr) {
    for (int i = 0; i < arr.length; i++) {
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[i] > arr[j]) {
                // Troca os elementos
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
    return arr;
}
