defmodule Wiki.Content.PrivacyTest do
  use ExUnit.Case, async: true
  alias Wiki.Content.{Page, Privacy}

  # Written by the bug-finding review (docs/TESTES-AUTOMATIZADOS.md): expected results come from the rule
  # (CO-4: keys, tokens, passwords, phone numbers and foreign e-mails are blocked), not from the patterns in the code.
  defp scan(text), do: Privacy.scan(%Page{file: "x.md", header: %{}, sections: [{:what, text}]})

  # REQ CO-4
  test "every documented token format is blocked" do
    secrets = [
      "ghp_" <> String.duplicate("a1B2", 6),
      "github_pat_" <> "11ABCDEFG0" <> String.duplicate("a1B2", 6),
      "glpat-" <> String.duplicate("a1B2", 5),
      "AIza" <> String.duplicate("a1B2c3D4", 5),
      "AKIA" <> "ABCDEFGHIJKLMNOP",
      "sk-" <> String.duplicate("a1B2", 6),
      "xoxb-1234567890-abc",
      "Bearer " <> String.duplicate("a1B2", 6),
      "GOCSPX-" <> "a1B2c3D4e5F6g7",
      "password: hunter2hunter2",
      "-----BEGIN OPENSSH PRIVATE KEY-----"
    ]

    for s <- secrets do
      assert scan("use this: #{s}") != [], "not blocked: #{String.slice(s, 0, 12)}..."
    end
  end

  # REQ CO-4
  test "phone numbers are blocked in international, Brazilian and German shapes" do
    for n <- ["+49 151 23456789", "+55 11 91234-5678", "(11) 91234-5678", "11 91234-5678", "+1 415 555 0132"] do
      assert scan("call #{n} now") != [], "not blocked: #{n}"
    end
  end

  # REQ CO-4
  test "a CPF is blocked" do
    assert scan("CPF 123.456.789-09") != []
  end

  # REQ CO-4
  test "ordinary wiki text is not blocked" do
    for t <- ["Goethe B2 exam in Nov 2026", "version 2.7 (versionCode 18)", "limit 3 000 000 bytes", "port 4180 on 127.0.0.1", "pi is 3.14159", "2026-10-24 and +1 point"] do
      assert scan(t) == [], "false alarm: #{t}"
    end
  end

  # REQ CO-4
  test "only Giovanni's and Anthropic's addresses are allowed" do
    assert scan("mail yujideluca@gmail.com or noreply@anthropic.com") == []
    assert [msg] = scan("write to someone.else@example.org")
    assert msg =~ "someone.else@example.org"
    assert scan("YUJIDELUCA@GMAIL.COM") == [], "case does not matter"
  end
end
