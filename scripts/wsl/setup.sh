#!/usr/bin/env bash
# OpenVALive - sets up the whole FM-1 build environment in Ubuntu (WSL or Linux)
#
#   bash scripts/wsl/setup.sh [--project DIR] [--out OUTPUT_DIR] [--host-only]
#
#   --project   the OpenVALive folder (default: the one holding this script;
#               if there is none, clones https://github.com/Tom-Rfid/OpenVALive_FM-1)
#   --out       where to copy the firmware and the install tools (e.g. the Windows desktop)
#   --host-only simulator and tests only (no JieLi toolchain, no SDK)
#
# What it does (each step is skipped when already done):
#   1. Ubuntu packages: git, C compiler, Python 3, Pillow, numpy, curl, xz, unzip, rsync
#   2. fm1-base (+ felucca-bsp) in ~/fm1-base
#   3. the JieLi toolchain in ~/.jieli/toolchain
#   4. the JieLi AC79 SDK (3 of its files are used) in ~/fw-AC79_AIoT_SDK, from Gitee
#   5. JIELI_TOOLCHAIN and AC79_SDK in ~/.bashrc
#   6. a copy of the project in ~/OpenVALive (the Linux file system is much faster than /mnt/c)
#   7. build: simulator + tests, then the firmware (scripts/wsl/build-fm1.sh)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT=""
OUT=""
HOST_ONLY=0
while [ $# -gt 0 ]; do
    case "$1" in
        --project) PROJECT="$2"; shift 2 ;;
        --out) OUT="$2"; shift 2 ;;
        --host-only) HOST_ONLY=1; shift ;;
        -h|--help) sed -n 2,20p "$0"; exit 0 ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
done

REPO_URL="https://github.com/Tom-Rfid/OpenVALive_FM-1"
VA_URL="https://github.com/Tom-Rfid/OpenVALive_CORE"
FM1_BASE_URL="https://github.com/charlesvestal/fm1-base"
SDK_URL="https://gitee.com/Jieli-Tech/fw-AC79_AIoT_SDK.git"
SDK_TAG="AC79NN_SDK_V1.2.1_2023-12-13"
FM1_BASE="${FM1_BASE:-$HOME/fm1-base}"
TOOLCHAIN="${JIELI_TOOLCHAIN:-$HOME/.jieli/toolchain}"
SDK="${AC79_SDK:-$HOME/fw-AC79_AIoT_SDK}"
DEST="${OLS_DIR:-$HOME/OpenVALive}"

step() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
ok()   { printf '    \033[32mOK\033[0m %s\n' "$*"; }

# ---------------------------------------------------------------- 1. paquets
step "1/7 Ubuntu packages"
PKGS="git build-essential python3 python3-pil python3-numpy curl xz-utils unzip rsync"
MISSING=""
for p in $PKGS; do dpkg -s "$p" >/dev/null 2>&1 || MISSING="$MISSING $p"; done
if [ -n "$MISSING" ]; then
    echo "    installing:$MISSING (sudo asks for your Ubuntu password)"
    sudo apt-get update -qq
    # shellcheck disable=SC2086
    sudo apt-get install -y -qq $MISSING
fi
python3 -c 'import sys; assert sys.version_info >= (3, 11), "Python 3.11+ required"'
ok "packages and Python $(python3 -c 'import platform; print(platform.python_version())')"

# ---------------------------------------------------------------- 2. fm1-base
step "2/7 fm1-base (FM-1 platform, MPL-2.0)"
if [ ! -d "$FM1_BASE/.git" ]; then
    git clone --recursive --depth 1 "$FM1_BASE_URL" "$FM1_BASE"
else
    git -C "$FM1_BASE" submodule update --init --depth 1 >/dev/null 2>&1 || true
    python3 "$SCRIPT_DIR/../fm1-base-fixed-id.py" "$FM1_BASE" || true     # identity FM-1_023 (fm1.toml id_fixed)
fi
[ -f "$FM1_BASE/tools/build.py" ] && [ -d "$FM1_BASE/bsp/chip" ] || { echo "incomplete fm1-base in $FM1_BASE" >&2; exit 1; }
ok "$FM1_BASE"

