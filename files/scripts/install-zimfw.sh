#!/usr/bin/env bash
set -euo pipefail

readonly ZIMFW_VERSION="1.20.1"
readonly ZIMFW_SHA256="730f7a86f7aac9c87b137e85ecf0ebec19530ab6af065289bcd0d60cb13d8689"
readonly ZIMFW_URL="https://github.com/zimfw/zimfw/releases/download/v${ZIMFW_VERSION}/zimfw.zsh"
readonly ZIMFW_DESTINATION="/usr/share/vimmora/zim/zimfw.zsh"

zimfw_workdir="$(mktemp -d /tmp/vimmora-zimfw.XXXXXX)"
trap 'rm -rf "${zimfw_workdir}"' EXIT

curl --fail --location --retry 3 --output "${zimfw_workdir}/zimfw.zsh" "${ZIMFW_URL}"
printf '%s  %s\n' "${ZIMFW_SHA256}" "${zimfw_workdir}/zimfw.zsh" | sha256sum --check --strict

install -d -m 0755 "$(dirname "${ZIMFW_DESTINATION}")"
install -m 0644 "${zimfw_workdir}/zimfw.zsh" "${ZIMFW_DESTINATION}"

