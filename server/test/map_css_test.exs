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

  # REQ MB-5
  test "the box around the step circles leaves room for the lit circle's growth and glow" do
    [_, rule] = Regex.run(~r/^\.chain\s*\{([^}]*)\}/m, File.read!(@css))
    # `overflow-x: auto` clips vertically too: the lit step grows by 12 % of 34 px and glows 18 px beyond its circle
    [_, top, side] = Regex.run(~r/padding:\s*(\d+)px\s+(\d+)px/, rule)
    assert String.to_integer(top) >= 20, "padding above and below the steps is #{top}px"
    assert String.to_integer(side) >= 20, "padding left and right of the steps is #{side}px"
  end

  # REQ MB-6
  test "on a phone the map's fades and dashes are switched off" do
    css = File.read!(@css)
    [_, phone] = Regex.run(~r/@media \(max-width: 760px\) \{\n  body:has\(\.on-map\)(.*?)\n\}\n@keyframes sheetUp/s, css)
    assert phone =~ ~r/\.edge, \.node, \.node \.dot \{ transition: none; \}/
    assert phone =~ ~r/\.edge\.mentions \{ stroke-dasharray: none;/
  end

  # REQ MB-7
  test "the page is declared not translatable" do
    html = File.read!(Path.expand("../../frontend/static/index.html", __DIR__))
    assert html =~ ~s(translate="no")
    assert html =~ ~s(<meta name="google" content="notranslate">)
  end
end
