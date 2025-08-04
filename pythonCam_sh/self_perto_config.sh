#!/bin/bash

# Kill camera
pkill -f main.py

# Monitores
monitor_primario="HDMI-2"
monitor_secundario="HDMI-1"

# Resolução
resolucao_primaria="1920x1080"
resolucao_secundaria="1024x768"

# Alinhamento da Tela
# Posição para alinhar verticalmente o centro da tela superior com o centro da tela inferior
# Cálculo: (Altura da tela inferior - Altura da tela superior) / 2
# Exemplo: (1080 - 768) / 2 = 156 → deslocamento vertical necessário
# Resultado: "Borda direita do monitor principal x deslocamento vertical"
# "1920x156" > 1920 = posição horizontal (borda direita da tela principal), 156 = deslocamento vertical
alinhamento_tela="1920x156"

export monitor_primario
export monitor_secundario
export resolucao_primaria
export resolucao_secundaria
export alinhamento_tela

# Adjust resolution and touchscreen - FHD
xrandr --output "$monitor_primario" --mode "$resolucao_primaria" --primary
xrandr --output "$monitor_secundario" --mode "$resolucao_secundaria" --right-of "$monitor_primario" --pos "$alinhamento_tela"

# Esta linha fez o Touch não funcionar no Mamãe
# xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.652 0 0  0 1 0  0 0 1

# Adjust resolution and touchscreen - 1024x768
# xrandr --output 1024x768 --mode 1024x768 --primary
# xrandr --output 1024x768 --mode 1024x768 --right-of 1024x768 --pos 1024x0
# xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.5 0 0  0 1 0  0 0 1

# Open camera
sleep 10
python3 /root/pythonCamIP/main.py

