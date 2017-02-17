defmodule HelloNeopixel.Effects do
  @moduledoc """
  Provides a number of effects for a strip of neopixels.
  For now, this assumes you are using channel 0 only.
  Organization on this file needs major halp.
  """

  use GenServer

  alias Nerves.Neopixel

  @channel 0

  def solid(pid, color, brightness) do
    GenServer.cast(pid, {:all, {color, brightness}})
  end

  def blink(pid, color_1, color_2, brightness_1, brightness_2, delay) do
    GenServer.cast(pid, {:blink, {color_1, color_2, brightness_1, brightness_2, delay}})
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def start_link(num_px, renderer \\ Neopixel) do
    GenServer.start_link(__MODULE__, [num_px, renderer], [name: __MODULE__])
  end

  def init([num_px, renderer]) do
    {:ok, %{anim_pid: nil, num_px: num_px, renderer: renderer}}
  end

  def handle_cast({:blink, {color_1, color_2, brightness_1, brightness_2, delay}}, state) do
    if state.anim_pid do
      Process.exit(state.anim_pid, :kill)
    end

    anim_pid = spawn fn -> eternal_blink(state.num_px, color_1, color_2, brightness_1, brightness_2, delay, state.renderer) end
    {:noreply, %{anim_pid: anim_pid, num_px: state.num_px, renderer: state.renderer}}
  end

  def handle_cast({:all, {color, brightness}}, state) do
    if state.anim_pid do
      Process.exit(state.anim_pid, :kill)
    end

    all(state.num_px, color, brightness, state.renderer)
    {:noreply, %{anim_pid: nil, num_px: state.num_px, renderer: state.renderer}}
  end

  def handle_call(:stop, state) do
    Process.exit(state.anim_pid, :kill)
    all(state.num_px, HelloNeopixel.Colors.off(), 0, state.renderer)
    {:ok, %{anim_pid: nil, num_px: state.num_px, renderer: state.renderer}}
  end

  defp all(num_px, color, brightness, renderer) do
    # TODO: guard 0 < brightness < 255 ?
    # and color is a 3-tuple with all three values 0 < value < 255 ?
    values = List.duplicate(color, num_px)
    renderer.render(@channel, {brightness, values})
  end

  defp eternal_blink(num_px, color_1, color_2, brightness_1, brightness_2, delay, renderer) do
    # TODO: Guards?
    all(num_px, color_1, brightness_1, renderer)
    :timer.sleep(delay)
    eternal_blink(num_px, color_2, color_1, brightness_2, brightness_1, delay, renderer)
  end
end
