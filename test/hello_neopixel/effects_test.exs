defmodule HelloNeopixel.EffectsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup do
    {:ok, effects} = HelloNeopixel.Effects.start_link(3, IORenderer)
    {:ok, effects: effects}
  end

  test "solid", %{effects: effects} do
    assert capture_io(fn -> HelloNeopixel.Effects.solid(effects, {0,255,0}, 128) end) == "Rendering [{0,255,0}, {0,255,0}, {0,255,0}] at brightness 128 to channel 0"
  end
end
