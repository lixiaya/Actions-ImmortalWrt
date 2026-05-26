#!/bin/bash
set -x

STAGING_DIR="$1"
if [ -z "$STAGING_DIR" ]; then
    echo "Usage: $0 <staging_dir_path>"
    exit 1
fi

mkdir -p "$STAGING_DIR/host/bin"

# SED
SED_PATH=$(command -v sed || echo /usr/bin/sed)
echo "SED_PATH=$SED_PATH"
ln -sf "$SED_PATH" "$STAGING_DIR/host/bin/sed"

# NINJA
NINJA_PATH=$(command -v ninja || command -v ninja-build || echo /usr/bin/ninja)
echo "NINJA_PATH=$NINJA_PATH"
ln -sf "$NINJA_PATH" "$STAGING_DIR/host/bin/ninja" 2>/dev/null || true

# AWK, GREP, TAR (optional but helpful)
for cmd in awk grep tar; do
    CMD_PATH=$(command -v $cmd || echo /usr/bin/$cmd)
    ln -sf "$CMD_PATH" "$STAGING_DIR/host/bin/$cmd" 2>/dev/null || true
done

# libdeflate-gzip (used by OpenWrt for decompression)
# Check if system has libdeflate-gzip, otherwise use system gzip as fallback
LIBDEFLATE_PATH=$(command -v libdeflate-gzip || echo "")
if [ -n "$LIBDEFLATE_PATH" ]; then
    ln -sf "$LIBDEFLATE_PATH" "$STAGING_DIR/host/bin/libdeflate-gzip"
else
    # Fallback: use system gzip (OpenWrt can use gzip as libdeflate-gzip)
    GZIP_PATH=$(command -v gzip || echo /usr/bin/gzip)
    ln -sf "$GZIP_PATH" "$STAGING_DIR/host/bin/libdeflate-gzip"
fi
echo "libdeflate-gzip -> $(readlink -f "$STAGING_DIR/host/bin/libdeflate-gzip" 2>/dev/null || echo 'not found')"

# Additional tools that might be needed
for cmd in bzip2 xz zstd; do
    CMD_PATH=$(command -v $cmd || echo /usr/bin/$cmd)
    if [ -x "$CMD_PATH" ]; then
        ln -sf "$CMD_PATH" "$STAGING_DIR/host/bin/$cmd" 2>/dev/null || true
    fi
done

echo "=== host tools check ==="
ls -la "$STAGING_DIR/host/bin/" 2>/dev/null || true
"$STAGING_DIR/host/bin/sed" --version 2>&1 | head -1 || true
"$STAGING_DIR/host/bin/ninja" --version 2>&1 | head -1 || true
"$STAGING_DIR/host/bin/libdeflate-gzip" --version 2>&1 | head -1 || true
