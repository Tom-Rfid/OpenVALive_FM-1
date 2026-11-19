#!/usr/bin/env bash
# OpenVALive - builds the FM-1 app: simulator + tests, then the .fwsc firmware
#
#   bash scripts/wsl/build-fm1.sh [--out DIR] [--host-only]
#
#   --out        copies the firmware and the install tools into DIR
#                (e.g. /mnt/c/Users/ME/Desktop/OpenVALive-FM1)
#   --host-only  simulator and tests only (no JieLi toolchain needed)
#
# Uses FM1_BASE (default ~/fm1-base), JIELI_TOOLCHAIN and AC79_SDK (see setup.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT=""
HOST_ONLY=0
while [ $# -gt 0 ]; do
    case "$1" in
        --out) OUT="$2"; shift 2 ;;
        --host-only) HOST_ONLY=1; shift ;;
        -h|--help) sed -n 2,12p "$0"; exit 0 ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
done

for c in "${FM1_BASE:-}" "$HOME/fm1-base" "$HOME/openvalive-work/fm1-base"; do
    if [ -n "$c" ] && [ -f "$c/tools/build.py" ]; then FM1_BASE="$c"; break; fi
done
[ -f "${FM1_BASE:-}/tools/build.py" ] || { echo "fm1-base not found: run scripts/wsl/setup.sh first" >&2; exit 1; }
export FM1_BASE
export JIELI_TOOLCHAIN="${JIELI_TOOLCHAIN:-$HOME/.jieli/toolchain}"
export AC79_SDK="${AC79_SDK:-$HOME/fw-AC79_AIoT_SDK}"
APP="$ROOT/targets/fm1"

echo "==> Tests (PC + fm1-base simulator)"
sh "$ROOT/tests/run_tests.sh"

[ "$HOST_ONLY" = 1 ] && { echo; echo "Simulator and tests OK (--host-only: no firmware)."; exit 0; }

echo
echo "==> Firmware FM-1"
python3 "$FM1_BASE/tools/build.py" "$APP"
FWSC="$(ls "$APP"/build/*.fwsc 2>/dev/null | head -1)"
[ -f "$FWSC" ] || { echo "no .fwsc was produced" >&2; exit 1; }
echo "    $FWSC"

if [ -n "$OUT" ]; then
    mkdir -p "$OUT"
    cp "$FWSC" "$FM1_BASE/tools/fm1_install.py" "$FM1_BASE/tools/fm1ports.py" "$OUT/"
    cp "$ROOT/scripts/windows/flash.ps1" "$ROOT/scripts/windows/FLASH-FM1.bat" "$OUT/"
    echo
    echo "Copied to $OUT:"
    ls -1 "$OUT"
fi
