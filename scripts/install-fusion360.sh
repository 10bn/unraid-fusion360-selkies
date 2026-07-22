#!/usr/bin/env bash
set -euo pipefail

REVISION='53b02038548f01a6e0a1fa2def0a9b545f1561c1'
EXPECTED_SHA256='1023902381ffc908fda99bb2119f3885cb869e5499f2ae0919afc2c8ed28991b'
URL="https://codeberg.org/cryinkfly/Autodesk-Fusion-360-on-Linux/raw/commit/${REVISION}/files/setup/autodesk_fusion_installer_x86-64.sh"
DEST_DIR="${HOME}/Downloads/Fusion360-Installer"
DEST="${DEST_DIR}/autodesk_fusion_installer_x86-64.sh"

mkdir -p "$DEST_DIR"
curl --fail --location --retry 4 --retry-delay 2 "$URL" --output "$DEST.download"
echo "${EXPECTED_SHA256}  ${DEST}.download" | sha256sum --check --status
mv "$DEST.download" "$DEST"
chmod 0755 "$DEST"
exec "$DEST" --install-fix --default
