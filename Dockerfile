FROM ghcr.io/selkies-project/nvidia-egl-desktop@sha256:8ea3b7a846a30057b9e05fbdfe467bae665468000a52251513d61eabce916394

LABEL org.opencontainers.image.title="Fusion 360 Selkies for Unraid" \
      org.opencontainers.image.description="GPU-accelerated Selkies desktop prepared for the community Fusion 360 Linux installer" \
      org.opencontainers.image.source="https://github.com/10bn/unraid-fusion360-selkies" \
      org.opencontainers.image.licenses="MPL-2.0"

USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl yad winbind mokutil policykit-1 samba spacenavd gawk \
      lsb-release wget xdg-utils x11-xserver-utils desktop-file-utils fonts-liberation locales \
    && locale-gen de_DE.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/patch-selkies.py /tmp/patch-selkies.py
RUN python3 /tmp/patch-selkies.py && rm /tmp/patch-selkies.py

COPY scripts/install-fusion360.sh /opt/fusion360/install-fusion360.sh
COPY unraid/install-fusion360.desktop /opt/fusion360/install-fusion360.desktop
COPY scripts/container-init.sh /usr/local/bin/fusion360-container-init
RUN chmod 0755 /opt/fusion360/install-fusion360.sh \
                 /opt/fusion360/install-fusion360.desktop \
                 /usr/local/bin/fusion360-container-init

USER 1000
ENTRYPOINT ["/usr/local/bin/fusion360-container-init"]
