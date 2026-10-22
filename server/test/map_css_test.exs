defmodule Wiki.MapCssTest do
  use ExUnit.Case, async: true

  @css Path.expand("../../frontend/static/style.css", __DIR__)

  # Every `transition:` written inside a map rule (.edge, .node and their parts): one duration per listed property.
  defp map_transition_seconds do
    File.read!(@css)
    |> then(&Regex.scan(~r/^\.(?:edge|node)[^{]*\{[^}]*\}/m, &1))
    |> Enum.flat_map(fn [rule] -> Regex.scan(~r/transition:([^;}]*)/, rule) end)
    |> Enum.flat_map(fn [_, value] -> Regex.scan(~r/(\d*\.?\d+)(ms|s)\b/, value) end)
    |> Enum.map(fn [_, n, unit] ->
      {num, _} = Float.parse(if String.starts_with?(n, "."), do: "0" <> n, else: n)
      if unit == "ms", do: num / 1000, else: num
    end)
  end

  # REQ MP-7
  test "every transition on the map is at most 0.08 s, so a hovered node lights up at once" do
    seconds = map_transition_seconds()
    assert seconds != [], "no map transition found: the pattern no longer matches the stylesheet"
    assert Enum.max(seconds) <= 0.08, "slowest map transition is #{Enum.max(seconds)} s"
  end
end
