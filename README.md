# dotfiles-systemd

User-level systemd units and timers — a homelab backup timer, a wallpaper-update timer, and a Spotify Soloist launch service.

Part of the [dotfiles-arch](https://github.com/SaratAngajalaoffl/dotfiles-arch) multi-repo dotfiles system.

## Layout

- `user` → `~/.config/systemd/user` (see `.links`)

## Secrets

Declares a Spotify Soloist API key in `.secrets` — `install.sh` prompts for and stores it via `secret-tool` (gnome-keyring); it's never committed here.

## Setup

See `.setup` for enabling the timers/services after install and the one-time Spotify Soloist pairing step.
