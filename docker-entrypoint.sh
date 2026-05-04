#!/bin/sh
set -eu

service="${SERVICE:-}"

if [ -z "$service" ]; then
  if [ -n "${LOGIN_SERVICE_URL:-}" ] || [ -n "${PLATFORM_SERVICE_URL:-}" ] || [ -n "${API_SERVICE_URL:-}" ]; then
    service="frontend"
  elif [ -n "${DATABASE_URL:-}" ]; then
    service="core"
  elif [ -n "${CORE_SERVICE_URL:-}" ] && [ -n "${JWT_SECRET:-}" ]; then
    service="platform"
  elif [ -n "${CORE_SERVICE_URL:-}" ]; then
    service="api"
  elif [ -n "${JWT_SECRET:-}" ]; then
    service="login"
  else
    service="api"
  fi
fi

exec "/app/bin/${service}"