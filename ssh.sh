source "./secret.sh"
mix deps.get && mix firmware
source "./upload.sh" 192.168.0.99 ./_build/rpi3/dev/nerves/images/fw.fw