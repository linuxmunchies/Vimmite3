# Vimmite3 physical test checklist

Record the image digest, machine, firmware version, Secure Boot state, and test
date for every run. Do not promote a build until the blocking checks pass.

## Build artifact gate

- [x] `bluebuild validate recipes/vimmora.yml` passes.
- [x] A clean `bluebuild build --no-sign recipes/vimmora.yml` passes.
- [x] The image uses `ghcr.io/ublue-os/kinoite-main:44` and Fedora's standard
      kernel, not an OGC/Bazzite kernel.
- [x] Firefox is present; Gamescope and NVIDIA-specific packages are absent.
- [x] `kmod-evdi-$(kernel version)`, `displaylink`, and `libevdi` are present.
- [x] EVDI's `vermagic` exactly matches the image kernel.
- [x] Steam, 32/64-bit MangoHud, controller rules, and `lsfg-vk` are present.
- [x] `modprobe -c` reports `options hid_apple fnmode=2`, and the image
      initramfs contains the setting.
Verified locally on 2026-08-25 against image
`sha256:71fedc25c0c0fa5058770aef2575fbca2535688200562bffed17d556b0e24362`.
The artifact uses kernel `7.1.10-200.fc44.x86_64`; EVDI reports the same
`vermagic`. `dnf check` also completed successfully. This records only static
artifact verification, not approval to install or rebase.

## Installation and rollback

- [ ] Install on the explicitly designated test machine without changing the
      current primary host.
- [ ] Installer completes without the previously observed grey screen.
- [ ] First reboot reaches SDDM and Plasma on every connected native display.
- [ ] After the first image update, `rpm-ostree status` retains the prior
      deployment and it can be selected from the boot menu.
- [ ] `rpm-ostree status` reports the expected signed image origin/digest.
- [ ] Btrfs root/home layout and encryption match the chosen installer plan.

## Portable baseline on every machine

- [ ] Wi-Fi, Ethernet, Bluetooth, audio, camera, keyboard, and touchpad work.
- [ ] Suspend/resume succeeds ten consecutive times, including an overnight
      suspend where practical.
- [ ] Firefox and Brave launch; required system Flatpaks reconcile successfully.
- [ ] Zsh/Zim setup preserves pre-existing dotfiles on a rerun.
- [ ] Distrobox can create, enter, update, and remove a disposable test box.
- [ ] No AI MAX TTM/GTT arguments appear on Ryzen 6550U or Intel systems.

## Graphics and gaming

- [ ] `vulkaninfo` identifies the intended AMD or Intel GPU without software
      rendering.
- [ ] Native Steam launches and sees internal/external game libraries.
- [ ] A native Linux game and a Proton game launch.
- [ ] MangoHud works for both a 64-bit game and a 32-bit/Proton title.
- [ ] The EPOMAKER EA75 function row behaves normally with `fnmode=2`.
- [ ] ProtonPlus can install a compatibility tool visible to Steam.
- [ ] Bottles creates and launches a disposable test bottle.
- [ ] Lossless Scaling's Vulkan layer is discoverable and passes one real game
      test. Gamescope is not required for acceptance.

## Controllers

- [ ] The Chicken Run receiver enumerates in its `054c:09cc` PlayStation mode.
- [ ] Steam Input sees buttons, sticks, triggers, touchpad, motion, and rumble.
- [ ] Reconnect the receiver and repeat after resume.
- [ ] If the receiver exposes `3537:0575`, capture `udevadm`, `libinput`, and
      Steam Input results before adding a workaround.
- [ ] Pair and test the primary controller over Bluetooth.
- [ ] Pair and test an Xbox controller over Bluetooth.
- [ ] Test a Steam Controller when hardware becomes available.

## DisplayLink dock on the Ryzen AI MAX host

- [ ] Secure Boot is disabled for the current unsigned EVDI prototype.
- [ ] Enable the DisplayLink profile and verify EVDI loads with no version error.
- [ ] All three monitors work at the expected resolutions and refresh rates.
- [ ] Test cold boot, warm reboot, dock hotplug, logout/login, and display sleep.
- [ ] Suspend/resume succeeds repeatedly with the dock attached.
- [ ] Repeat with IOMMU enabled and confirm XDNA and Wi-Fi initialize normally.

## Audio and microphone

- [ ] HyperX playback and capture appear after receiver reconnect and resume.
- [ ] The microphone starts at 90%.
- [ ] Vesktop cannot lower the source volume during calls or device changes.
- [ ] OBS, browser capture, and normal volume controls still work.

## Virtualization and optional profiles

- [ ] virt-manager connects to `qemu:///system` as the non-root user.
- [ ] Create a UEFI VM, a TPM-backed VM, and a NAT-connected VM.
- [ ] VM shutdown and host suspend/resume do not leave stale libvirt state.
- [ ] Labeled-drive automount mounts `gamedrive` under `/run/media/system` only
      on the opted-in host.
- [ ] Moonlight client streaming works if installed.
- [ ] Sunshine Wayland capture, audio, and remote controller input work if
      installed.
- [ ] SSH and Wake-on-LAN remain disabled until explicitly enabled, then pass a
      same-LAN test and can be disabled again.

## Evidence to collect on failure

Capture `rpm-ostree status`, `journalctl -b`, the previous boot journal when a
resume fails, `inxi -Fz`, `lsusb`, `lspci -nnk`, and the exact command/output for
the failing component. Avoid copying credentials or unrelated user data.
