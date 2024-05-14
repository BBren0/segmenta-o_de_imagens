void setup() {
  size(500, 375);
  noLoop();
}

void draw() {
  PImage img = loadImage("\\Fotos\\Fotos\\2010_001448.jpg");

   //histograma_de_brilho(img);
   //histograma_de_cor(img);
   //PImage imgCinza = cinza(img);
   //PImage imgGaussiano = gaussiano(imgCinza);
   //PImage limiar = thresholding(imgGaussiano);
   //PImage bordas = identificacao_de_bordas(limiar,200,200);
   //sobreporAviao(img, bordas);
   
   PImage imgSegmentada = loadImage("\\bordas.png");
   PImage groundTruth = loadImage("\\Fotos\\SegmentationObject\\2010_001448.png");
   calcularMetricas(imgSegmentada, groundTruth);
   save("gráficos.png");
  
}
  
  
  
