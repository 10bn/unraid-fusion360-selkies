# Security Policy

## Reporting

Do not open a public issue for credentials, private network information or a
security vulnerability. Contact the repository owner privately through GitHub.

## Deployment warning

The default Selkies web endpoint has HTTP Basic authentication disabled for
iPadOS Safari WebSocket compatibility. Use it only on a trusted LAN or through a
VPN. Never forward the web, signalling, metrics, TURN or relay ports directly
from the public Internet.

The image does not include Autodesk software. The runtime desktop launcher
downloads a pinned third-party community installer and verifies its SHA-256
checksum before execution.
