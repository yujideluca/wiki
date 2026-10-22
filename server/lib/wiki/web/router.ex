defmodule Wiki.Web.Router do
  @moduledoc """
  The only door to the wiki. Default deny: without a session holding Giovanni's verified Google e-mail,
  every page answers with the decoy (self-contained, no real data) and every data or asset path answers 404.

      /auth/google            start Google sign-in
      /auth/google/callback   Google sends the user back here
      /logout                 end the session
      /healthz                "ok", for the service check
      /assets/*, /data/*      the Elm app and the wiki data (session required)
      anything else           the Elm app (session) or the decoy (no session)
  """
  use Plug.Router
  require Logger

  @day 24 * 60 * 60

  plug :put_secret_key_base

  plug Plug.Session,
    store: :cookie,
    key: "_wiki",
    signing_salt: "wiki-sign-v1",
    encryption_salt: "wiki-encrypt-v1",
    secure: true,
    http_only: true,
    same_site: "Lax",
    max_age: 30 * @day

  plug :fetch_session
  plug :fetch_query_params
  plug :match
  plug :dispatch

  get "/healthz" do
    conn |> no_store() |> send_resp(200, "ok")
  end

  get "/auth/google" do
    case strategy().authorize_url(auth_config()) do
      {:ok, %{url: url, session_params: params}} ->
        conn |> put_session(:auth_params, params) |> redirect(url)

      {:error, error} ->
        Logger.warning("sign-in could not start: #{inspect(error)}")
        decoy(conn)
    end
  end

  get "/auth/google/callback" do
    params = get_session(conn, :auth_params)
    conn = delete_session(conn, :auth_params)
    config = Keyword.put(auth_config(), :session_params, params)

    with true <- params != nil,
         {:ok, %{user: user}} <- strategy().callback(config, conn.query_params),
         :ok <- allowed(user) do
      conn
      |> configure_session(renew: true)
      |> put_session(:email, user["email"])
      |> redirect("/")
    else
      reason ->
        Logger.warning("sign-in refused: #{inspect(refusal(reason))}")
        conn |> configure_session(drop: true) |> redirect("/")
    end
  end

  get "/logout" do
    conn |> configure_session(drop: true) |> redirect("/")
  end

  match _ do
    cond do
      conn.method not in ["GET", "HEAD"] -> send_resp(conn, 405, "")
      not signed_in?(conn) and data_path?(conn) -> conn |> no_store() |> send_resp(404, "")
      not signed_in?(conn) -> decoy(conn)
      data_path?(conn) -> static(conn)
      true -> app(conn)
    end
  end

  @doc "Exactly one account gets in, and only with an e-mail Google has verified."
  def allowed(%{"email" => email, "email_verified" => true}) when is_binary(email) do
    if String.downcase(email) == String.downcase(cfg(:allowed_email)), do: :ok, else: {:refused, :wrong_account}
  end

  def allowed(_), do: {:refused, :unverified}

  defp refusal({:refused, why}), do: why
  defp refusal(false), do: :no_session_params
  defp refusal({:error, e}), do: e
  defp refusal(other), do: other

  defp signed_in?(conn) do
    email = get_session(conn, :email)
    is_binary(email) and String.downcase(email) == String.downcase(cfg(:allowed_email))
  end

  defp data_path?(conn), do: match?([top | _] when top in ["data", "assets"], conn.path_info)

  defp static(conn) do
    opts = Plug.Static.init(at: "/", from: cfg(:site_dir), only: ~w(data assets), gzip: false)

    case Plug.Static.call(no_store(conn), opts) do
      %{halted: true} = served -> served
      not_found -> send_resp(not_found, 404, "")
    end
  end

  defp app(conn) do
    index = Path.join(cfg(:site_dir), "index.html")

    conn
    |> no_store()
    |> put_resp_header("content-security-policy", app_csp())
    |> put_resp_content_type("text/html")
    |> send_file(200, index)
  end

  defp decoy(conn) do
    conn
    |> no_store()
    |> put_resp_header("content-security-policy", decoy_csp())
    |> put_resp_content_type("text/html")
    |> send_file(200, Application.app_dir(:wiki, "priv/decoy.html"))
  end

  def app_csp,
    do:
      "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; " <>
        "connect-src 'self'; font-src 'self'; frame-ancestors 'none'; base-uri 'none'; form-action 'self'"

  def decoy_csp,
    do:
      "default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; img-src data:; " <>
        "frame-ancestors 'none'; base-uri 'none'; form-action 'none'"

  defp no_store(conn) do
    conn
    |> put_resp_header("cache-control", "no-store")
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("referrer-policy", "no-referrer")
    |> put_resp_header("x-robots-tag", "noindex, nofollow")
    |> put_resp_header("strict-transport-security", "max-age=31536000")
  end

  defp redirect(conn, url) do
    conn |> no_store() |> put_resp_header("location", url) |> send_resp(302, "")
  end

  defp put_secret_key_base(conn, _), do: %{conn | secret_key_base: cfg(:secret_key_base)}

  defp strategy, do: Application.get_env(:wiki, :auth_strategy, Assent.Strategy.Google)

  defp auth_config do
    [
      client_id: cfg(:google_client_id),
      client_secret: cfg(:google_client_secret),
      redirect_uri: String.trim_trailing(cfg(:public_url), "/") <> "/auth/google/callback",
      # Google's certificate is checked against the system trust store (kept current by Ubuntu) and its host name.
      http_adapter: {Assent.HTTPAdapter.Httpc, ssl: [cacerts: :public_key.cacerts_get()]}
    ]
  end

  defp cfg(key), do: Application.fetch_env!(:wiki, key)
end
