defmodule HelloNeopixel.Effects do
  @moduledoc """
  Provides a number of effects for a strip of neopixels.
  For now, this assumes you are using channel 0 only.
  """

  alias Nerves.Neopixel

  @channel 0

  def red do {255, 0, 0} end
  def green do {0, 255, 0} end
  def blue do {0, 0, 255} end
  def off do {0, 0, 0} end
  def white do {255, 255, 255} end

  @doc """
  Turns num_px pixels the given color and brightness.
  """
  def all(num_px, color, brightness) do
    # TODO: guard 0 < brightness < 255 ?
    # and color is a 3-tuple with all three values 0 < value < 255 ?
    values = List.duplicate(color, num_px)
    Neopixel.render(@channel, {brightness, values})
  end

  @doc """
  Switches all pixels between one color/brightness and another with a given delay between each.
  This will run indefinitely, so keep a handle of its pid to kill it.
  TODO: How do I do a termination callback or signal without just ganking the process?
  Or is process ganking the "right way"(tm)?
  """
  def blink(num_px, color_1, color_2, brightness_1, brightness_2, delay) do
    # TODO: Guards?
    all(num_px, color_1, brightness_1)
    :timer.sleep(delay)
    blink(num_px, color_2, color_1, brightness_2, brightness_1, delay)
  end
end
