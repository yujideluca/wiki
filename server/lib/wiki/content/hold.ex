defmodule Wiki.Content.Hold do
  @moduledoc """
  A hold tells the Stop hook that a project is in the middle of a milestone: its wiki pages are written when the
  milestone closes, so until then the hook must not demand them (UP-10). One small JSON file per project in
  `<state dir>/holds/<project>.json` holds the reason, the start time and the expiry (12 hours by default), so a
  session that crashes without releasing is recovered by the expiry alone.

  A marker is written to a temporary file and renamed (a reader never sees half of it). A missing, empty, torn or
  otherwise unreadable marker is never honoured: the hook then behaves exactly as if there were no hold, so a broken
  file can only ever cost a reminder, never hide an obligation (UP-11). A hold never moves the publish stamp or
  clears anything: the pages stay pending and are demanded again when the hold is released or expires.
  """
  alias Wiki.Content.Stale

  @default_hours 12
  @max_hours 72

  def default_hours, do: @default_hours
  def max_hours, do: @max_hours

  def dir, do: Path.join(Stale.state_dir(), "holds")
  defp file(project), do: Path.join(dir(), project <> ".json")

  @doc "A project is a repository folder name under the dev root: letters, digits, dot, dash, underscore."
  def valid_project?(project), do: is_binary(project) and Regex.match?(~r/^[A-Za-z0-9][A-Za-z0-9._-]*$/, project)

  @doc """
  Writes (or renews) the hold of `project`. Options: `:started` (unix time, default now), `:hours` (default 12).
  Returns `{:ok, hold}` or `{:error, reason}`.
  """
  def set(project, reason, opts \\ []) do
    started = Keyword.get(opts, :started, System.os_time(:second))
    hours = Keyword.get(opts, :hours, @default_hours)

    cond do
      not valid_project?(project) -> {:error, "not a project name: #{inspect(project)}"}
      not (is_number(hours) and hours > 0) -> {:error, "the hours must be a positive number"}
      true ->
        hold = %{"project" => project, "reason" => reason || "", "started" => started, "expires" => started + round(hours * 3600)}
        tmp = file(project) <> ".tmp#{System.pid()}.#{System.unique_integer([:positive])}"

        with :ok <- File.mkdir_p(dir()),
             :ok <- File.write(tmp, JSON.encode!(hold)),
             :ok <- File.rename(tmp, file(project)) do
          {:ok, hold}
        else
          {:error, why} ->
            File.rm(tmp)
            {:error, "cannot write the hold: #{:file.format_error(why)}"}
        end
    end
  end

  @doc "Removes the hold of `project`: `:ok`, or `:none` when there was none."
  def release(project) do
    if valid_project?(project) do
      case File.rm(file(project)) do
        :ok -> :ok
        {:error, :enoent} -> :none
        {:error, why} -> {:error, "cannot remove the hold: #{:file.format_error(why)}"}
      end
    else
      {:error, "not a project name: #{inspect(project)}"}
    end
  end

  @doc """
  Every marker, as `{:active, hold}`, `{:expired, hold}` or `{:broken, project}`. It never raises: anything that is
  not a whole, plausible marker for its own file name is `:broken`.
  """
  def all(now \\ System.os_time(:second)) do
    case File.ls(dir()) do
      {:ok, names} ->
        for name <- Enum.sort(names), String.ends_with?(name, ".json"), do: read(String.replace_suffix(name, ".json", ""), now)

      _ ->
        []
    end
  end

  defp read(project, now) do
    with true <- valid_project?(project),
         {:ok, raw} <- File.read(file(project)),
         true <- String.valid?(raw),
         {:ok, %{"project" => ^project, "started" => s, "expires" => e} = hold} <- JSON.decode(raw),
         true <- is_integer(s) and is_integer(e) and e > s do
      if e > now, do: {:active, hold}, else: {:expired, hold}
    else
      _ -> {:broken, project}
    end
  end

  @doc "The active holds, as maps."
  def active(now \\ System.os_time(:second)), do: for({:active, h} <- all(now), do: h)

  @doc "The one-line notice about holds that kept `held_count` pending pages out of the demand."
  def notice(holds, held_count) do
    Enum.map_join(holds, "\n", fn h ->
      "Wiki hold: #{h["project"]} (since #{stamp(h["started"])}, until #{stamp(h["expires"])}" <>
        if(h["reason"] in [nil, ""], do: "", else: ": #{h["reason"]}") <>
        "); #{held_count[h["project"]] || 0} page(s) held, demanded again after `wiki release #{h["project"]}` or at the expiry."
    end)
  end

  def stamp(unix), do: unix |> DateTime.from_unix!() |> Calendar.strftime("%Y-%m-%d %H:%M UTC")
end
