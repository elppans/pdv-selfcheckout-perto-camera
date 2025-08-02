#!/bin/bash

# Script para configurar os monitores e mover automaticamente o aplicativo "$aplicacao"

command -v wmctrl >/dev/null 2>&1 || {
  echo >&2 "wmctrl não está instalado. Instale com: sudo apt install wmctrl"
  exit 1
}

# Variáveis para configuração da janela a posicionar
aplicacao="IP Camera Stream" # Camera Self Perto (Cima)
# aplicacao="Interface PDV"  # PDV Touch
# aplicacao="Zanthus Retail" # PDV Java (jpdvgui)

# Variáveis para configuração de monitores
monitor1='HDMI-2'      # Monitor Primário
monitor2='HDMI-1'      # Monitor Secundário
resolucao1='1920x1080' # Resolução do Monitor Primário
resolucao2='1024x768'  # Resolução do Monitor Secundário

# Variáveis para posição dos aplicativos para cada tela
# VARIAVEIS NÃO EDITAVEIS, FUNCIONALIDADE AUTOMATICA
posicao1='0x0' # Posicao Horizontal x Vertical, 1º monitor

# Extrair a largura do primeiro monitor
largura_monitor1=$(echo "$resolucao1" | cut -dx -f1)

# Definir posição do segundo monitor em relação ao primeiro
# ============================================================
# POSICIONAMENTO DO MONITOR SECUNDÁRIO
# ============================================================

# Variável para ativar ou desativar a centralização vertical do monitor secundário
# ------------------------------------------------------------------------------
# Se "true"  → o monitor secundário (geralmente menor) será posicionado ao lado do principal,
#              com um deslocamento vertical que o centraliza na altura do principal.
#              Ideal para setups em que o monitor secundário fica acima ou abaixo visualmente.
# Se "false" → o monitor será alinhado pelo topo (padrão lado a lado, topo-alinhado).

centralizar_monitor=true  # Altere para "false" se não quiser centralização

# Extrair a largura do monitor principal (para calcular a posição X do secundário)
largura_monitor1=$(echo "$resolucao1" | cut -dx -f1)

# Verifica se a centralização está ativada
if [ "$centralizar_monitor" = true ]; then
  # Extrair as alturas dos dois monitores
  altura1=$(echo "$resolucao1" | cut -dx -f2)
  altura2=$(echo "$resolucao2" | cut -dx -f2)
  
  # Calcular o deslocamento vertical necessário para centralizar o monitor secundário
  # Fórmula: (altura do principal - altura do secundário) / 2

  # Direção do monitor secundário: "cima" ou "baixo"
  direcao="cima"

  if [ "$direcao" = "cima" ]; then
    offset_y=$(( (altura1 - altura2) / 2 ))
  else
    offset_y=$(( altura1 + ( (altura2 - altura1) / 2 ) ))
  fi
  
  # Define a posição do segundo monitor (X = largura do primeiro, Y = offset)
  posicao2="${largura_monitor1}x$offset_y"
else
  # Posição padrão: o monitor secundário será alinhado ao topo
  nova_posicao2="${largura_monitor1}x0" # Construir a nova posição para o segundo monitor

  # Substituir a variável posicao2
  # posicao2='1024x0' # Posição após o valor "Horizontal" do 1º monitor. 2º monitor
  posicao2="$nova_posicao2"
fi




# Substitui 'x' por ','
posicaox1="${posicao1//x/,}"
posicaox2="${posicao2//x/,}"

# Exportando todas as variáveis
export monitor1
export monitor2
export resolucao1
export resolucao2
export posicao1
export posicao2
export posicaox1
export posicaox2

echo "monitor1: $monitor1"
echo "monitor2: $monitor2"
echo "resolucao1: $resolucao1"
echo "resolucao2: $resolucao2"
echo "posicao1: $posicao1"
echo "posicao2: $posicao2"
echo "posicaox1: $posicaox1"
echo "posicaox2: $posicaox2"

# Configura a resolução e posição dos monitores
xrandr --output "$monitor1" --mode "$resolucao1" --pos "$posicao1" --primary \
--output "$monitor2" --mode "$resolucao2" --pos "$posicao2"

# Sair para teste, ver se a resolução funciona:
# exit

# Função para definir um Loop/Tempo
sleeping() {
  local time
  time="$1"
  for i in $(seq "$time" -1 1); do
    echo -ne "$i Seg.\r"
    sleep 1
  done
}

monitor_param() {
  monitor_destino="$1"

  # Define a posição com base no número do monitor
  if [ "$monitor_destino" = "1" ]; then
    posicao_janela="$posicaox1"
  elif [ "$monitor_destino" = "2" ]; then
    posicao_janela="$posicaox2"
  else
    echo "Erro: argumento inválido. Use 1 ou 2 para escolher o monitor."
    return 1
  fi

  # Loop para aguardar a janela aparecer
  while true; do
    WMID=$(wmctrl -l | grep "$aplicacao" | awk '{print $1}')
    if [ -z "$WMID" ]; then
      echo -e "Aguardando \"$aplicacao\" iniciar..."
      sleeping 5
      clear
    else
      echo -e "wmctrl -i -r $WMID -e \"0,$posicao_janela,-1,-1\""  # Debug do comando
      wmctrl -i -r "$WMID" -e "0,$posicao_janela,-1,-1"
      echo -e "Janela \"$aplicacao\" encontrada e posicionada no monitor $monitor_destino."
      break
    fi
  done
}

# monitor_param 1  # Posiciona a janela no monitor 1 (normalmente HDMI-2) - (Primário)
monitor_param 2  # Posiciona a janela no monitor 2 (normalmente HDMI-1) - (Secundário)
