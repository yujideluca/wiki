defmodule Wiki.MixProject do
  use Mix.Project

  def project do
    [
      app: :wiki,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: if(Mix.env() == :test, do: ["lib", "test/support"], else: ["lib"]),
      deps: deps(),
      escript: [main_module: Wiki.CLI, name: "wiki", app: nil],
      releases: [wiki: [include_executables_for: [:unix]]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :ssl, :crypto, :public_key],
      mod: {Wiki.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.16"},
      {:bandit, "~> 1.5"},
      {:assent, "~> 0.3"},
      {:ssl_verify_fun, "~> 1.1"}
    ]
  end
end
