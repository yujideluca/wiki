defmodule Wiki.FakeGoogle do
  @moduledoc "Stands in for Assent.Strategy.Google in tests; the callback answers with the user in the `as` param."
  def authorize_url(_config),
    do: {:ok, %{url: "https://accounts.google.com/o/oauth2/auth?fake=1", session_params: %{state: "s1"}}}

  def callback(config, %{"state" => "s1", "as" => email} = params) do
    if config[:session_params] == %{state: "s1"} do
      {:ok, %{user: %{"email" => email, "email_verified" => params["verified"] != "no"}, token: %{}}}
    else
      {:error, :bad_state}
    end
  end

  def callback(_config, _params), do: {:error, :bad_state}
end
