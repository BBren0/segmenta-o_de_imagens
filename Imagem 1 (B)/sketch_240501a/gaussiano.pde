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
