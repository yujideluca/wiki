defmodule Wiki.Web.RouterTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  alias Wiki.Web.Router

  @opts Router.init([])

  defp call(conn), do: Router.call(conn, @opts)

  defp sign_in(email, extra \\ "") do
    start = call(conn(:get, "/auth/google"))
    cookie = start.resp_cookies["_wiki"].value
    conn(:get, "/auth/google/callback?state=s1&as=#{URI.encode_www_form(email)}#{extra}")
    |> put_req_cookie("_wiki", cookie)
    |> call()
  end

  defp session_cookie(conn), do: get_in(conn.resp_cookies, ["_wiki", :value]) || ""

  defp with_session(conn, cookie), do: put_req_cookie(conn, "_wiki", cookie)

  # REQ AU-1
  test "without a session every page path shows the decoy, never the real app" do
    for path <- ["/", "/p/mem", "/anything", "/index.html"] do
      conn = call(conn(:get, path))
      assert conn.status == 200
      refute conn.resp_body =~ "REAL-APP"
      assert conn.resp_body =~ "Sign in with Google"
    end
  end

  # REQ AU-2
  test "without a session data and assets answer 404" do
    for path <- ["/data/graph.json", "/assets/app.js", "/data/pages/mem.en.json"] do
      conn = call(conn(:get, path))
      assert conn.status == 404
      refute conn.resp_body =~ "secret-real-node"
    end
  end

  # REQ AU-3
  test "Giovanni's verified account gets in and sees the real app and data" do
    conn = sign_in("yujideluca@gmail.com")
    assert conn.status == 302
    assert get_resp_header(conn, "location") == ["/"]
    cookie = session_cookie(conn)

    assert call(conn(:get, "/") |> with_session(cookie)).resp_body =~ "REAL-APP-MARKER"
    assert call(conn(:get, "/data/graph.json") |> with_session(cookie)).resp_body =~ "secret-real-node"
    assert call(conn(:get, "/assets/app.js") |> with_session(cookie)).resp_body =~ "REAL-APP-JS"
  end

  # REQ AU-3
  test "any other account, or an unverified e-mail, is refused" do
    for {email, extra} <- [{"someone@gmail.com", ""}, {"yujideluca@gmail.com", "&verified=no"}] do
      conn = sign_in(email, extra)
      cookie = session_cookie(conn)
      home = call(conn(:get, "/") |> with_session(cookie))
      refute home.resp_body =~ "REAL-APP"
      assert call(conn(:get, "/data/graph.json") |> with_session(cookie)).status == 404
    end
  end

  # REQ AU-3
  test "the allow rule needs the exact e-mail and Google's verification" do
    assert Router.allowed(%{"email" => "YujiDeLuca@gmail.com", "email_verified" => true}) == :ok
    assert {:refused, _} = Router.allowed(%{"email" => "yujideluca@gmail.com.evil.com", "email_verified" => true})
    assert {:refused, _} = Router.allowed(%{"email" => "yujideluca@gmail.com", "email_verified" => "true"})
    assert {:refused, _} = Router.allowed(%{"email" => "yujideluca@gmail.com"})
  end

  # REQ AU-4
  test "a callback without the browser's own sign-in start is refused" do
    conn = call(conn(:get, "/auth/google/callback?state=s1&as=yujideluca%40gmail.com"))
    cookie = session_cookie(conn)
    refute call(conn(:get, "/") |> with_session(cookie)).resp_body =~ "REAL-APP"
  end

  # REQ AU-5
  test "logout ends the session" do
    cookie = session_cookie(sign_in("yujideluca@gmail.com"))
    out = call(conn(:get, "/logout") |> with_session(cookie))
    after_logout = session_cookie(out)
    refute call(conn(:get, "/") |> with_session(after_logout)).resp_body =~ "REAL-APP"
  end

  # REQ AU-6
  test "responses are no-store with security headers, and the decoy cannot make requests" do
    conn = call(conn(:get, "/"))
    assert get_resp_header(conn, "cache-control") == ["no-store"]
    assert get_resp_header(conn, "x-content-type-options") == ["nosniff"]
    [csp] = get_resp_header(conn, "content-security-policy")
    assert csp =~ "default-src 'none'"
    refute csp =~ "connect-src"
    assert call(conn(:post, "/")).status == 405
  end
end
