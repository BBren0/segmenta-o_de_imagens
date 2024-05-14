void histograma_de_cor(PImage img){
 //Histograma de cor
  int[] rHistogram = new int[256];
  int[] gHistogram = new int[256];
  int[] bHistogram = new int[256];
  // Verifica a cor de cada pixel
  for (int i = 0; i < img.pixels.length; i++) {
    int c = img.pixels[i];
    rHistogram[int(red(c))]++;
    gHistogram[int(green(c))]++;
    bHistogram[int(blue(c))]++;
  }
  
  int rMax = max(rHistogram);
  int gMax = max(gHistogram);
  int bMax = max(bHistogram);
  int overallMax = max(rMax, gMax, bMax);
  
  background(255);
  strokeWeight(2);
  
  // Desenhar histogramas de cores
  for (int i = 0; i < 256; i++) {
    float x = map(i, 0, 255, 0, width);

    // Vermelho
    stroke(255, 0, 0, 150); // Cor vermelha com transparência
    int rh = int(map(rHistogram[i], 0, overallMax, 0, height));
    line(x, height, x, height - rh);

    // Verde
    stroke(0, 255, 0, 150); // Cor verde com transparência
    int gh = int(map(gHistogram[i], 0, overallMax, 0, height));
    line(x, height, x, height - gh);

    // Azul
    stroke(0, 0, 255, 150); // Cor azul com transparência
    int bh = int(map(bHistogram[i], 0, overallMax, 0, height));
    line(x, height, x, height - bh);
  }
  save("histogramaCor.png");
  

}
