<p align="center"><img src="doc/screenshots/1-base-system.png" alt="AMIX Installer, the first step" width="720"></p>

# linux-amix

Amiga UNIX (AMIX) tools for Linux, as Debian packages: the **AMIX
Installer**, the AMIX **cross compilers** and **sysroot**, the **pvmk** boot
loader and the **kernel driver kits** for graphics and network cards.

They are built from the same pinned sources as the OpenIndiana packages
(publisher `amix`), so a disk or a program made on Linux is the same as one
made on OpenIndiana or Solaris. Each package here is a recipe in
`components/`: a pinned upstream archive with its sha256, patches, and the
build steps.

## The AMIX Installer

A GNOME app that makes an AMIX disk for one machine from **your own** AMIX
2.1c core system (a core HDF, a tape image with its root floppy, or a
running AMIX). It never ships Commodore's files: it adds the open kernel,
drivers, desktop and tools that fit the machine.

- Machines: Amiga 3000, Amiga 2500, Amiga 4000 (with a 68040 or 68060
  card), FS-UAE; CPU cards up to the 68060 (Z3660, Mercury, A3640, A2630).
- Graphics: Z3660 RTG, Picasso II, MNT ZZ9000, MNT VA2000, or the chipset.
- Network: A2065, Z3660 Ethernet, Hydra Systems AmigaNet, Individual
  Computers X-Surf 100, the ZZ9000's Ethernet port.
- Several cards in one machine: a main display (console and X) and the card
  the install runs over, plus any further graphics and network cards.
- The drivers for the cards you choose are linked into **your own** stock
  kernel on this computer, before anything is written; the stock kernel
  stays on the disk as a fallback.
- Writes HDF files, a pvmk boot disk and an FS-UAE configuration, or straight
  onto the SD card of a ZuluSCSI, BlueSCSI or Z3660: it reads the card's
  configuration (`zuluscsi.ini`, `bluescsi.ini`, `z3660cfg.txt`), stops if an
  ID the AMIX disks need is taken, and adds their entries. Then it installs
  the packages over the network.
- Files that exist in the output folder are overwritten (a file it did not
  write only after you confirm it) or kept as `.bak`; the old files are
  replaced only when every new one is written and checked.
- **Serve Packages** serves an AMIX package repository to the Amiga over the
  network (`pkg refresh`, `pkg update` on AMIX), with the line to configure
  the Amiga's publisher.
