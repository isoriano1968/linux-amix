#!/usr/bin/env python3
"""mkdeb.py -- a Debian binary package from a staged tree, with dpkg-deb.

    mkdeb.py --proto DIR --out DIR --name N --version V [--revision R]
             [--arch all|any] [--depends D] [--recommends R] [--suggests S]
             [--provides P] [--section S] [--summary TEXT]
             [--description-file F] [--license F] [--homepage URL]
             [--shlibdeps] [--no-strip]

--proto holds the files as they go into / (usr/..., opt/...).  The package
gets a DEP-5 copyright with the component's license, a changelog, md5sums,
an Installed-Size, files 644 and directories 755 (755 for any file with an
execute bit), root ownership.  --arch any is the build machine's dpkg
architecture.  --shlibdeps adds the shared libraries the ELF files in the
tree need (dpkg-shlibdeps) to Depends.  The build machine's own ELF files
(the compilers' programs) are stripped of debug symbols unless --no-strip;
AMIX's m68k objects and libraries are left as they are.

Writes OUT/NAME_VERSION-REVISION_ARCH.deb and prints its path.
"""
import argparse
import gzip
import hashlib
import io
import os
import shutil
import stat
import subprocess
import sys
import tempfile
import time

MAINTAINER = "isoriano1968 <81116077+isoriano1968@users.noreply.github.com>"
SOURCE = "https://github.com/isoriano1968/linux-amix"


def run(cmd, **kw):
    return subprocess.run(cmd, check=True, stdout=subprocess.PIPE, universal_newlines=True,
                          **kw).stdout


def fix_modes(root):
    for d, dirs, files in os.walk(root):
        os.chmod(d, 0o755)
        for f in files:
            p = os.path.join(d, f)
            if os.path.islink(p):
                continue
            m = os.stat(p).st_mode
            os.chmod(p, 0o755 if m & 0o111 else 0o644)


def elf_files(root):
    out = []
    for d, _, files in os.walk(root):
        for f in files:
            p = os.path.join(d, f)
            if os.path.islink(p) or not os.path.isfile(p):
                continue
            with open(p, "rb") as fh:
                head = fh.read(20)
            # host ELF only: e_machine of the build machine (x86-64 62, i386 3,
            # aarch64 183); AMIX's m68k objects (4) are data to the host
            if head[:4] == b"\x7fELF" and head[5] == 1 and head[18] in (62, 3, 183):
                out.append(p)
    return out


def shlibdeps(root):
    elves = elf_files(root)
    if not elves:
        return ""
    tmp = tempfile.mkdtemp()
    try:
        os.makedirs(os.path.join(tmp, "debian"))
        with open(os.path.join(tmp, "debian", "control"), "w") as f:
            f.write("Source: x\n\nPackage: x\nArchitecture: any\n")
        out = run(["dpkg-shlibdeps", "-O", "--ignore-missing-info", "-l" + root + "/usr/lib"] +
                  ["-e" + e for e in elves], cwd=tmp, stderr=subprocess.DEVNULL)
    finally:
        shutil.rmtree(tmp)
    for line in out.splitlines():
        if line.startswith("shlibs:Depends="):
            return line.split("=", 1)[1]
    return ""


def copyright_text(name, license_file):
    lines = ["Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/",
             "Upstream-Name: %s" % name, "Source: %s" % SOURCE, "", "Files: *"]
    with open(license_file) as f:
        text = f.read().rstrip("\n").splitlines()
    lines.append("Copyright: see below")
    lines.append("License: %s" % name)
    for t in text:
        lines.append(" " + t if t.strip() else " .")
    return "\n".join(lines) + "\n"


