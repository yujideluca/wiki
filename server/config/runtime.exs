import Config

# Secrets come from the environment (systemd EnvironmentFile ~/.config/wiki/*.env), never from git.
if config_env() == :prod do
  env! = fn name ->
    System.get_env(name) || raise "#{name} is not set (see ~/.config/wiki/)"
  end

  config :wiki,
    serve: System.get_env("WIKI_SERVE", "1") == "1",
    port: String.to_integer(System.get_env("WIKI_PORT", "4180")),
    public_url: System.get_env("WIKI_PUBLIC_URL", "https://yuji-nitro.tailed3a22.ts.net"),
    site_dir: env!.("WIKI_SITE_DIR"),
    secret_key_base: env!.("SECRET_KEY_BASE"),
    google_client_id: env!.("GOOGLE_CLIENT_ID"),
    google_client_secret: env!.("GOOGLE_CLIENT_SECRET")
end
