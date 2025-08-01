# Dependências para facilitar manutenção e entendimento.

Agrupado os comandos por função (backup, configuração de repositório, instalação de pacotes APT, instalação via pip, correções) e removido duplicações.

---

## Backup e configuração de repositório APT

```bash
# Backup do sources.list original
mv /etc/apt/sources.list /etc/apt/sources.list.old

# Adiciona repositório principal do Ubuntu Jammy (22.04)
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main universe" | tee /etc/apt/sources.list
```

---

## Atualização e correção de pacotes

```bash
# Atualiza lista de pacotes
sudo apt update

# Corrige dependências quebradas, se houver
sudo apt --fix-broken install
sudo apt-get -f install
```

---

## Instalação de dependências via APT

```bash
# Pacotes essenciais para compilação e desenvolvimento
sudo apt install -y build-essential cmake git pkg-config

# Bibliotecas para suporte à GUI e codecs de vídeo/imagem
sudo apt install -y libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev \
                    libjpeg-dev libpng-dev libtiff-dev libatlas-base-dev gfortran

# OpenCV e Python bindings
sudo apt install -y libopencv-dev python3-opencv python3-numpy

# Python e ferramentas de desenvolvimento
sudo apt install -y python3 python3-pip python3-dev
```

---

## Instalação de dependências via pip

```bash
# Remove versões conflitantes do OpenCV
pip3 uninstall -y opencv-python
pip3 uninstall -y opencv-python-headless

# Instala OpenCV com suporte à GUI
pip3 install opencv-python

# Instala screeninfo (opcional – usado para detectar monitores físicos)
pip3 install screeninfo

# (Opcional) Instala OpenCV sem GUI, se necessário para ambientes headless
# pip3 install opencv-python-headless
```

---

## Informações úteis (pacotes instalados)

```text
python3        3.10.6-1~22.04        Linguagem Python 3 padrão
python3-pip    22.0.2+dfsg-1ubuntu0.4 Instalador de pacotes Python
python3-dev    3.10.6-1~22.04        Cabeçalhos e biblioteca estática para desenvolvimento Python
python3-numpy  1:1.21.5-1ubuntu22.04.1 Biblioteca de arrays rápidos para Python
```

---

