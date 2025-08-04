# pdv-selfcheckout-perto-camera
## Self Checkout Perto com Câmera

>SO: PDV-2.U2204.519.1.9-64

- Instalando

```bash
git clone https://github.com/elppans/pdv-selfcheckout-perto-camera.git
```
```bash
cd pdv-selfcheckout-perto-camera
```
```bash
bash pythonCam_dep-u2204-9.sh
```
```bash
bash install_self-camera-perto.sh
```

>Informe o Usuario da Câmera;  
>Informe o Senha da Câmera;  
>Informe o IP da Câmera.  

- Configurando

Se estiver usando a Interface gráfica, faça o comando `xrandr`, mas se estiver em uma sessão SSH dê um cat no arquivo /tmp/displays.
Será informado quais entradas estão conectadas, por exemplo:

```ini
HDMI-1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 410mm x 230mm
   1024x768      60.00*+  75.03    70.07    60.00
   1920x1080     60.00    59.94
   1280x720      60.00    59.94
   800x600       72.19    75.00    60.32    56.25
   ...
HDMI-2 connected 1920x1080+1024+0 (normal left inverted right x axis y axis) 477mm x 268mm
   1920x1080     60.00*+  50.00    50.00    50.00    59.94
   1600x1200     60.00
   1680x1050     59.88
   1600x900      59.98
   .....
```
- Arquivo `monitor-pos-set-perto.sh`

Neste exemplo, dá pra ver que o HDMI-2 (1920x1080) é o monitor primário e o HDMI-1 (1024x768) é o monitor secundário.

Edite o arquivo `/Zanthus/Zeus/pdvJava/monitor-pos-set-perto.sh`, vá até as linhas "16-19" e deixe exatamente as mesmas informações nas variáveis:

```ini
monitor1='HDMI-2'      # Monitor Primário
monitor2='HDMI-1'      # Monitor Secundário
resolucao1='1920x1080' # Resolução do Monitor Primário
resolucao2='1024x768'  # Resolução do Monitor Secundário
```

Este arquivo é o responsável para "mandar" o aplicativo da Câmera para o Monitor Secundário.

- Arquivo `self_perto_config.sh`

Edite o arquivo `/Zanthus/Zeus/pdvJava/self_perto_config.sh` modifique, se necessário as linhas 7-20:

```ini
monitor_primario="HDMI-2"
monitor_secundario="HDMI-1"
resolucao_primaria="1920x1080"
resolucao_secundaria="1024x768"
alinhamento_tela="1920x156" # (1080 - 768 / 2)
```
