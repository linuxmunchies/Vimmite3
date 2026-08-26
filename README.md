# Vimmite3

[![BlueBuild](https://github.com/linuxmunchies/Vimmite3/actions/workflows/build.yml/badge.svg)](https://github.com/linuxmunchies/Vimmite3/actions/workflows/build.yml)

> Vim's personal Fedora Atomic desktop: KDE, gaming, development, media, and
> workstation tools in one reproducible AMD/Intel image.

Vimmite3 is **my OS**. It is the third generation of the image I use on my own
machines, rebuilt around Fedora Kinoite and BlueBuild so the configuration is
reviewable, repeatable, signed, and much easier to maintain than a pile of
post-install scripts.

It keeps the useful parts of my older Bazzite-based setup while deliberately
avoiding machine-specific hacks in the common image. Hardware-specific behavior
is either disabled by default or exposed as an explicit `ujust` profile.

## Project status

The primary Kinoite image has completed a real fresh-install acceptance pass on
a Lenovo ThinkPad T16 Gen 1 with AMD graphics. Boot, encryption, networking,
audio, camera, Plasma, Flatpaks, Steam, Vulkan, MangoHud, Distrobox, libvirt,
DisplayLink's EVDI module, and atomic updates have all been exercised.

This remains a personal distribution rather than a general-purpose support
project. DisplayLink monitor layouts, controllers, the EPOMAKER keyboard,
HyperX audio, real game workloads, and suspend/resume still need to be checked
on each machine where those features matter.

The published image is
`ghcr.io/linuxmunchies/vimmite3-kinoite:latest`: the portable AMD/Intel Fedora
Kinoite image used by Vimmite3 systems.

## What is in Vimmite3?

### Desktop and base system

- Fedora 44 Kinoite and KDE Plasma on Universal Blue's standard Fedora kernel
- Firefox on the host and Brave from Flathub
- AMD and Intel graphics support; no NVIDIA-specific image content
- LUKS-capable Atomic installation, signed OCI updates, and rollback deployments
- Wi-Fi, Bluetooth, PipeWire, camera, touchpad, and common laptop support
- Vim's standard home workspace created automatically as `~/sync`, `~/dev`,
  and `~/ai`

### Gaming

- Native Steam and `steam-devices`
- 64-bit and 32-bit MangoHud
- GameMode when pulled as Steam's normal weak dependency; Vimmite3 adds no
  GameMode launch options or global performance tuning
- ProtonPlus and Bottles
- Mesa's 32-bit Vulkan drivers for Proton
- Controller rules and upstream PlayStation/Bluetooth kernel support
- Pinned and checksum-verified `lsfg-vk` for Lossless Scaling frame generation

Gamescope, Lutris, and Heroic are not preinstalled. Bazaar can install optional
applications later without expanding the base image.

### Workstation and development tools

- Git, Vim, Neovim, Zsh, Zim, Kitty, Bat, `fd`, `jq`, `lsd`, `tldr`, and Nerd
  Fonts
- Podman, Distrobox, and Podman Compose
- Zed from Flathub
- QEMU/KVM, modular libvirt daemons, UEFI firmware, software TPM support, and
  the virt-manager Flatpak
- Opt-in labeled-drive automounting for workstation/game drives

### Media and applications

- VLC, mpv, yt-dlp, MediaInfo, Mixxx, and FLAC tools
- OBS Studio, Kdenlive, Blender, GIMP, Krita, Gwenview, and SongRec
- OnlyOffice, Obsidian, Signal, Telegram, Vesktop, Feishin, RustDesk,
  SyncThingy, Flatseal, Resources, Coppwr, Gear Lever, and Bazaar

The required application set is installed system-wide from Flathub. A quiet
user-scoped Flathub remote is also created for optional apps.

## Hardware profiles and deliberate defaults

The common image is portable. It does not guess which computer it is running
on or enable special hardware services everywhere.

- **DisplayLink:** userspace and an exact-kernel EVDI module are installed, but
  `displaylink.service` is disabled until explicitly enabled.
- **Ryzen AI MAX:** the legacy large-memory/IOMMU profile only applies after a
  strict CPU and DMI identity check.
- **Internal data drives:** labeled-drive automounting is opt-in.
- **Remote access:** SSH and Wake-on-LAN are opt-in.
- **Streaming:** Moonlight and Sunshine are optional per-user installs.
- **EPOMAKER EA75:** `hid_apple fnmode=2` is built into the image and initramfs.

## Install from an ISO

### Before you start

You need:

- an x86-64 AMD or Intel computer;
- a USB drive that can be erased;
- a backup of anything important on the target computer;
- enough local disk space for the image layers and generated ISO; and
- the BlueBuild CLI plus a working Podman/Docker/Buildah environment.

BlueBuild is already installed inside BlueBuild-built systems. On another
system, follow the [official CLI installation documentation](https://blue-build.org/how-to/local/).

### Recommended: generate from the published image

Clone the repository so the signing key and documentation are available:

```bash
git clone https://github.com/linuxmunchies/Vimmite3.git
cd Vimmite3
mkdir -p iso
```

Generate a Kinoite installer from the latest published primary image:

```bash
sudo bluebuild generate-iso \
  --output-dir ./iso \
  --iso-name Vimmite3.iso \
  image ghcr.io/linuxmunchies/vimmite3-kinoite:latest
```

Generating from the published image avoids rebuilding the OS locally and is
the normal path for an installation USB.

### Fully local: build the recipe and ISO together

To build the image from this checkout before creating the installer:

```bash
sudo bluebuild generate-iso \
  --output-dir ./iso \
  --iso-name Vimmite3-local.iso \
  recipe recipes/vimmora.yml
```

This path takes longer and needs substantially more temporary storage because
it composes the entire image locally first, including the kernel-matched EVDI
module and initramfs.

### Write and boot the installer

Use Fedora Media Writer or another trusted graphical image writer to write the
ISO to the USB drive. Double-check the selected device: writing an image erases
the target drive.

Boot the USB in UEFI mode, complete the Kinoite installer, configure disk
encryption and the initial user, then reboot into Vimmite3. Keep the encryption
passphrase available for every cold boot.

## Rebase an existing Fedora Atomic installation

This is only for an existing Atomic Fedora desktop such as Kinoite or
Silverblue. Do not run these commands on traditional mutable Fedora.

The first rebase uses the unverified transport once so the image can install
Vimmite3's signing policy and public key:

```bash
sudo rpm-ostree rebase \
  ostree-unverified-registry:ghcr.io/linuxmunchies/vimmite3-kinoite:latest
sudo systemctl reboot
```

After booting Vimmite3, move permanently to the signed transport:

```bash
sudo rpm-ostree rebase \
  ostree-image-signed:docker://ghcr.io/linuxmunchies/vimmite3-kinoite:latest
sudo systemctl reboot
```

Confirm the signed origin and keep the previous deployment available:

```bash
rpm-ostree status
```

## First boot

Required system Flatpaks reconcile automatically. A slow or temporarily broken
network is retried with a bounded policy, and a final update pass repairs any
runtime dependency that a large Flatpak transaction briefly considered unused.

Browse every Vimmite3 helper interactively:

```bash
ujust --choose
```

Common setup commands:

| Goal | Command | Notes |
| --- | --- | --- |
| Install Zim safely | `ujust setup-zsh` | Preserves existing `.zshrc` and `.zimrc` |
| Use Zsh as login shell | `ujust setup-zsh true` | Log out and back in afterward |
| Prepare virtualization | `ujust setup-virtualization` | Enables NAT and adds the user to `libvirt` |
| Check DisplayLink | `ujust displaylink status` | Does not enable the service |
| Enable DisplayLink | `ujust displaylink enable` | Reboot with the dock attached |
| Check drive automounting | `ujust automount status` | Safe on every machine |
| Enable labeled drives | `ujust automount enable` | Intended for explicitly opted-in workstation hosts |
| Install streaming | `ujust install-streaming moonlight` | Also accepts `sunshine` or `both` |
| Enable SSH | `ujust ssh-server enable` | Also opens the firewalld service |
| Inspect Wake-on-LAN | `ujust wake-on-lan` | Lists candidate wired interfaces |
| Inspect AI MAX profile | `ujust setup-ai-max status` | Refuses unsupported hardware |

See [the post-install profile guide](docs/post-install.md) for the full behavior
and reversal instructions.

## Lossless Scaling

The Vulkan layer is installed, but frame generation requires the purchased
Windows Lossless Scaling application in the native Steam library. Launch
`lsfg-vk-ui` to point the layer at `Lossless.dll` and create per-game profiles.

The upstream default configuration contains a `vkcube` profile. Before the DLL
exists, bypass LSFG when testing the baseline Vulkan stack:

```bash
DISABLE_LSFG=1 vkcube
```

## DisplayLink and Secure Boot

Universal Blue does not currently publish the EVDI `extra` kmod for the
standard `main` kernel. Vimmite3 builds Negativo17's EVDI akmod against the
exact kernel included in the image and removes the compiler toolchain
afterward.

The resulting EVDI module is kernel-matched but currently unsigned. Secure Boot
must be disabled for EVDI/DisplayLink to load. DisplayLink remains disabled by
default, so systems without the dock do not load the module or run the
proprietary daemon.

## Updating and rolling back

Stage the latest signed image:

```bash
sudo rpm-ostree upgrade
rpm-ostree status
sudo systemctl reboot
```

Atomic updates retain the previous deployment. If a new deployment is bad,
select the previous entry from the boot menu or roll back from the running
system:

```bash
sudo rpm-ostree rollback
sudo systemctl reboot
```

Do not delete the previous deployment until the new image has passed boot,
network, graphics, audio, suspend/resume, and any machine-specific dock tests.

## Build and test locally

### Validate the recipe

```bash
bluebuild validate recipes/vimmora.yml
```

Preview the fully expanded recipe or generated Containerfile when debugging
module ordering:

```bash
bluebuild generate --display-full-recipe recipes/vimmora.yml
bluebuild generate recipes/vimmora.yml --output Containerfile
```

### Build without publishing

```bash
bluebuild build --no-sign recipes/vimmora.yml
```

The local build uses the checkout's modules and scripts, compiles EVDI for the
image kernel, verifies pinned downloads, rebuilds initramfs, and produces a
local OCI image. Use `bluebuild build --help` to select a different build
driver, platform, archive, or temporary directory.

Run the physical acceptance checklist before treating a successful container
build as a release:

```bash
less docs/test-checklist.md
```

## CI, publication, and signing

[`.github/workflows/build.yml`](.github/workflows/build.yml) builds Vimmite3
on every non-documentation push, every pull request, manual dispatch, and the
daily schedule. Successful `main` builds publish to GHCR.

The private Cosign key is stored only in the GitHub Actions secret
`SIGNING_SECRET`. Never commit it. Only [`cosign.pub`](cosign.pub) belongs in
the repository.

Verify the published primary image:

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/linuxmunchies/vimmite3-kinoite:latest
```

Useful workflow commands for maintainers:

```bash
gh workflow run bluebuild --repo linuxmunchies/Vimmite3
gh run list --repo linuxmunchies/Vimmite3 --workflow bluebuild --limit 10
gh run watch --repo linuxmunchies/Vimmite3 <run-id> --exit-status
```

## Repository map

```text
recipes/vimmora.yml              Primary Kinoite recipe
recipes/modules/                 Hardware, packages, gaming, virtualization,
                                 configuration, and Flatpak modules
files/scripts/                   Pinned installers and EVDI build logic
files/vimmora/                   Files copied into the primary image
files/justfiles/vimmora.just     Vimmite3 ujust commands
docs/post-install.md             Optional profile instructions
docs/test-checklist.md           Physical acceptance checklist
docs/architecture-proposal.md    Design and dependency rationale
docs/investigation.md            Original live-system audit
docs/vimmora-migration.md        Vimmora migration inventory
cosign.pub                       Public image-verification key
```

## Design rules

Vimmite3 favors:

- declarative image composition over mutable post-install scripts;
- standard Fedora/Universal Blue mechanisms over one-off workarounds;
- pinned and checksum-verified external artifacts;
- system-wide defaults plus explicit, reversible machine profiles;
- signed publication and rollback-safe upgrades; and
- preserving Vim's workflow without pretending every machine is identical.

That is the point of Vimmite3: **my desktop, my defaults, reproducibly built.**

## Documentation

- [Investigation and decisions](docs/investigation.md)
- [Architecture and dependency rationale](docs/architecture-proposal.md)
- [Vimmora migration inventory](docs/vimmora-migration.md)
- [Post-install profiles](docs/post-install.md)
- [Physical acceptance checklist](docs/test-checklist.md)
- [BlueBuild documentation](https://blue-build.org/)

## License

See [LICENSE](LICENSE).
