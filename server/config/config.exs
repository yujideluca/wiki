import Config

config :wiki,
  serve: false,
  port: 4180,
  allowed_email: "yujideluca@gmail.com",
  public_url: "https://yuji-nitro.tailed3a22.ts.net",
  site_dir: Path.expand("../../site", __DIR__)

import_config "#{config_env()}.exs"
