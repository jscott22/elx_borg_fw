source "./demosecret.sh"
echo $NERVES_NETWORK_SSID
mix deps.get && mix firmware && mix firmware.burn
