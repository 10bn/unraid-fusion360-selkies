# Unraid Fusion 360 Selkies

Unofficial Unraid container for running Autodesk Fusion 360 through the community
Wine installer inside a GPU-accelerated Selkies desktop.

The image does **not** contain Autodesk Fusion 360 or Autodesk installation media.
The desktop shortcut downloads a pinned revision of the community installer from
`cryinkfly/Autodesk-Fusion-360-on-Linux`, verifies its SHA-256 checksum, and then
runs it inside the user's persistent home directory.

## Features

- NVIDIA EGL/OpenGL desktop with NVENC H.264 streaming
- Selkies WebRTC browser access
- Persistent Fusion/Wine installation under Unraid appdata
- iPad touch support
- iPad Magic Keyboard, trackpad and mouse support alongside touch
- Automatic LAN address detection for TURN
- Reproducible base image and installer revisions
- No Autodesk binaries, passwords, private IP addresses or GPU UUIDs in the image

## Requirements

- Unraid 7 or newer
- NVIDIA GPU supported by the Unraid NVIDIA Driver plugin
- Docker NVIDIA runtime
- About 2 GiB shared memory
- Persistent appdata storage
- A valid Autodesk account and an appropriate Fusion license

Fusion is not officially supported on Linux. This project is an unsupported
community setup and is not affiliated with Autodesk, Selkies or Unraid.

## Quick start on Unraid

1. Install the NVIDIA Driver plugin and verify that `nvidia-smi` works.
2. Copy `unraid/Fusion360-Selkies.xml` to:

   `/boot/config/plugins/dockerMan/templates-user/my-Fusion360-Selkies.xml`

3. Open **Docker → Add Container**, select `Fusion360-Selkies`, review the
   settings and apply.
4. Open `http://UNRAID-IP:18080`.
5. Double-click **Install Autodesk Fusion 360** on the desktop.
6. Complete the community installer and sign in with your Autodesk account.

The default persistent paths are:

- `/mnt/user/appdata/fusion360/home` → `/home/ubuntu`
- `/mnt/user/appdata/fusion360/data` → `/data`

Do not delete the `home` directory when recreating the container. It contains the
Wine prefix, Fusion installation, Autodesk session and desktop settings.

## Network and security

The template uses host networking because Selkies WebRTC and TURN need multiple
ports:

- `18080/tcp` – browser UI
- `18081/tcp` – Selkies signalling
- `19081/tcp` – metrics
- `3478/tcp+udp` – TURN
- `61000-61100/udp` – TURN relay range

Basic authentication is disabled because Safari on iPadOS may omit HTTP Basic
credentials during the WebSocket upgrade. Do not expose these ports directly to
the public Internet. Use the container only on a trusted LAN or through a VPN
such as Tailscale or WireGuard.

`SELKIES_TURN_HOST=auto` and `TURN_EXTERNAL_IP=auto` select the host's primary
IPv4 address. For remote VPN access, set both variables to the VPN address that
the client can reach.

## Default display profile

The template uses a conservative profile known to work reliably with iPad Safari:

- `1280 × 854`
- `30 FPS`
- `6000 kbit/s`
- dynamic resize disabled
- NVIDIA `nvh264enc`

Increase resolution, frame rate and bitrate after confirming that the stream and
input channel remain stable.

## Local build

```bash
git clone https://github.com/10bn/unraid-fusion360-selkies.git
cd unraid-fusion360-selkies
docker build -t fusion360-selkies:24.04 .
```

For a locally built image, change the Unraid template repository field from the
GHCR image to `fusion360-selkies:24.04`.

## Published image

GitHub Actions builds the repository and publishes:

```text
ghcr.io/10bn/unraid-fusion360-selkies:latest
```

The published image contains only the Linux desktop dependencies, Selkies patch,
installer launcher and container initialization logic. Fusion itself is installed
later into the user's mounted appdata directory.

## Updating the pinned installer

Update both values in `scripts/install-fusion360.sh`:

- `REVISION`
- `EXPECTED_SHA256`

Never update only the URL or disable checksum verification.

## License

Repository code and Selkies-related modifications are licensed under MPL-2.0.
Third-party projects retain their own licenses and trademarks.

Autodesk and Fusion are trademarks of Autodesk, Inc.
