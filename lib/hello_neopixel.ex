defmodule HelloNeopixel do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    neopixel_cfg = Application.get_env(:hello_neopixel, :channel0)
    wifi_cfg = Application.get_env(:hello_neopixel, :wlan0)

    zeros = List.duplicate({0, 0, 0}, neopixel_cfg[:count])

    children = [
      worker(Nerves.Neopixel, [neopixel_cfg, nil]),
      worker(Task, [fn -> Nerves.Neopixel.render(0, {0, zeros}) end], restart: :temporary, id: Neopixel.AllOff),
      worker(Task, [fn -> Nerves.InterimWiFi.setup(:wlan0, wifi_cfg) end], restart: :transient, id: Init.Wifi)
    ]

    opts = [strategy: :one_for_one, name: HelloNeopixel.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
