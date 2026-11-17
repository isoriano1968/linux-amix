#!/bin/sh
# smoke-test.sh -- run inside a system with the linux-amix packages installed
set -e
cd /tmp
echo "== the installer finds its tools"
python3 -I - <<'PY'
import sys
sys.path.insert(0, "/usr/lib/amix-installer")
import subprocess
from amix_installer import kernel, plan
assert plan.find_pvmk(), "no pvmk"
for k in sorted(kernel.DRIVERS):
    pkg = "amix-%s-kit" % k
    r = subprocess.run(["dpkg-query", "-W", "-f", "${Status}", pkg], stdout=subprocess.PIPE,
                       stderr=subprocess.DEVNULL, universal_newlines=True)
    if r.stdout != "install ok installed":
        print("kit", k, "not installed (%s)" % pkg)
        continue
    assert kernel.find_kit(k), "%s is installed, but the installer does not find it" % pkg
    print("kit", k, kernel.find_kit(k))
print("ld", kernel.find_ld()); print("as", kernel.find_as())
assert kernel.find_ld() and kernel.find_as()
assert kernel.find_io_init_patch([])
PY
amix-installer --help >/dev/null
echo "== gcc 14 builds an AMIX C++ program"
cat > hello.cc <<'CC'
#include <cstdio>
#include <string>
int main() { std::string s("AMIX"); try { throw s; } catch (std::string &e) { std::printf("%s\n", e.c_str()); } return 0; }
CC
/opt/m68k-amix/bin/m68k-elf-g++ -O2 -o hello hello.cc
/opt/m68k-amix/bin/m68k-elf-readelf -h hello | grep -E "Machine|Type"
echo "== gcc 2.7 builds an AMIX C program"
printf '#include <stdio.h>\nint main() { printf("AMIX\\n"); return 0; }\n' > hello.c
/opt/amix-cross/bin/m68k-cbm-sysv4-gcc -O -o hello27 hello.c
/opt/amix-cross/bin/m68k-cbm-sysv4-objdump -f hello27 | grep -E "format|architecture"
if [ -f /kernel/unix ]; then
	echo "== relink a stock kernel with every kit"
	python3 -I - <<'PY'
import sys, os, tempfile, shutil
sys.path.insert(0, "/usr/lib/amix-installer")
from amix_installer import kernel
base = open("/kernel/unix", "rb").read()
d = tempfile.mkdtemp()
have = [k for k in ("rtgfb", "zz9000", "va2000", "hydra") if kernel.find_kit(k)]
sets = [[k] for k in have] + [[g, "hydra"] for g in have if g != "hydra" and "hydra" in have]
for ids in sets:
    print("+".join(ids), kernel.relink(base, d + "/u", ids, None, kernel.find_ld(), asm=kernel.find_as()))
shutil.rmtree(d)
PY
fi
echo "smoke test: ok"
