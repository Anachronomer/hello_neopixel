# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :hello_neopixel, :channel0,
  pin: 18,
  count: 60

config :hello_neopixel, :channel1,
  pin: 15,
  count: 4

config :hello_neopixel, :wlan0,
  ssid: "placeholder",
  key_mgmt: :"WPA-PSK",
  psk: "placeholder"

config :nerves_interim_wifi,
  regulatory_domain: "US"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

#import_config "#{Mix.Project.config[:target]}.exs"
