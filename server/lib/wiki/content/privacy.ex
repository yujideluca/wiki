defmodule Wiki.Content.Privacy do
  @moduledoc """
  Privacy scan (same boundary as workflow-memory): no keys, tokens or passwords, and no contact data about
  other people. The only e-mail addresses allowed are Giovanni's and Anthropic's no-reply address.
  It is a safety net, not a guarantee: Claude still must not write such data.
  """
  alias Wiki.Content.Page

  @allowed_emails ~w(yujideluca@gmail.com noreply@anthropic.com)
  @patterns [
    {~r/-----BEGIN [A-Z ]*PRIVATE KEY-----/, "a private key"},
    {~r/\bgh[pousr]_[A-Za-z0-9]{20,}/, "a GitHub token"},
    {~r/\bsk-[A-Za-z0-9_-]{20,}/, "an API key"},
    {~r/\bAKIA[0-9A-Z]{16}\b/, "an AWS key"},
    {~r/\bxox[abposr]-[A-Za-z0-9-]{10,}/, "a Slack token"},
    {~r/\bGOCSPX-[A-Za-z0-9_-]{10,}/, "a Google client secret"},
    {~r/\b\d{8,10}:[A-Za-z0-9_-]{30,}\b/, "a Telegram bot token"},
    {~r/(?i)\b(password|passwd|senha|secret|token)\s*[:=]\s*\S{6,}/, "a password or secret value"},
    {~r/\+\d{1,3}[\s.-]?\(?\d{2,3}\)?[\s.-]?\d{4,5}[\s.-]?\d{4}\b/, "a phone number"}
  ]

  def scan(%Page{} = p) do
    text = Enum.map_join(p.sections, "\n", &elem(&1, 1)) <> "\n" <> Enum.map_join(p.header, "\n", &inspect/1)

    found =
      for {re, what} <- @patterns, Regex.match?(re, text), do: "looks like it contains #{what}"

    emails =
      Regex.scan(~r/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/, text)
      |> Enum.map(&hd/1)
      |> Enum.uniq()
      |> Enum.reject(&(String.downcase(&1) in @allowed_emails))
      |> Enum.map(&"contains the e-mail address #{&1} (only Giovanni's is allowed)")

    Enum.map(found ++ emails, &"#{p.file}: privacy: #{&1}")
  end
end
