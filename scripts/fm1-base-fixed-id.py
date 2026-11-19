#!/usr/bin/env python3
"""Lets fm1-base keep the package identity fixed: fm1.toml `id_fixed = true` -> the identity is id_prefix itself
(FM-1_023), the same for every build and release; the version stays in the release and the firmware's name.

    python3 scripts/fm1-base-fixed-id.py ~/fm1-base       (CI and scripts/wsl/setup.sh run it; it is idempotent)

fm1-base adds the version to the identity (FM-1_023 + 000003); The Firmware Hub records OpenVALive as FM-1_023.
"""
import pathlib, sys
base = pathlib.Path(sys.argv[1])

def patch(rel, pairs):
    p = base / rel
    s = p.read_text()
    if "id_fixed" in s:
        return
    for old, new in pairs:
        if old not in s:
            sys.exit(f"fm1-base-fixed-id: {rel} has changed; check its identity lines by hand")
        s = s.replace(old, new)
    p.write_text(s)

patch("tools/build.py", [
    ('    PRODUCT = prefix + "00"\n',
     '    PRODUCT = prefix if CONF.get("id_fixed") else prefix + "00"\n'),
    ('        PRODUCT = prefix + "%02d%02d%02d" % (int(m[1]), int(m[2]), int(m[3] or 0))\n',
     '        PRODUCT = prefix if CONF.get("id_fixed") else prefix + "%02d%02d%02d" % (int(m[1]), int(m[2]), int(m[3] or 0))\n')])
# the site wants a release's identity (the prefix + 6 digits): a fixed one is the prefix alone
patch("tools/make_site.py", [
    ('re.escape(conf.get("id_prefix", "FM-1_0")) + r"\\d{6}"',
     're.escape(conf.get("id_prefix", "FM-1_0")) + ("" if conf.get("id_fixed") else r"\\d{6}")')])
print("fm1-base: fixed identity (fm1.toml id_fixed) enabled")
