#!/bin/bash
# shellcheck disable=SC2162,SC2316,SC2059,SC2181

#!/bin/bash

# Verifica se o usuário é root (UID 0)
if [ "$EUID" -ne 0 ]; then
  echo "Erro: este script deve ser executado como root." >&2
  exit 1
fi

local="$(pwd)"
PIP_ROOT_USER_ACTION=ignore
PYTHONWARNINGS=ignore

export local
export PIP_ROOT_USER_ACTION
export PYTHONWARNINGS

# Download files
echo "=================================================================="
echo "Configurador do Self Checkout - PERTO CKT-0250 - By Lopes Dev Team"
echo "=================================================================="

# cd /root

#echo "[1] - Baixando arquivos:"
#wget http://10.1.7.218/selfcheckout/selfcheckout_files.zip

# echo "[2] - Instalando pacotes necessarios:"
# sudo apt update
# sudo apt install -y python3 python3-pip python3-opencv libopencv-dev python3-dev
# pip3 install opencv-python screeninfo
# pip3 install opencv-python-headless
# sudo apt update
# sudo apt install -y build-essential cmake git libgtk2.0-dev pkg-config \
#                  libavcodec-dev libavformat-dev libswscale-dev \
#                  libjpeg-dev libpng-dev libtiff-dev \
#                  libatlas-base-dev gfortran \
#                  libopencv-dev python3-opencv python3-numpy

# Lista de pacotes a serem verificados
PACOTES=(
  python3 python3-pip python3-opencv libopencv-dev python3-dev
  build-essential cmake git libgtk2.0-dev pkg-config
  libavcodec-dev libavformat-dev libswscale-dev
  libjpeg-dev libpng-dev libtiff-dev
  libatlas-base-dev gfortran
  python3-numpy
)

# Inicializa a lista de pacotes ausentes
NAO_INSTALADOS=()

echo "Verificando pacotes no sistema..."

for pacote in "${PACOTES[@]}"; do
  dpkg -s "$pacote" &> /dev/null
  if [ $? -ne 0 ]; then
    NAO_INSTALADOS+=("$pacote")
  fi
done

# Se houver pacotes ausentes, exibe e encerra
if [ ${#NAO_INSTALADOS[@]} -gt 0 ]; then
  echo "Os seguintes pacotes NÃO estão instalados:"
  for pacote in "${NAO_INSTALADOS[@]}"; do
    echo "  - $pacote"
  done
  echo "Execute o Script \"pythonCam_dep-u2204-9.sh\" para instalar as dependências!"
  exit 1
else
  echo "Todos os pacotes estão instalados!"
fi

# OpenCV com suporte à GUI

cd /root || exit 1
pip3 uninstall -y opencv-python --quiet 2>/tmp/opencv.log
pip3 uninstall -y opencv-python-headless --quiet 2>/tmp/opencv.log
# pip3 install opencv-python-headless # opcional, se não quiser GUI
pip3 install opencv-python --quiet 2>/tmp/opencv.log # versão com GUI (se compilada corretamente)
pip3 install screeninfo    --quiet 2>/tmp/opencv.log # obter informações sobre os monitores físicos conectados ao sistema

echo "[3] - Extraindo arquivos:"
# cd /root
unzip -o "$local"/selfcheckout_files.zip -d /root
cp -a /root/selfcheckout_files/* /root
cp -a /root/main.py /root/pythonCamIP/main.py

echo "[4] - Movendo PDVTouch.sh:"
cp /Zanthus/Zeus/pdvJava/PDVTouch.sh /Zanthus/Zeus/pdvJava/PDVTouch.sh.backup_"$(date +%Y%m%d%H%M)"
# rm -rf /Zanthus/Zeus/pdvJava/PDVTouch.sh 
# cp /root/PDVTouch.sh /Zanthus/Zeus/pdvJava/PDVTouch.sh
rm /root/PDVTouch.sh

# Adaptação
curl -JLk -o /Zanthus/Zeus/pdvJava/x11vnc.sh "https://raw.githubusercontent.com/elppans/pdv-touch/refs/heads/main/x11vnc.sh"

chmod +x "$local"/pythonCam_sh/*
cp -a "$local"/pythonCam_sh/monitor-pos-set-perto.sh /Zanthus/Zeus/pdvJava/
cp -a "$local"/pythonCam_sh/self_perto_config.sh /Zanthus/Zeus/pdvJava/
mv /usr/local/bin/mainapp /usr/local/bin/mainapp.backup_"$(date +%Y%m%d%H%M)"
cp -a "$local"/pythonCam_sh/mainapp /usr/local/bin/mainapp

echo "[5] - Concedendo permissoes:"
chmod +x /Zanthus/Zeus/pdvJava/PDVTouch.sh
chmod +x /Zanthus/Zeus/pdvJava/x11vnc.sh
chmod +x /Zanthus/Zeus/pdvJava/monitor-pos-set-perto.sh
chmod +x /root/self_perto_config.sh


echo "[6] - Limpando arquivos:"
rm -rf /root/selfcheckout_files.zip

echo "[7] - Config da camera:"
echo "Informe o usuario: "
read camera_username
echo "Informe a senha: "
read camera_password
echo "Informe o IP: "
read camera_ip

echo "[8] - Gerando arquivo de configuracao":
printf "user=$camera_username\npassword=$camera_password\nipCam=$camera_ip\nport=554\nmonitor_idx=1" > /root/pythonCamIP/config.txt


echo "[9] - Finalizado!"
echo -e "Antes de reiniciar, configure as variáveis do monitor primário e secundário nos Scripts
\"/Zanthus/Zeus/pdvJava/monitor-pos-set-perto.sh\" e \"/Zanthus/Zeus/pdvJava/self_perto_config.sh\"\n"
# echo "[9] - Finalizado! reiniciando..."
# sleep 5
# reboot
