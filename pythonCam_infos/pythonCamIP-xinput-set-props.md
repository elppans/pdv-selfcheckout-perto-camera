# xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.XXX 0 0 0 1 0 0 0 1

Esse comando ajusta a **matriz de transformação de coordenadas** de um dispositivo de entrada — geralmente uma tela sensível ao toque — para que ela se alinhe corretamente com a tela em que está sendo usada.

Se você quer **ver o valor atual** da propriedade `Coordinate Transformation Matrix` de um dispositivo, o comando é:

```bash
xinput list-props "ILITEK ILITEK-TP"
```

🔍 Isso vai listar todas as propriedades do dispositivo, incluindo:

```
Coordinate Transformation Matrix (XXX): 1.000000, 0.000000, 0.000000, ...
```

Substitua `"ILITEK ILITEK-TP"` pelo nome exato do seu dispositivo, se necessário.

---

## 💡 Dica: Filtrar só a matriz

Se quiser ver **somente** a matriz, pode usar `grep`:

```bash
xinput list-props "ILITEK ILITEK-TP" | grep "Coordinate Transformation Matrix"
```

---

## 🧮 E o que significa esse comando?

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.652 0 0  0 1 0  0 0 1
```

Esse comando está **escalando horizontalmente** o toque para 65.2% da largura da tela, sem alterar a altura. Isso é útil quando o touchscreen está fisicamente em um monitor secundário ou em uma área diferente da tela principal.
___

## xinput list-props "ILITEK ILITEK-TP"

```ini
Device 'ILITEK ILITEK-TP':
        Device Enabled (181):   1
        Coordinate Transformation Matrix (183): 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix (323):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix Default (324):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Send Events Modes Available (302):     1, 0
        libinput Send Events Mode Enabled (303):        0, 0
        libinput Send Events Mode Enabled Default (304):        0, 0
        Device Node (305):      "/dev/input/event5"
        Device Product ID (306):        8746, 1
```
Com base na saída, o valor atual da propriedade `Coordinate Transformation Matrix` é:

```
1.000000, 0.000000, 0.000000,  
0.000000, 1.000000, 0.000000,  
0.000000, 0.000000, 1.000000
```

🎯 Esse é o valor **padrão**, que significa que o toque está mapeado diretamente para a tela inteira, sem escalonamento, rotação ou deslocamento.

---

## ✅ Se quiser manter esse mapeamento padrão:

Use este comando:

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 1 0 0  0 1 0  0 0 1
```

---

## 🔧 Se quiser aplicar o valor que você mencionou antes:

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.652 0 0  0 1 0  0 0 1
```

Esse valor **reduz a largura do toque para 65.2% da tela**. Isso é útil, por exemplo, se o touchscreen estiver fisicamente em um monitor à esquerda e você quiser que ele só responda naquela área.

---
## Calculo pra aplicar o valor correto?

Excelente pergunta, Marcelo! O cálculo da **Coordinate Transformation Matrix** depende da posição e tamanho do monitor onde o touchscreen está fisicamente instalado, em relação à tela total do sistema.

Vamos destrinchar isso com clareza:

---

## 🧭 1. Entendendo a Matriz

A matriz tem 9 valores, organizados assim:

```
[ a  b  c ]
[ d  e  f ]
[ g  h  i ]
```

Para mapeamento de toque, normalmente usamos:

```
[ scale_x   0        offset_x ]
[   0     scale_y   offset_y ]
[   0       0          1     ]
```

- `scale_x`: quanto o toque é escalado na horizontal
- `scale_y`: quanto o toque é escalado na vertical
- `offset_x`: deslocamento horizontal (de 0 a 1)
- `offset_y`: deslocamento vertical (de 0 a 1)

---

## 🖥️ 2. Exemplo com dois monitores

Suponha que você tenha dois monitores lado a lado:

| Monitor | Resolução | Posição na tela virtual |
|--------|-----------|--------------------------|
| A (esquerda) | 1920×1080 | (0, 0)                |
| B (direita)  | 1280×1024 | (1920, 0)             |

A tela total tem largura de `1920 + 1280 = 3200` pixels.

Se o touchscreen está **no monitor da esquerda (A)**, queremos que o toque só funcione naquela área.

---

## 🧮 3. Cálculo da Matriz

### Para o monitor da esquerda:

- `scale_x = 1920 / 3200 = 0.6`
- `offset_x = 0 / 3200 = 0`
- `scale_y = 1` (altura igual)
- `offset_y = 0`

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.6 0 0  0 1 0  0 0 1
```

### Para o monitor da direita:

- `scale_x = 1280 / 3200 = 0.4`
- `offset_x = 1920 / 3200 = 0.6`
- `scale_y = 1`
- `offset_y = 0`

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.4 0 0.6  0 1 0  0 0 1
```

---

## 🧰 4. Como descobrir suas resoluções e posições

Use:

```bash
xrandr
```

Ele mostra algo como:

```
HDMI-1 connected primary 1920x1080+0+0
DP-1 connected 1280x1024+1920+0
```

Esses valores são essenciais para calcular a matriz correta.

---
___

# Calculo para HDMI-1 1024x768+0+0 + HDMI-2 1920x1080+1024+0

```ini
HDMI-1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 410mm x 230mm
HDMI-2 connected 1920x1080+1024+0 (normal left inverted right x axis y axis) 477mm x 268mm
```
Perfeito, Marcelo! Vamos calcular a **Coordinate Transformation Matrix** para o seu touchscreen com base na configuração que você passou:

---

## 🖥️ 1. Configuração dos monitores

| Monitor | Nome    | Resolução   | Posição (x,y) |
|--------|---------|-------------|---------------|
| Esquerdo | HDMI-1 | 1024×768    | (0, 0)        |
| Direito  | HDMI-2 | 1920×1080   | (1024, 0)     |

A tela virtual total tem:

- **Largura**: 1024 + 1920 = **2944 pixels**
- **Altura**: máximo entre 768 e 1080 = **1080 pixels**

---

## 🧮 2. Cálculo da matriz

### 👉 Se o touchscreen está no **monitor da esquerda (HDMI-1)**:

- `scale_x = 1024 / 2944 ≈ 0.3478`
- `offset_x = 0 / 2944 = 0`
- `scale_y = 768 / 1080 ≈ 0.7111`
- `offset_y = 0 / 1080 = 0`

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.3478 0 0  0 0.7111 0  0 0 1
```

### 👉 Se o touchscreen está no **monitor da direita (HDMI-2)**:

- `scale_x = 1920 / 2944 ≈ 0.6522`
- `offset_x = 1024 / 2944 ≈ 0.3478`
- `scale_y = 1080 / 1080 = 1`
- `offset_y = 0`

```bash
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.6522 0 0.3478  0 1 0  0 0 1
```

---

## 🧪 3. Teste e ajuste fino

Esses valores devem funcionar bem, mas se o toque parecer um pouco deslocado, você pode ajustar os valores de `offset_x` ou `scale_x` levemente (por exemplo, arredondar para 0.35 ou 0.65).

