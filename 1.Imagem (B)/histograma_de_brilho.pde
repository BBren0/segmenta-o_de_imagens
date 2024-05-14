void histograma_de_brilho(PImage img){
  // Histograma de brilho
    int[] hist = new int[256];
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      int bright = int(brightness(img.pixels[i]));
      hist[bright]++;
    }
    int histMax = max(hist);
    background(255);
    stroke(0);
    for (int i = 0; i < 256; i++) {
      int x = int(map(i, 0, 255, 0, width));
      int h = int(map(hist[i], 0, histMax, 0, height));
      line(x, height, x, height - h);
    }
    
    save("histogramaBrilho.png");
}
