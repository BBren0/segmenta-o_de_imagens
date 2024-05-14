PImage sobreporAviao(PImage imgOriginal, PImage imgContorno) {
    imgOriginal.loadPixels();
    imgContorno.loadPixels();

    PImage result = createImage(imgOriginal.width, imgOriginal.height, RGB);
    result.loadPixels();

    color corVermelha = color(139, 0, 0); // A cor usada para o contorno

    for (int i = 0; i < imgOriginal.pixels.length; i++) {
        if (imgContorno.pixels[i] == corVermelha) {
            // Se o pixel é vermelho no contorno, copia o pixel da imagem original
            result.pixels[i] = imgOriginal.pixels[i];
        } else {
            // Caso contrário, define o pixel como preto
            result.pixels[i] = color(0);
        }
    }

    result.updatePixels();
    image(result,0,0);
    save("avião.png");
    return result;
}
