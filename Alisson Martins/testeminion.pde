PImage img; // Declaração da variável para armazenar a imagem

void setup() {
  size(800, 600); // Define o tamanho da janela
  img = loadImage("minion.jpg"); // Carrega a imagem do arquivo "imagem.jpg"
}

void draw() {
  background(255); // Define o fundo da tela como branco
  image(img, 0, 0); // Desenha a imagem na posição (0, 0)
}
