PImage thresholding(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels();
  result.loadPixels();
  
  int threshold = 210;

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
