#!/usr/bin/env bash
# Launcher for rclone-nextcloud.service: mounts Nextcloud (WebDAV) at ~/cloud.
# The username and app password come from the gnome-keyring (see .secrets),
# so there's no ~/.config/rclone/rclone.conf: the remote is configured through
# RCLONE_WEBDAV_* env vars on the on-the-fly ":webdav:" backend.

set -euo pipefail

NC_URL=https://cloud.smugiwara.com
MOUNT=${1:-$HOME/cloud}

user=$(secret-tool lookup service nextcloud key username || true)
pass=$(secret-tool lookup service nextcloud key app-password || true)
if [[ -z "$user" || -z "$pass" ]]; then
  echo "Nextcloud credentials missing from the keyring. Run:" >&2
  echo '  secret-tool store --label="Nextcloud username" service nextcloud key username' >&2
  echo '  secret-tool store --label="Nextcloud app password" service nextcloud key app-password' >&2
  exit 1
fi

export RCLONE_WEBDAV_URL="$NC_URL/remote.php/dav/files/$user/"
export RCLONE_WEBDAV_VENDOR=nextcloud
export RCLONE_WEBDAV_USER="$user"
# rclone wants the password obscured; read from stdin so it never hits argv.
RCLONE_WEBDAV_PASS=$(printf '%s' "$pass" | rclone obscure -)
export RCLONE_WEBDAV_PASS

mkdir -p "$MOUNT"
exec rclone mount :webdav: "$MOUNT" \
  --vfs-cache-mode full \
  --vfs-cache-max-size 10G \
  --dir-cache-time 5m \
  --poll-interval 0
