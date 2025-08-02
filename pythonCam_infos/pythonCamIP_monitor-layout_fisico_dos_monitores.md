# Layout físico dos monitores

O layout físico dos monitores — **um pequeno em cima (HDMI-1)** e **um grande embaixo (HDMI-2)** — a razão para o uso de `--pos 1920x156`.

---

## Visualizando o cenário

Vamos organizar os dados que você passou:

| Monitor | Nome      | Resolução                 | Posição física          | Papel |
| ------- | --------- | ------------------------- | ----------------------- | ----- |
| HDMI-1  | 1024x768  | Monitor pequeno (em cima) | Janela da câmera        |       |
| HDMI-2  | 1920x1080 | Monitor grande (embaixo)  | Monitor principal / PDV |       |

---

## Por que `--pos 1920x156`?

### 1. `--pos 1920x156` significa:

* Este monitor (HDMI-1) começa:

  * **1920 pixels à direita**
  * **156 pixels acima** (negativo seria acima, positivo é abaixo)

**Mas aqui está o ponto principal:**

> O valor `--pos` é **em relação à origem (0,0)** do primeiro monitor definido.

---

### 2. Qual o problema com `--pos 1920x0` nesse caso?

Se você tivesse feito:

```bash
xrandr --output HDMI-1 --pos 1920x0
```

A tela pequena **ficaria ao lado direito do monitor maior**, e **alinhada verticalmente no topo**.

**Mas isso não representa a realidade física**, pois o monitor pequeno está **acima**, não ao lado.

---

### Então por que `1920x156`?

* **X = 1920** → Começa na borda direita do monitor principal (HDMI-2), que tem largura 1920px.
* **Y = 156** → Está **um pouco abaixo** do topo da tela (do ponto de vista do sistema).

Esse valor foi provavelmente **ajustado manualmente** para que a tela pequena (HDMI-1) **fique alinhada verticalmente com o centro da tela de baixo**, já que:

* A tela de cima tem **768px de altura**
* A tela de baixo tem **1080px**
* Se você quiser centralizar verticalmente a tela de cima com a de baixo, você usaria:

```bash
(1080 - 768) / 2 = 156
```

**Esse é exatamente o número que aparece: `156`**

---

## Conclusão

A posição `--pos 1920x156` foi usada para **alinhar verticalmente o monitor de cima (HDMI-1) com o centro do monitor de baixo (HDMI-2)**, pois:

* HDMI-2 (1920x1080) está **embaixo**
* HDMI-1 (1024x768) está **acima**, fisicamente
* A centralização vertical exige `Y = 156`, pois:

  ```bash
  (1080 - 768) / 2 = 156
  ```

---

## Se quiser fazer isso com cálculos automáticos em um script:

Você pode fazer:

```bash
altura1=$(echo "$resolucao1" | cut -dx -f2)
altura2=$(echo "$resolucao2" | cut -dx -f2)
offset_y=$(( (altura1 - altura2) / 2 ))
```

E então:

```bash
posicao2="${largura_monitor1}x$offset_y"
```

Assim você tem um script que **centraliza verticalmente a tela de cima automaticamente**, sem precisar fixar `156`.
