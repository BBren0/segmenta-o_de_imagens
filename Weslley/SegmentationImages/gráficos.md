### Verdadeiro Positivos (VP)
- Definição: São os casos onde o modelo previu corretamente a presença de uma classe. Seriam os pixels corretamente indentificados como parte do objeto de interesse.
- Significado: Indica o número de identificações corretas do objeto ou condição que está tentando detectar.
#### Verdadeiros Positivos (vp): 6001

### Falso Positivos(FP):
- Definição: Ocorrem quando o modelo prevê erroneamente a presença de uma classe. Ele identifica algo como presente quando, na verdade, não está.
- Significado: Representa erros onde o modelo vê algo que não está lá. Em avião, seria um pixel ou região marcada como avião, mas que na realidade é apenas parte do céu ou outro objeto.
#### Falsos Positivos (fp): 2382

### Falso Negativos (FN):
- Definição: Acontecem quando o modelo não detecta a presença de uma classe que está presente. O modelo falha em identificar algo que deveria.
- Significado: Mostra as omissões do modelo, onde ele não conseguiu detectar algo que deveria detectar. Seria a parte do avião que não foi marcada como tal.
#### Falsos Negativos (fn): 1271

### Verdadeiros Negativos (VN):
- Definição: São casos em que o modelo corretamente indentifica a ausência de uma classe.
- Significado: Indica que o modelo corretamente identificou áreas que não são parte do objeto de interesse. No caso do avião, seriam todas as áreas corretamente identificadas como não sendo aviões.
#### Verdadeiros Negativos (vn): 180346


## Métricas
#### Precisão (Precision): 71.59%
#### Recall (Sensibilidade): 82.52%
#### Acurácia (Accuracy): 98.08%