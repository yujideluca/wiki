[state, name] = System.argv()
System.put_env("WIKI_STATE_DIR", state)
File.write!(Path.join(state, name <> ".ready"), "ready")

Enum.reduce_while(1..10_000, nil, fn _, _ ->
  if File.exists?(Path.join(state, "go")) do
    {:halt, nil}
  else
    Process.sleep(1)
    {:cont, nil}
  end
end)

Enum.each(1..20_000, fn _ -> Wiki.Content.Stale.mark_published() end)