- **Build Packages** (new in 0.8): builds AMIX packages on this computer from
  [amix-userland](https://github.com/isoriano1968/amix-userland), the master
  repository. The checkout is updated (`git pull`) when the installer starts,
  on Refresh, and when an Amiga runs `pkg refresh`; the components that are
  new or newer than the repository are listed and built with `amix-gcc-14`
  (`amix-gcc-27` for the components that need it), through the same checks
  as every published package, into your own repository, which Serve Packages
  then serves. Host programs (the installer itself, the compilers, pvmk) are
  not built there: they come as packages, like this one.
- **Updates** (new in 0.9): at start and once a day the installer looks for
  a newer linux-amix release in the background (silent offline). Update
  downloads the new `amix-installer` `.deb` from the release, checks it
  against the release's `SHA256SUMS` (any mismatch: nothing is installed),
  installs it with `pkexec apt-get install` and offers a restart. **Check
  for Updates** in the main menu turns it off.

<p align="center">
<img src="doc/screenshots/2-machine-dark.png" alt="Machine" width="400">
<img src="doc/screenshots/5-drivers.png" alt="Drivers" width="400">
<img src="doc/screenshots/4-kernel.png" alt="Kernel" width="400">
<img src="doc/screenshots/8-summary-dark.png" alt="Summary" width="400">
</p>

## Packages

| Package | What it is | Where |
|---|---|---|
| `amix-installer` | the AMIX Installer (GTK 4, libadwaita) | `/usr` |
| `amix-sysroot` | AMIX 2.1c headers and libraries, patch level 2a ([amigaux/amix-system](https://github.com/amigaux/amix-system), published with Amiga Corporation's approval) | `/opt/m68k-amix-sysroot` |
| `amix-gcc-27` | gcc 2.7.2.3 + binutils 2.8.1 for `m68k-cbm-sysv4`: the compiler AMIX itself is built with; kernel and drivers | `/opt/amix-cross` |
| `amix-gcc-14` | gcc 14.2.0 (C, C++) + binutils 2.43.1 for `m68k-elf` with AMIX specs: applications | `/opt/m68k-amix` |
| `amix-amixc99` | libamixc99: the C99/POSIX functions AMIX's libc lacks | sysroot |
| `amix-pvmk` | pvmk boot block and microkernel, `mkadf`, `mkhdf` | `/usr/share/pvmk`, `/usr/lib/pvmk` |
| `amix-kernel-kit-tools` | the driver chains, relocation check and root stamp of every kernel relink; `amix-kernel-040`, which makes our 68040/060 kernel from your stock one | `/usr/share/amix-installer/kit-tools`, `kernel-040` |
| `amix-rtgfb-kit` | Picasso II driver kits, both kernel lines (`/dev/rtgfb`) | `/usr/share/amix-installer/rtgfb*` |
| `amix-zz9000-kit` | MNT ZZ9000 driver kits, both kernel lines (`/dev/zz9000`) | `/usr/share/amix-installer/zz9000*` |
| `amix-z3660rtg-kit` | Z3660 RTG driver kit for the generic 68040/060 kernel (`/dev/z3660rtg`) | `/usr/share/amix-installer/z3660rtg-040` |
| `amix-hydra-kit` | HydraNet Ethernet driver kits, both kernel lines (`/dev/hya0`) | `/usr/share/amix-installer/hydra*` |
| `amix-va2000-kit` | MNT VA2000 driver kits, stock and 68040/060 kernels (`/dev/va2000`) | `/usr/share/amix-installer/va2000*` |
| `amix-xsurf100-kit` | X-Surf 100 Ethernet driver kits, both kernel lines (`/dev/xsf0`) | `/usr/share/amix-installer/xsurf100*` |
| `amix-zz9000eth-kit` | ZZ9000 Ethernet driver kits, both kernel lines (`/dev/zz0`) | `/usr/share/amix-installer/zz9000eth*` |
| `amix-z3660eth-kit` | Z3660 Ethernet driver kit for the 68040/060 kernels (`/dev/zen0`) | `/usr/share/amix-installer/z3660eth-040` |
| `amix-z3660scsi-kit` | the Z3660's SD card as a SCSI controller, for the 68040/060 kernels | `/usr/share/amix-installer/z3660scsi-040` |
| `amix-buddha-kit` | the Buddha and Catweasel Z-II IDE (polled), for the 68030 and 68040/060 kernels | `/usr/share/amix-installer/buddha`, `buddha-040` |
| `amix-a4091-kit` | the A4091, A4092 and A4770 SCSI (polled), for the 68030 and 68040/060 kernels | `/usr/share/amix-installer/a4091`, `a4091-040` |
| `amix-cross-dev` | everything for cross development (metapackage) | |

**ZZ9000 and Z3660 graphics.** The ZZ9000 driver also drives the RTG
graphics of the Z3660 accelerator. On 68040/060 machines it is built into the
Z3660 variant of the port kernel (`amix-kernel-040 --variant z3660`); for the
generic variant, `amix-z3660rtg-kit` has it as its own driver, `/dev/z3660rtg`. The Z3660's HDMI output is
RGB565 only: it offers 8-, 15- and 16-bit modes, but **no 24/32-bit modes**
(those are a ZZ9000 feature). X therefore runs the Z3660 at 16 bpp.

`amix-installer` recommends the pvmk, gcc-27 and kit packages, so a plain
`apt install amix-installer` brings everything it needs to make kernels and
boot disks.

## Download

The packages of each release are on the
[releases page](https://github.com/isoriano1968/linux-amix/releases); the
current one is
[v0.9.2](https://github.com/isoriano1968/linux-amix/releases/tag/v0.9.2)
(AMIX Installer 0.9.2). Download the `.deb` files and `SHA256SUMS` into one
folder, then:

```sh
sha256sum -c SHA256SUMS                  # every file: OK
sudo apt install ./amix-*.deb            # all of them, dependencies from Debian
```

Or only what you need, for example `sudo apt install ./amix-installer_*.deb
./amix-pvmk_*.deb ./amix-gcc-27_*.deb ./amix-sysroot_*.deb ./amix-*-kit_*.deb`.

## Install

The packages are built and tested on Debian 13 (trixie), x86-64. The
compilers and pvmk link against Debian 13's C library; for another
distribution, build them in its own image (`docker/Dockerfile`). With the
packages in a folder (built with `make docker`, see below):

```sh
make repo                      # an apt repository in out/repo
echo "deb [trusted=yes] file:$PWD/out/repo ./" | sudo tee /etc/apt/sources.list.d/linux-amix.list
sudo apt update
sudo apt install amix-installer          # the installer and what it needs
sudo apt install amix-cross-dev          # the cross development system
```

The repository is not signed yet, hence `[trusted=yes]`.

Then start **AMIX Installer** from your desktop's applications, or
`amix-installer` in a terminal. [doc/HOWTO.md](doc/HOWTO.md) walks through a
whole installation and through cross compiling.

## Build

Everything builds in a Debian 13 container, as root inside it (the
compilers install into `/opt` as the later packages need them); only the
`.deb` files come out. You need Docker, a network connection for the
pinned downloads, and some GB of free disk for the compiler builds.

```sh
make docker           # all packages, in order, into out/debs
make repo             # the apt repository in out/repo
make test-install     # install from it into a clean container and smoke-test
                      # (AMIX_TEST_KERNEL=unix: relinks it with every kit;
                      #  AMIX_TEST_K040=1: also makes the 68040/060 kernel)
```

One package alone: `sh tools/build-in-docker.sh amix-hydra-kit` (the
packages it needs are taken from `out/debs`).

### Building without Docker

Docker is only a convenience that keeps the build off your system; using the
packages never needs it. On Debian 13 (or a Debian-based system of the same
release) you can build natively. The build runs as root, because each
component is installed with apt before the next one builds (the compilers go
to `/opt`), so do it on a machine or VM where that is acceptable:

```sh
sudo apt install build-essential make m4 bison flex patch file curl \
    ca-certificates xz-utils bzip2 gzip tar autotools-dev dpkg-dev lintian \
    libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev libzstd-dev \
    python3 python3-cairo python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 \
    git pkg-config
sudo make world        # every package in order into out/debs, each installed
                       # on this system before the next one builds
make repo              # the apt repository in out/repo
```

That is the same list as `docker/Dockerfile`. `make -C components/<name> deb`
builds one package (its build dependencies must be installed already).
Afterwards install from `out/repo` as under [Install](#install); the packages
`make world` installed are the same ones. Downloads are kept in
`distfiles/` and checked against the sha256 in each recipe.

## Status

- The installer (0.9.2), the sysroot, both compilers, pvmk and the kits are
  built from the same pinned sources as the OpenIndiana packages; the AMIX
  Installer runs on both.
- `amix-gcc-14` builds for the 68020 ISA tuned for the 68060 by default, so a
  program runs on every AMIX machine, and links the shared `libamixc99.so.1`
  (`amix-amixc99` 2 puts it into the sysroot), the same library AMIX has.
- The installer makes our 68040/060 kernels from your own stock kernel with
  `amix-kernel-040` (amix-kernel-kit-tools), fetching NetBSD 10.1's
  `syssrc.tgz` once (76 MB), with the m68k-elf tools of amix-gcc-14 (Debian's
  m68k-linux-gnu tools give the same kernel, byte for byte).
- Every kit links into a stock AMIX kernel (and the 040 kits into a 68040/060
  port kernel) with every check passing, alone and all together; boot tests
  of the new kernels, in FS-UAE and on the real cards, are still to come.
- Two cards of the same type (two X-Surfs, say) are not supported yet.
- The AMIX package repository the network install serves to AMIX is not a
  package yet: point the installer at one with `--repo DIR` or `AMIX_REPO`.
- The X11, Motif and CDE cross libraries (`amix-cross-dev-desktop` on
  OpenIndiana) are not packaged for Linux yet.

## Related

- [amix-userland](https://github.com/isoriano1968/amix-userland): the AMIX
  Installer, the compilers' AMIX changes, and every AMIX userland package
- [amix-gate](https://github.com/isoriano1968/amix-gate): the kernel side and
  the driver kits
- [pvmk](https://github.com/isoriano1968/pvmk): the boot loader and microkernel

## License

The recipes and tools in this repository are MIT licensed (LICENSE). Each
package carries the license of what it contains in
`/usr/share/doc/<package>/copyright`: GPL for the compilers, Amiga
Corporation's approval for the AMIX sysroot, MIT for the installer, pvmk and
the kits.
