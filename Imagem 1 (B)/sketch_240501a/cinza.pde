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
