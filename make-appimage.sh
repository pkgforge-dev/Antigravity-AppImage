#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*${ARCH}.AppImage.zsync"
export ICON=https://aur.archlinux.org/cgit/aur.git/plain/antigravity.png?h=antigravity

export DEPLOY_GTK=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

quick-sharun ./AppDir/bin/* /usr/lib/libnss_nis.so* /usr/lib/libnsl.so* /usr/lib/libnss_mdns*_minimal.so*
quick-sharun --make-appimage
