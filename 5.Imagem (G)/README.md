## Filtros Utilizados
### 1. Conversão para Escala de Cinza:
___Fundamento:___ Reduz a complexidade da imagem ao eliminar variações de cor, simplificando a análise ao reter apenas a luminância.
___Implementação:___ Utiliza coeficientes específicos para a conversão RGB para cinza, refletindo a percepção humana de diferentes cores.

### 2. Filtro Gaussiano (Suavização):

___Fundamento:___ Aplica um efeito de desfoque para suavizar a imagem, o que ajuda a reduzir o ruído e as variações de intensidade causadas por detalhes finos.
___Implementação:___ Utiliza um kernel de convolução gaussiano com um sigma de 1.5, preparando a imagem para uma detecção de bordas mais eficaz.

### 3. Filtro de Sobel:

___Fundamento:___ Utilizado para detectar as bordas na imagem, essencial para a etapa subsequente de segmentação.
___Implementação:___ Aplica kernels de Sobel para calcular a magnitude do gradiente em cada pixel, destacando as bordas.

### 4. Limiarização:

___Fundamento:___ Simplifica a imagem resultante do filtro de Sobel para uma forma binária, facilitando a distinção entre o objeto e o fundo.
___Implementação:___ Aplica um limiar fixo para binarizar a imagem, onde os pixels acima do limiar são convertidos em branco e os demais em preto.

### 5. Flood Fill:

___Fundamento:___ Utilizado para preencher regiões conectadas, assumindo que uma semente é colocada dentro do objeto de interesse.
___Implementação:___ Começa a partir de um ponto dado e preenche toda a área conectada com uma nova cor, substituindo a cor original.

### 6. Dilatação:

___Fundamento:___ Engrossa as bordas detectadas para assegurar continuidade, útil em preparação para técnicas de preenchimento como o flood fill.
Implementação: Expande as regiões brancas (bordas) para incluir pixels adjacentes, aumentando a robustez contra interrupções nas bordas.

## Dificuldades e Soluções
- ___Dificuldade:___ Ruído na imagem pode levar a detecções de bordas falsas.
    - ___Solução:___ Aplicação do filtro gaussiano para suavizar a imagem antes da detecção de bordas, minimizando o impacto de detalhes insignificantes.

- ___Dificuldade:___ Bordas incompletas que complicam o processo de flood fill.
    - ___Solução:___ Dilatação das bordas após a detecção com o filtro de Sobel para garantir que todas as bordas estejam conectadas e completas antes de aplicar o flood fill.

- ___Dificuldade:___ Segmentação inclui pequenas áreas não desejadas após o flood fill.
    - ___Solução:___ Uso da dilatação para engrossar e conectar melhor as bordas, seguido de uma possível implementação futura de remoção de ruído que identifica e elimina componentes conectados menores que um limiar específico.