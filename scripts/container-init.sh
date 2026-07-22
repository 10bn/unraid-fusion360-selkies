#!/usr/bin/env bash
set -euo pipefail
export SELKIES_ENABLE_BASIC_AUTH="${SELKIES_ENABLE_BASIC_AUTH:-false}"

mkdir -p "$HOME/Desktop" "$HOME/Downloads/Fusion360-Installer"
if [[ ! -e "$HOME/Desktop/install-fusion360.desktop" ]]; then
  cp /opt/fusion360/install-fusion360.desktop "$HOME/Desktop/install-fusion360.desktop"
  chmod 0755 "$HOME/Desktop/install-fusion360.desktop"
fi
if [[ ! -e "$HOME/install-fusion360.sh" ]]; then
  ln -s /opt/fusion360/install-fusion360.sh "$HOME/install-fusion360.sh"
fi

resolve_host_ip() {
  ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i=="src") {print $(i+1); exit}}'
}
HOST_IP="$(resolve_host_ip || true)"
if [[ -z "${SELKIES_TURN_HOST:-}" || "${SELKIES_TURN_HOST}" == "auto" ]]; then
  export SELKIES_TURN_HOST="${HOST_IP:-127.0.0.1}"
fi
if [[ -z "${TURN_EXTERNAL_IP:-}" || "${TURN_EXTERNAL_IP}" == "auto" ]]; then
  export TURN_EXTERNAL_IP="${HOST_IP:-127.0.0.1}"
fi

exec /usr/bin/supervisord "$@"
