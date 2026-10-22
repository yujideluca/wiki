#!/usr/bin/env bash
# Builds and (re)installs everything the wiki needs on the laptop. Safe to re-run.
#   - the `wiki` command (escript) in ~/.local/bin
#   - the server release and its systemd user unit (wiki.service)
#   - a session secret in ~/.config/wiki/secret.env if there is none yet
# The Google sign-in key (~/.config/wiki/oauth.env) is created by Giovanni; without it the service is not started.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cfg="$HOME/.config/wiki"
mkdir -p "$cfg" "$HOME/.local/bin" "$HOME/.config/systemd/user"
chmod 700 "$cfg"

cd "$root/server"
mix deps.get --only prod >/dev/null
mix escript.build >/dev/null
ln -sf "$root/server/wiki" "$HOME/.local/bin/wiki"
MIX_ENV=prod mix release --overwrite --quiet

if [ ! -s "$cfg/secret.env" ]; then
  umask 077
  printf 'SECRET_KEY_BASE=%s\n' "$(head -c 64 /dev/urandom | base64 -w0)" > "$cfg/secret.env"
fi
chmod 600 "$cfg/secret.env"

WIKI_ROOT="$root" "$HOME/.local/bin/wiki" build

cp "$root/tools/wiki.service" "$HOME/.config/systemd/user/wiki.service"
systemctl --user daemon-reload
if [ -s "$cfg/oauth.env" ] && grep -q '^GOOGLE_CLIENT_ID=.\+' "$cfg/oauth.env" && grep -q '^GOOGLE_CLIENT_SECRET=.\+' "$cfg/oauth.env"; then
  chmod 600 "$cfg/oauth.env"
  systemctl --user enable --now wiki.service
  systemctl --user restart wiki.service
  echo "wiki.service running"
else
  echo "~/.config/wiki/oauth.env is missing or incomplete: wiki.service not started (see docs/SETUP.md)"
fi
