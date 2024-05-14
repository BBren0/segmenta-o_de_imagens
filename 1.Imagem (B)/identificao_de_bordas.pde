
void preenchimento(PImage image, int x, int y, color targetColor, color replacementColor) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) return;
    if (image.pixels[y * image.width + x] != targetColor) return;
    if (image.pixels[y * image.width + x] == replacementColor) return;

    image.pixels[y * image.width + x] = replacementColor;
    
    preenchimento(image, x + 1, y, targetColor, replacementColor);
    preenchimento(image, x - 1, y, targetColor, replacementColor);
    preenchimento(image, x, y + 1, targetColor, replacementColor);
    preenchimento(image, x, y - 1, targetColor, replacementColor);
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
            if (edgeStrength > 128) {
                result.pixels[y * img.width + x] = color(255); // Borda 
                isEdge[x][y] = true;
            } else {
                result.pixels[y * img.width + x] = color(0); // Fora
            }
        }
    }
    result.updatePixels();
    preenchimento(result, startX, startY, color(0), color(139, 0, 0));
    image(result,0,0);
    save("bordas.png");
    return result;
}
