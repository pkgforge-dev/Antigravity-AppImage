#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm patchelf libnss_nis nss-mdns nss

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting binary..."
echo "---------------------------------------------------------------"
case "$ARCH" in
	x86_64)  farch=x64;;
	aarch64) farch=arm;;
esac
BASE_URL="https://antigravity.google"
link=$(curl -sL --compressed "$BASE_URL/$(curl -sL --compressed "$BASE_URL/download" | grep -oP 'main-[A-Z0-9]+\.js' | head -1)" | grep -oP "https://storage\.googleapis\.com[^\"]+linux-${farch}/Antigravity\.tar\.gz" | head -1)

curl -sSfL --retry 30 --retry-connrefused "$link" -o /tmp/temp.tar.gz
echo "$(echo "$link" | grep -oP 'antigravity-hub/\K[0-9]+\.[0-9]+\.[0-9]+')" > ~/version

mkdir -p ./AppDir/bin
curl -sL "https://aur.archlinux.org/cgit/aur.git/plain/antigravity.desktop?h=antigravity" | sed 's|^Exec=/usr/bin/|Exec=|g' > ./AppDir/antigravity.desktop
tar -xvzf /tmp/temp.tar.gz --strip-components=1 -C ./AppDir/bin
