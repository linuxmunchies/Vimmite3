# Vimmite3

Vimmite3 is a BlueBuild image for a portable AMD/Intel KDE Atomic workstation.
It is intended to retain the useful gaming and desktop behavior of the previous
Bazzite-based image while using Universal Blue's standard Fedora kernel and a
smaller, explicit feature set.

## Status

The Kinoite-based image is under development and is **not ready for a rebase or
physical installation yet**. The existing `recipes/recipe.yml` Bazzite image is
retained as a fallback while `recipes/vimmora.yml` is built and tested.

The development image currently includes:

- KDE Plasma, Firefox, and Universal Blue's Fedora 44 Kinoite baseline;
- AMD and Intel graphics support only;
- native Steam, MangoHud, ProtonPlus, Bottles, and Lossless Scaling;
- controller rules for Steam Input and upstream PlayStation/Bluetooth drivers;
- a QEMU/libvirt backend and the virt-manager Flatpak;
- DisplayLink userspace plus EVDI compiled for the exact image kernel;
- Zsh/Zim setup, Vim, Neovim, Zed, Nerd Fonts, and the required Flatpaks; and
- opt-in DisplayLink, drive automount, streaming, SSH, Wake-on-LAN, and Ryzen AI
  MAX host profiles.

Gamescope, Nvidia packages/configuration, Lutris, and Heroic are intentionally
not part of this image.

## Build locally

Validate and build the development recipe without signing:

```bash
bluebuild validate recipes/vimmora.yml
bluebuild build --no-sign recipes/vimmora.yml
```

The GitHub workflow builds both recipes during the migration. Image signing is
handled by the existing `SIGNING_SECRET` repository secret.

## Important DisplayLink limitation

Universal Blue currently does not publish its EVDI `extra` kmod for the standard
`main` kernel. Vimmite3 therefore compiles Negativo17's EVDI akmod during the
image build and discards the build toolchain afterward. The resulting module is
kernel-matched but is currently unsigned, so the development image requires
Secure Boot to remain disabled until a deliberate signing/enrollment design is
implemented and tested.

## Documentation

- [Investigation and decisions](docs/investigation.md)
- [Architecture](docs/architecture-proposal.md)
- [Vimmora migration inventory](docs/vimmora-migration.md)
- [Post-install profiles](docs/post-install.md)
- [Physical test checklist](docs/test-checklist.md)

## Image verification

Published images use Sigstore/cosign signing. Verify one with:

```bash
cosign verify --key cosign.pub ghcr.io/linuxmunchies/vimmite3-kinoite
```