def main():
    ap = argparse.ArgumentParser()
    for a in ("proto", "out", "name", "version", "summary"):
        ap.add_argument("--" + a, required=True)
    ap.add_argument("--revision", default="1")
    ap.add_argument("--arch", default="all")
    for a in ("depends", "recommends", "suggests", "provides", "conflicts", "replaces"):
        ap.add_argument("--" + a, default="")
    ap.add_argument("--section", default="otherosfs")
    ap.add_argument("--description-file")
    ap.add_argument("--license", required=True)
    ap.add_argument("--homepage", default=SOURCE)
    ap.add_argument("--shlibdeps", action="store_true")
    ap.add_argument("--no-strip", action="store_true")
    o = ap.parse_args()

    arch = run(["dpkg", "--print-architecture"]).strip() if o.arch == "any" else o.arch
    full = "%s-%s" % (o.version, o.revision)
    tmp = tempfile.mkdtemp(prefix="mkdeb-")
    try:
        root = os.path.join(tmp, "root")
        shutil.copytree(o.proto, root, symlinks=True)
        doc = os.path.join(root, "usr", "share", "doc", o.name)
        os.makedirs(doc, exist_ok=True)
        with open(os.path.join(doc, "copyright"), "w") as f:
            f.write(copyright_text(o.name, o.license))
        when = time.strftime("%a, %d %b %Y %H:%M:%S +0000",
                             time.gmtime(int(os.environ.get("SOURCE_DATE_EPOCH", time.time()))))
        log = ("%s (%s) unstable; urgency=medium\n\n  * %s %s, built by linux-amix:\n    %s\n\n"
               " -- %s  %s\n" % (o.name, full, o.name, o.version, SOURCE, MAINTAINER, when))
        buf = io.BytesIO()
        with gzip.GzipFile(fileobj=buf, mode="wb", compresslevel=9, mtime=0) as g:
            g.write(log.encode())
        with open(os.path.join(doc, "changelog.Debian.gz"), "wb") as f:
            f.write(buf.getvalue())
        fix_modes(root)
        if not o.no_strip:
            for e in elf_files(root):
                subprocess.run(["strip", "--strip-unneeded", "--remove-section=.comment",
                                e], check=True)

        depends = [d for d in (o.depends, shlibdeps(root) if o.shlibdeps else "") if d]
        size = 0
        sums = []
        for d, _, files in os.walk(root):
            for fn in sorted(files):
                p = os.path.join(d, fn)
                st = os.lstat(p)
                size += (st.st_size + 1023) // 1024 if stat.S_ISREG(st.st_mode) else 1
                if stat.S_ISREG(st.st_mode):
                    with open(p, "rb") as fh:
                        sums.append("%s  %s" % (hashlib.md5(fh.read()).hexdigest(),
                                                os.path.relpath(p, root)))
        desc = ""
        if o.description_file:
            with open(o.description_file) as f:
                body = [line.rstrip() for line in f.read().strip("\n").splitlines()]
            desc = "".join("\n " + (b if b else ".") for b in body)
        ctl = ["Package: %s" % o.name, "Version: %s" % full, "Architecture: %s" % arch,
               "Maintainer: %s" % MAINTAINER, "Installed-Size: %d" % size]
        for k, v in (("Depends", ", ".join(depends)), ("Recommends", o.recommends),
                     ("Suggests", o.suggests), ("Provides", o.provides),
                     ("Conflicts", o.conflicts), ("Replaces", o.replaces)):
            if v:
                ctl.append("%s: %s" % (k, v))
        ctl += ["Section: %s" % o.section, "Priority: optional", "Homepage: %s" % o.homepage,
                "Description: %s%s" % (o.summary, desc)]
        dd = os.path.join(root, "DEBIAN")
        os.makedirs(dd)
        os.chmod(dd, 0o755)
        with open(os.path.join(dd, "control"), "w") as f:
            f.write("\n".join(ctl) + "\n")
        with open(os.path.join(dd, "md5sums"), "w") as f:
            f.write("\n".join(sorted(sums, key=lambda s: s.split("  ", 1)[1])) + "\n")
        for n in ("control", "md5sums"):
            os.chmod(os.path.join(dd, n), 0o644)
        os.makedirs(o.out, exist_ok=True)
        deb = os.path.join(os.path.abspath(o.out), "%s_%s_%s.deb" % (o.name, full, arch))
        run(["dpkg-deb", "--root-owner-group", "-Zxz", "--build", root, deb])
        print(deb)
    finally:
        shutil.rmtree(tmp)


if __name__ == "__main__":
    sys.exit(main())
