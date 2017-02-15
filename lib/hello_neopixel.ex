defmodule HelloNeopixel do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    alias HelloNeopixel.Effects

    neopixel_cfg = Application.get_env(:hello_neopixel, :channel0)
    wifi_cfg = Application.get_env(:hello_neopixel, :wlan0)

    children = [
      worker(Nerves.Neopixel, [neopixel_cfg, nil]),
      #worker(Effects, [60]),
      #worker(Task, [fn -> Nerves.InterimWiFi.setup(:wlan0, wifi_cfg) end], restart: :transient, id: Init.Wifi)
    ]

    opts = [strategy: :one_for_one, name: HelloNeopixel.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
