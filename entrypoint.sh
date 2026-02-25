#!/bin/sh
set -eu

: "${OPENCLAW_STATE_DIR:=/data/.openclaw}"
: "${OPENCLAW_WORKSPACE_DIR:=/data/workspace}"
: "${OPENCLAW_CONFIG_PATH:=$OPENCLAW_STATE_DIR/openclaw.json}"

mkdir -p "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

# Create a minimal bootstrap config only if missing
if [ ! -f "$OPENCLAW_CONFIG_PATH" ]; then
  # Use RENDER_EXTERNAL_URL if present, otherwise allow onrender origin pattern later via wizard
  ORIGIN="${RENDER_EXTERNAL_URL:-}"
  if [ -n "$ORIGIN" ]; then
    cat > "$OPENCLAW_CONFIG_PATH" <<EOF
{
  "gateway": {
    "controlUi": {
      "allowedOrigins": ["$ORIGIN"]
    }
  }
}
EOF
  else
    # fallback: allow host-header origin mode (temporary, wizard can replace)
    cat > "$OPENCLAW_CONFIG_PATH" <<EOF
{
  "gateway": {
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  }
}
EOF
  fi
fi

exec "$@"
