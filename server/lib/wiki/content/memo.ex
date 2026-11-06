defmodule Wiki.Content.Memo do
  @moduledoc """
  A cache for read-only lookups (a path's real location, a git query) that lives only inside `run/1`, in the
  calling process. The Stop hook asks the same questions hundreds of times in one run (every page lists sources,
  many pages share them, and each lookup starts an outside program); inside one short run their answers cannot
  differ, so each is asked once. Outside `run/1` nothing is cached, so the long-running server and `wiki publish`
  (which writes between its reads) always see fresh answers.
  """

  @key {__MODULE__, :cache}

  @doc "Runs `fun` with the cache on; the cache is dropped when the outermost `run/1` returns."
  def run(fun) do
    outer? = Process.get(@key) == nil
    if outer?, do: Process.put(@key, %{})

    try do
      fun.()
    after
      if outer?, do: Process.delete(@key)
    end
  end

  @doc "The cached answer for `key`, computing it with `fun` once per `run/1`; just `fun.()` when the cache is off."
  def fetch(key, fun) do
    case Process.get(@key) do
      nil ->
        fun.()

      cache ->
        case Map.fetch(cache, key) do
          {:ok, value} ->
            value

          :error ->
            value = fun.()
            # `fun` may itself have cached answers: add to the current map, not the one read above.
            if current = Process.get(@key), do: Process.put(@key, Map.put(current, key, value))
            value
        end
    end
  end
end
