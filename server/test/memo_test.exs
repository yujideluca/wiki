defmodule Wiki.Content.MemoTest do
  use Wiki.ContentCase, async: false
  alias Wiki.Content.{Memo, Sources}

  # REQ UP-8
  test "inside run/1 each question is answered once; outside it nothing is cached" do
    counter = :counters.new(1, [])
    ask = fn -> Memo.fetch(:q, fn -> :counters.add(counter, 1, 1) && :counters.get(counter, 1) end) end

    assert Memo.run(fn -> {ask.(), ask.(), Memo.run(ask)} end) == {1, 1, 1}
    assert ask.() == 2
    assert ask.() == 3
    assert Memo.run(ask) == 4
  end

  # REQ UP-8
  test "the cache ends with run/1 even when the function raises" do
    assert_raise RuntimeError, fn -> Memo.run(fn -> Memo.fetch(:k, fn -> 1 end) && raise "boom" end) end
    assert Memo.fetch(:k, fn -> 2 end) == 2
  end

  # REQ UP-8
  # The earlier code ran `realpath -m` on the expanded path (`..` in the path itself is removed by Path.expand first).
  test "Sources.real gives the same answer as realpath -m did", %{dir: dir} do
    dir = Path.join(dir, "links")
    File.mkdir_p!(Path.join(dir, "a/b"))
    File.write!(Path.join(dir, "a/b/f"), "x")
    File.ln_s!(Path.join(dir, "a/b"), Path.join(dir, "abs"))
    File.ln_s!("a/b", Path.join(dir, "rel"))
    File.ln_s!("../b/f", Path.join(dir, "a/b/up"))
    File.ln_s!("missing/deeper", Path.join(dir, "dangling"))
    File.ln_s!("loop2", Path.join(dir, "loop1"))
    File.ln_s!("loop1", Path.join(dir, "loop2"))
    File.ln_s!("rel", Path.join(dir, "chain"))

    for p <- ["", "a", "a/b/f", "abs", "abs/f", "abs/../b", "rel/f", "rel/..", "a/b/up", "dangling", "dangling/x",
              "loop1", "loop1/x", "chain/f/not-a-dir", "nope/../a//b/./f", "abs/missing/../f"] do
      path = Path.expand(Path.join(dir, p))
      expected = case System.cmd("realpath", ["-m", path], stderr_to_stdout: true) do
        {out, 0} -> String.trim(out)
        _ -> path
      end

      assert Sources.real(path) == expected, p
    end
  end
end