if [ "$HOST_ONLY" = 0 ]; then
    # ------------------------------------------------------------ 3. toolchain
    step "3/7 JieLi toolchain (the FM-1 compiler)"
    if [ ! -x "$TOOLCHAIN/pi32v2/bin/clang" ]; then
        bash "$FM1_BASE/tools/get_toolchain.sh" "$(dirname "$TOOLCHAIN")"
    fi
    [ -x "$TOOLCHAIN/pi32v2/bin/clang" ] || { echo "toolchain not found in $TOOLCHAIN" >&2; exit 1; }
    ok "$TOOLCHAIN"

    # ------------------------------------------------------------ 4. SDK
    step "4/7 JieLi AC79 SDK (from Gitee: JieLi's GitHub repository asks for an account)"
    if [ ! -d "$SDK/.git" ] && [ ! -d "$SDK/cpu" ]; then
        GIT_TERMINAL_PROMPT=0 git clone --depth 1 --branch "$SDK_TAG" "$SDK_URL" "$SDK"
    fi
    ok "$SDK (the 3 files used are checked by SHA-256 at build time)"

    # ------------------------------------------------------------ 5. variables
    step "5/7 Environment variables"
    touch "$HOME/.bashrc"
    grep -q '^export JIELI_TOOLCHAIN=' "$HOME/.bashrc" \
        && sed -i "s|^export JIELI_TOOLCHAIN=.*|export JIELI_TOOLCHAIN=$TOOLCHAIN|" "$HOME/.bashrc" \
        || echo "export JIELI_TOOLCHAIN=$TOOLCHAIN" >> "$HOME/.bashrc"
    grep -q '^export AC79_SDK=' "$HOME/.bashrc" \
        && sed -i "s|^export AC79_SDK=.*|export AC79_SDK=$SDK|" "$HOME/.bashrc" \
        || echo "export AC79_SDK=$SDK" >> "$HOME/.bashrc"
    grep -q '^export FM1_BASE=' "$HOME/.bashrc" || echo "export FM1_BASE=$FM1_BASE" >> "$HOME/.bashrc"
    export JIELI_TOOLCHAIN="$TOOLCHAIN" AC79_SDK="$SDK"
    ok "JIELI_TOOLCHAIN, AC79_SDK, FM1_BASE in ~/.bashrc"
else
    step "3-5/7 toolchain, SDK, variables: skipped (--host-only)"
fi
export FM1_BASE

# ---------------------------------------------------------------- 6. projet
step "6/7 OpenVALive project"
[ -z "$PROJECT" ] && [ -f "$SCRIPT_DIR/../../targets/fm1/fm1.toml" ] && PROJECT="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -n "$PROJECT" ]; then
    [ -f "$PROJECT/targets/fm1/fm1.toml" ] || { echo "$PROJECT has no targets/fm1/fm1.toml" >&2; exit 1; }
    if [ "$(cd "$PROJECT" && pwd)" != "$(mkdir -p "$DEST" && cd "$DEST" && pwd)" ]; then
        rsync -a --delete --exclude build/ --exclude .git/ "$PROJECT/" "$DEST/"
        find "$DEST" -name '*.sh' -exec sed -i 's/\r$//' {} +     # Windows line endings, if any
    fi
elif [ ! -d "$DEST/.git" ]; then
    git clone --depth 1 --recursive --shallow-submodules "$REPO_URL" "$DEST"
fi
# va/: OpenVALive CORE (the synth itself), a git submodule. A GitHub zip leaves it empty.
if [ ! -f "$DEST/va/app/openvalive_app.c" ]; then
    if [ -d "$DEST/.git" ]; then
        git -C "$DEST" submodule update --init --depth 1 va
    else
        rm -rf "$DEST/va"
        git clone --depth 1 --branch dev "$VA_URL" "$DEST/va"
        echo "  va/ fetched from $VA_URL (dev): a zip does not say which version this repository pins"
    fi
fi
ok "$DEST"

# ---------------------------------------------------------------- 7. build
step "7/7 Build"
ARGS=()
[ -n "$OUT" ] && ARGS+=(--out "$OUT")
[ "$HOST_ONLY" = 1 ] && ARGS+=(--host-only)
bash "$DEST/scripts/wsl/build-fm1.sh" "${ARGS[@]+"${ARGS[@]}"}"
