#!/usr/bin/bash

set -euo pipefail

kernel_version="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
kernel_devel="kernel-devel-${kernel_version}"

# Install build inputs separately. Fedora's ostree-specific akmod RPM hook
# expects /var to be read-only, which is not true inside a container build.
dnf install -y "${kernel_devel}" akmods

mv /usr/sbin/akmods /usr/sbin/akmods.vimmora-build
mv /usr/sbin/akmods-ostree-post /usr/sbin/akmods-ostree-post.vimmora-build
ln -s /usr/bin/true /usr/sbin/akmods
ln -s /usr/bin/true /usr/sbin/akmods-ostree-post

dnf install -y akmod-evdi displaylink

rm /usr/sbin/akmods /usr/sbin/akmods-ostree-post
mv /usr/sbin/akmods.vimmora-build /usr/sbin/akmods
mv /usr/sbin/akmods-ostree-post.vimmora-build /usr/sbin/akmods-ostree-post

export CFLAGS="-fno-pie -no-pie"
akmods --force --kernels "${kernel_version}" --akmod evdi

module="/usr/lib/modules/${kernel_version}/extra/evdi/evdi.ko.xz"
modinfo "${module}" >/dev/null

# The completed kmod RPM is independent of the source akmod and toolchain.
dnf remove -y akmod-evdi akmods "${kernel_devel}"
dnf check

rpm -q displaylink "kmod-evdi-${kernel_version}"
rm -rf /var/cache/akmods/evdi
dnf clean all
