#!/bin/sh
# OpenVALive FM-1 - every automatic test
#
#   FM1_BASE=~/fm1-base sh tests/run_tests.sh
#     1. OpenVALive CORE's own tests (the va/ submodule: core, Live Core, audio, no-libc)
#     2. the FM-1 DSP builds without a C library (like the JieLi compiler)
#     3. the whole app in the fm1-base simulator (targets/fm1/tests/basic.txt)
#
# Prints one PASS / FAIL / SKIP line per test; exits with 1 if any test fails.
set -u
cd "$(dirname "$0")/.."

CC="${CC:-cc}"
B=build/tests
mkdir -p "$B"
FAILS=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; FAILS=$((FAILS + 1)); }
skip() { echo "SKIP  $1"; }

if [ ! -f va/app/openvalive_app.c ]; then
    echo "va/ is empty: run  sh scripts/va.sh init"
    exit 1
fi

# 1. the core's tests, at the pinned version
if sh va/tests/run_tests.sh >$B/va.log 2>&1; then
    pass "OpenVALive CORE $(git -C va describe --tags --always 2>/dev/null): $(grep -c '^PASS' $B/va.log) tests"
else
    grep -v '^PASS' $B/va.log
    fail "OpenVALive CORE tests"
fi

if [ -n "${FM1_BASE:-}" ] && [ -f "$FM1_BASE/include/fastmath.h" ]; then
    # 2. built like on the device: no C library, fastmath, fixed sample rate
    GINC=$($CC -print-file-name=include)
    STRICT="-std=c99 -O2 -Wall -Wextra -Wno-unused-parameter -Wdouble-promotion -Werror -ffp-contract=off"
    if $CC -ffreestanding -nostdinc -isystem "$GINC" -I"$FM1_BASE/include" $STRICT \
         -c targets/fm1/ols_dsp.c -o $B/fm1_dsp.o; then
        pass "FM-1: DSP builds without a C library (like the JieLi compiler)"
    else
        fail "FM-1: no-libc build"
    fi

    # 3. the whole FM-1 app in the fm1-base simulator
    if python3 "$FM1_BASE/tools/build.py" targets/fm1 --host >$B/fm1_build.log 2>&1; then
        if targets/fm1/build/host/openvalive_host targets/fm1/tests/basic.txt targets/fm1/build/host >$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/avol.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/loopstop.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/menus.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/loopedit.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/capture.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/perform.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/help.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/help_cut.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/help_sel.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && targets/fm1/build/host/openvalive_host targets/fm1/tests/save_a.txt targets/fm1/build/host >>$B/fm1_run.log 2>&1 \
           && ! grep -q FAIL $B/fm1_run.log; then
            pass "FM-1: app in the fm1-base simulator ($(grep -c '^  ok' $B/fm1_run.log) checks)"
        else
            cat $B/fm1_run.log
            fail "FM-1: fm1-base simulator"
        fi
    else
        tail -20 $B/fm1_build.log
        fail "FM-1: simulator build"
    fi
else
    skip "FM-1 tests (set FM1_BASE=path/to/fm1-base)"
fi

echo
if [ $FAILS -eq 0 ]; then
    echo "All tests pass."
else
    echo "$FAILS test(s) failed."
    exit 1
fi
