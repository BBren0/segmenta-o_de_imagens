class ImageProcessor {
  
  // Converte uma imagem colorida para a escala de cinza.
  PImage convertToGrayScale(PImage source) {
    PImage result = createImage(source.width, source.height, RGB);
    source.loadPixels();
    result.loadPixels();
    for (int i = 0; i < source.pixels.length; i++) {
      float r = red(source.pixels[i]);
      float g = green(source.pixels[i]);
      float b = blue(source.pixels[i]);
      float grayValue = 0.219 * r + 0.067 * g + 0.714 * b;
      result.pixels[i] = color(grayValue);
    }
    result.updatePixels();
    return result;
  }
  
  // Detectar bordas na imagem.
  PImage applyGaussianBlur(PImage img, float sigma) {
    gray.filter(BLUR, sigma);
    return img;
  }
  
  // Aplica limiarização
  PImage applyThreshold(PImage img, float thresh) {
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = brightness(img.pixels[i]) >= thresh ? color(255) : color(0);
    }
    img.updatePixels();
    return img;
  }
  
  // Detecta bordas usando o filtro de Sobel
  PImage filterSobel(PImage source, PImage destination) {
    int[][] gx = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int[][] gy = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    source.loadPixels();
    destination.loadPixels();

    for (int y = 1; y < source.height - 1; y++) {
      for (int x = 1; x < source.width - 1; x++) {
        float sumX = 0;
        float sumY = 0;

        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int colora = source.pixels[(x + i) + (y + j) * source.width];
            sumX += brightness(colora) * gx[j + 1][i + 1];
            sumY += brightness(colora) * gy[j + 1][i + 1];
          }
        }

        float sum = sqrt(sq(sumX) + sq(sumY));
        destination.pixels[x + y * source.width] = color(sum);
      }
    }
    destination.updatePixels();
    return destination;
  }
  
  // Engrossa as bordas
  PImage dilate(PImage img) {
    PImage temp = img.get();
    temp.loadPixels();
    img.loadPixels();

    for (int y = 1; y < img.height - 1; y++) {
      for (int x = 1; x < img.width - 1; x++) {
        if (temp.pixels[x - 1 + (y - 1) * img.width] == color(255) ||
            temp.pixels[x + (y - 1) * img.width] == color(255) ||
            temp.pixels[x + 1 + (y - 1) * img.width] == color(255) ||
            temp.pixels[x - 1 + y * img.width] == color(255) ||
            temp.pixels[x + 1 + y * img.width] == color(255) ||
            temp.pixels[x - 1 + (y + 1) * img.width] == color(255) ||
            temp.pixels[x + (y + 1) * img.width] == color(255) ||
            temp.pixels[x + 1 + (y + 1) * img.width] == color(255)) {
          img.pixels[x + y * img.width] = color(255);
        }
      }
    }

    img.updatePixels();
    return img;
  }
  
  // Preenche toda a área conectada a partir de um ponto
  PImage floodFill(PImage img, int x, int y, color newColor, color oldColor) {
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
  //removeNoise(img);
  return img;
}
  
  // Mascara o fundo com preto
  PImage maskBackgroundToBlack(PImage source) {
    PImage result = source.copy();
    float threshold = 135;  // Definir um limiar de similaridade para a cor do fundo
  
    source.loadPixels();
    result.loadPixels();
    for (int i = 0; i < source.pixels.length; i++) {
      if (brightness(source.pixels[i]) > threshold) {
        result.pixels[i] = color(0);  // Mudar para preto
      }
    }
    result.updatePixels();
    return result;
  }
  
  // Altera a cor das bordas para amarelo
  void changeBorderToYellow(PImage img) {
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      if (img.pixels[i] == color(255)) {
        img.pixels[i] = color(224, 224, 192); // Muda para o tom de amarelo
      }
    }
    img.updatePixels();
  }
  
  void desenharGrafico(int vp, int fp, int fn, int vn) {
    int yBase = 600;
    int maxVal = max(vp, fp, fn);
    float scaleFactor = 200.0 / maxVal; 

    fill(0, 255, 0);  // Verde para vp
    rect(50, yBase, 50, -vp * scaleFactor);
    fill(255, 0, 0);  // Vermelho para fp
    rect(150, yBase, 50, -fp * scaleFactor);
    fill(0, 0, 255);  // Azul para fn
    rect(250, yBase, 50, -fn * scaleFactor);
    fill(128, 128, 128);  // Cinza para vn
    rect(350, yBase, 50, -vn * scaleFactor);
    
    fill(0);
    text("vp", 65, yBase + 15);
    text("fp", 165, yBase + 15);
    text("fn", 265, yBase + 15);
    text("vn", 365, yBase + 15);
}

void calcularMetricas(PImage imgSegmentada, PImage groundTruth) {
    imgSegmentada.loadPixels();
    groundTruth.loadPixels();

    int vp = 0, fp = 0, fn = 0, vn = 0;

    for (int i = 0; i < imgSegmentada.pixels.length; i++) {
        boolean segmentado = (brightness(imgSegmentada.pixels[i]) > 210); 
        boolean real = (brightness(groundTruth.pixels[i]) > 210);  // mesmo limiar para o ground truth

        if (segmentado && real) vp++;
        else if (segmentado && !real) fp++;
        else if (!segmentado && real) fn++;
        else if (!segmentado && !real) vn++;
    }

    println("Verdadeiros Positivos (vp): " + vp);
    println("Falsos Positivos (fp): " + fp);
    println("Falsos Negativos (fn): " + fn);
    println("Verdadeiros Negativos (vn): " + vn);

    desenharGrafico(vp, fp, fn, vn);
}
}
