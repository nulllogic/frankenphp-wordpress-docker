#!/usr/bin/env sh
# small entrypoint:
set -e

# hand off to FrankenPHP (Caddy) – pass through any additional args
exec frankenphp run --config /etc/caddy/Caddyfile "$@"