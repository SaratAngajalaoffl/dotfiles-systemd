#!/usr/bin/env bash
# Launcher for spotify-soloist.service: systemd's ExecStart can't do command
# substitution, so this pulls the API key out of the keyring and execs
# soloist with it — the key is never written to a file.

set -euo pipefail

api_key=$(secret-tool lookup service spotify-soloist key api-key)
if [[ -z "$api_key" ]]; then
  echo "no Soloist API key in the keyring — run:" >&2
  echo '  secret-tool store --label="Spotify Soloist API key" service spotify-soloist key api-key' >&2
  exit 1
fi

exec soloist --device-name "$(uname -n) (soloist)" --api-key "$api_key" --ws 127.0.0.1:5588
