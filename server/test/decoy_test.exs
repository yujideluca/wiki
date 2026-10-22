defmodule Wiki.DecoyTest do
  use ExUnit.Case, async: true

  @decoy File.read!(Path.expand("../priv/decoy.html", __DIR__))

  # REQ DC-1
  test "the decoy loads nothing from outside and makes no requests" do
    refute @decoy =~ ~r/<script[^>]+src=/i
    refute @decoy =~ ~r/<link[^>]+stylesheet/i
    refute @decoy =~ ~r/https?:\/\//
    for api <- ~w(fetch\( XMLHttpRequest WebSocket EventSource sendBeacon import\(), do: refute(@decoy =~ api)
    assert @decoy =~ ~s(href="/auth/google")
  end

  # REQ DC-1
  test "the decoy contains nothing from the real content" do
    content = Path.expand("../../content", __DIR__)

    titles =
      if File.dir?(content) do
        for f <- File.ls!(content), String.ends_with?(f, ".md"), not String.contains?(Path.rootname(f), "."),
            [_, t] <- [Regex.run(~r/^title:\s*(.+)$/m, File.read!(Path.join(content, f)))],
            String.length(t) >= 5,
            do: String.trim(t)
      else
        []
      end

    for t <- titles, do: refute(@decoy =~ t, "decoy mentions the page title #{t}")
  end
end
