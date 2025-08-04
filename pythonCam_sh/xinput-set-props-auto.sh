#!/bin/bash

# Detecta monitores conectados
monitores=($(xrandr | grep " connected" | awk '{print $1}'))

if [ ${#monitores[@]} -lt 2 ]; then
  echo "Menos de dois monitores conectados. Abortando."
  exit 1
fi

# Obtem resoluções nativas
declare -A resolucoes
for monitor in "${monitores[@]}"; do
  res=$(xrandr | grep -A1 "^$monitor connected" | tail -n1 | awk '{print $1}')
  resolucoes["$monitor"]="$res"
done

# Posiciona monitores lado a lado
offset_x=0
xrandr_cmd=""
total_width=0

for i in "${!monitores[@]}"; do
  monitor="${monitores[$i]}"
  res="${resolucoes[$monitor]}"
  width=$(echo "$res" | cut -d'x' -f1)

  pos="${offset_x}x0"
  xrandr_cmd+=" --output $monitor --mode $res --pos $pos"
  [ $i -eq 0 ] && xrandr_cmd+=" --primary"

  offset_x=$((offset_x + width))
  total_width=$((total_width + width))
done

# Aplica configuração com xrandr
xrandr $xrandr_cmd

# Detecta touchscreen
touchscreen_id=$(xinput list | grep -i 'touch' | grep -oP 'id=\K\d+')
touchscreen_name=$(xinput list | grep -i 'touch' | awk -F'\t' '{print $1}' | sed 's/^.*↳ //')

if [ -z "$touchscreen_id" ]; then
  echo "Nenhum touchscreen detectado."
  exit 1
fi

# Aplica matriz ao monitor mais à direita
last_monitor="${monitores[-1]}"
last_res="${resolucoes[$last_monitor]}"
last_width=$(echo "$last_res" | cut -d'x' -f1)
last_offset=$(echo "$total_width - $last_width" | bc)

scale_x=$(echo "scale=4; $last_width / $total_width" | bc)
offset_x=$(echo "scale=4; $last_offset / $total_width" | bc)

xinput set-prop "$touchscreen_id" "Coordinate Transformation Matrix" "$scale_x" 0 "$offset_x"  0 1 0  0 0 1

# Log opcional
echo "$(date) - Monitores configurados automaticamente. Touchscreen: $touchscreen_name (ID $touchscreen_id)" >> /tmp/ajuste-monitores.log


