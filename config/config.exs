# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :bootloader,
  init: [:nerves_runtime, :nerves_network],
  app: Mix.Project.config[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
config :nerves_network,
  regulatory_domain: "US"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "OtrwkSkexbFs8K1dQqb32zAeXHsb7kIhqkDq7RRKVqndKNeTMSS7mtrT/HAGjZy+",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]

config :logger, level: :debug

config :thunder_borg,
  i2c: ElixirALE.I2C,
  children: [
    {ThunderBorg.I2C, []},
    {ThunderBorg, []}
  ]

config :ultra_borg,
  i2c: ElixirALE.I2C,
  children: [
    {UltraBorg.I2C, []},
    {UltraBorg, []}
  ]

import Supervisor.Spec

config :camera,
  camera: Picam,
  size: 425,
  children: [
    worker(Picam.Camera, [])
  ]

config :ui,
  script: '<script src="/js/app.js"></script>'
