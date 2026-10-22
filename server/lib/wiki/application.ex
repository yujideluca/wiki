defmodule Wiki.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:wiki, :serve, false) do
        [{Bandit, plug: Wiki.Web.Router, ip: {127, 0, 0, 1}, port: Application.fetch_env!(:wiki, :port)}]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: Wiki.Supervisor)
  end
end
