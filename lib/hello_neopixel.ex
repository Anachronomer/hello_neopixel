defmodule HelloNeopixel do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    neopixel_cfg = Application.get_env(:hello_neopixel, :channel0)

    children = [
      worker(Nerves.Neopixel, [neopixel_cfg, nil]),
    ]

    opts = [strategy: :one_for_one, name: HelloNeopixel.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
