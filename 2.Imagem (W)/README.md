## Filtros Utilizados
- ___Conversão para Escala de Cinza:___ Fundamentar para reduzir a complexidade da imagem, facilitando a análise ao eliminar a variação de cor.
- ___Filtro Gaussiano (Suavização):___ Aplica um efeito de desfoque que ajuda a reduzir o ruído e as variações de intensidade devido a detalhes finos, preparando a imagem para uma detecção de bordas mais eficaz.
- ___Filtro de Sobel:___ Utilizado para destacar as bordas na imagem, essencial para a etapa subsequente de segmentação.
- ___Limiarização:___ Simplifica a imagem resultante do filtro de Sobel para uma forma binária, facilitando a separação entre o objeto e o fundo.
- ___Flood Fill:___ Usado para preencher o objeto segmentado, assumindo que uma semente é colocada dentro do objeto de interesse.
- ___Remoção de Ruído:___ Etapa de pós-processamento para eliminar pequenos objetos ou ruídos remanescentes que não são parte do objeto de interesse.

## Dificuldades e Soluções
- ___Dificuldade:___ Ruído na imagem que pode levar a detecções de bordas falsas.
    - ___Solução:___ Aplicação do filtro gaussiano para suavizar a imagem antes da detecção de bordas.
- ___Dificuldade:___ Bordas incompletas que complicam o processo de flood fill.
    - ___Solução:___ Ajuste no limiar do filtro de Sobel para garantir a completude das bordas antes de aplicar o flood fill.
- ___Dificuldade:___ Segmentação inclui pequenas áreas não desejadas.
    - ___Solução:___ Implementação de um algoritmo de remoção de ruído que identifica e elimina componentes conectados menores que um limiar específico.