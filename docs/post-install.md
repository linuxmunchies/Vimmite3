# Post-install profiles

The common image does not guess which machine it is running on. Optional or
machine-specific behavior is exposed through `ujust` and remains off until the
user explicitly enables it.

Run `ujust --choose` to browse recipes, or use the commands below directly.

## Common user setup

```bash
ujust setup-zsh
ujust setup-virtualization
```

`setup-zsh` preserves existing `.zshrc` and `.zimrc` files. To also select Zsh
as the login shell, run `ujust setup-zsh true`; every retained deployment must
continue to include `/usr/bin/zsh` for rollback-safe login.

`setup-virtualization` enables libvirt's modular sockets, enables the default
NAT network, and adds the current user to `libvirt`. Log out and back in before
opening virt-manager.

## HP DisplayLink dock

```bash
ujust displaylink status
ujust displaylink enable
```

Enabling DisplayLink takes effect on the next boot. Reboot with the dock
attached, then verify all three displays before testing disconnect/reconnect or
suspend. `ujust displaylink disable` reverses the boot-time service choice.

The EVDI module is currently unsigned. Secure Boot must remain disabled for this
development image.

## Labeled internal drive automount

```bash
ujust automount status
ujust automount enable
```

This opts the machine into Universal Blue's service for labeled, non-removable
Btrfs/ext4 partitions. It mounts eligible drives under `/run/media/system` and
does not alter `/etc/fstab`. It is intended for the Ryzen AI MAX host's
`gamedrive` disk and is disabled by default elsewhere.

## Streaming

```bash
ujust install-streaming moonlight
ujust install-streaming sunshine
# or
ujust install-streaming both
```

These are per-user Flatpaks. Sunshine also runs the upstream-required
`additional-install.sh` host integration; reboot before testing Wayland capture,
audio, mouse, and controller input.

## SSH and Wake-on-LAN

```bash
ujust ssh-server enable
ujust wake-on-lan
ujust wake-on-lan eth0 enable
```

The SSH command enables `sshd` and the firewalld SSH service. Confirm key or
password authentication locally before depending on remote access.

The Wake-on-LAN command lists candidate interfaces when no interface is given.
It verifies magic-packet support and updates the active NetworkManager wired
connection. Firmware settings and power-state support must still be checked on
each machine.

## Ryzen AI MAX+ 395 legacy memory profile

```bash
ujust setup-ai-max status
ujust setup-ai-max apply
```

The apply path refuses to run unless both the Ryzen AI MAX+ 395 CPU and the
GMKtec NucBox EVO-X2 DMI identity match. It removes `iommu=off`, explicitly
enables AMD IOMMU, and restores the former large TTM/GTT values in a new atomic
deployment. The GTT argument is deprecated and is retained only as a temporary
compatibility setting pending real AI workload tests. Use
`ujust setup-ai-max undo` to remove the profile.

Do not use this profile on the Ryzen 6550U or Intel/Arc machines.
