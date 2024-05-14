void desenharGrafico(int VP, int FP, int FN, int VN) {
    int maxVal = max(VP, FP, FN);
    float scaleFactor = 200.0 / maxVal; 

    fill(0, 255, 0);  // Verde para VP
    rect(50, 250, 50, -VP * scaleFactor);
    fill(255, 0, 0);  // Vermelho para FP
    rect(150, 250, 50, -FP * scaleFactor);
    fill(0, 0, 255);  // Azul para FN
    rect(250, 250, 50, -FN * scaleFactor);
    fill(128, 128, 128);  // Cinza para VN
    rect(350, 250, 50, -VN * scaleFactor);
    
    fill(0);
    text("VP", 65, 265);
    text("FP", 165, 265);
    text("FN", 265, 265);
    text("VN", 365, 265);
    save("grafico.png");
}



void calcularMetricas(PImage image, PImage SegmentationObject) {
    image.loadPixels();
    SegmentationObject.loadPixels();

    int VP = 0, FP = 0, FN = 0, VN = 0;

    for (int i = 0; i < image.pixels.length; i++) {
        boolean segmentado = (brightness(image.pixels[i]) > 210); 
        boolean real = (brightness(SegmentationObject.pixels[i]) > 210);  // mesmo limiar para o ground truth

        if (segmentado && real) VP++;
        else if (segmentado && !real) FP++;
        else if (!segmentado && real) FN++;
        else if (!segmentado && !real) VN++;
    }

    println("Verdadeiros Positivos (VP): " + VP);
    println("Falsos Positivos (FP): " + FP);
    println("Falsos Negativos (FN): " + FN);
    println("Verdadeiros Negativos (VN): " + VN);

    desenharGrafico(VP, FP, FN, VN);
    save("grafico2.png");
    
}
