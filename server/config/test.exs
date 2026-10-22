import Config

config :wiki,
  secret_key_base: String.duplicate("t", 64),
  google_client_id: "test-client",
  google_client_secret: "test-secret",
  auth_strategy: Wiki.FakeGoogle,
  site_dir: Path.expand("../test/fixtures/site", __DIR__)

config :logger, level: :error
