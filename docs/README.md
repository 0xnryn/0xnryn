# docs
command to generate the post quantum password protected age key
```bash
nix run nixpkgs#age -- keygen -pq | nix run nixpkgs#age -- -p -o admin.age
```
command to generate the post quantum age key
```bash
nix run nixpkgs#age -- keygen -pq
```
command to create or edit the secret
```bash
SOPS_AGE_KEY=$(nix run nixpkgs#age -- -d admin.age) \
  nix run nixpkgs#sops -- secrets/$(hostname).yaml
```
command to update keys with modified public keys
```bash
SOPS_AGE_KEY=$(nix run nixpkgs#age -- -d admin.age) \
  nix run nixpkgs#sops -- updatekeys secrets/$(hostname).yaml
```

command to give right permission for the age secret
```bash
sudo chown root:root /etc/$(hostname).txt
sudo chmod 600 /etc/$(hostname).txt
```

command to generate the yggdrasil secret in terminal
```bash
nix run nixpkgs#yggdrasil -- -genconf | nix run nixpkgs#yggdrasil -- -useconf -exportkey
```

command to enroll tpm for decryption of the drive
```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
```

disko command
```bash
nix run github:nix-community/disko/latest -- --mode disko --flake .#0xnryn-laptop0
```
command to print the current storage devices
```bash
find /dev/disk/by-id -type l ! -name '*-part*' ! -name '*_1' ! -name '*eui.*' ! -name '*wwn.*' ! -name 'dm-*' -printf '/dev/disk/by-id/%f\n'
```
command to automate the disko with the storage drives id
```bash
set -euo pipefail

# 1. Inspect all primary physical drives on the system
find /dev/disk/by-id -type l \
  ! -name '*-part*' \
  ! -name '*_1' \
  ! -name '*eui.*' \
  ! -name '*wwn.*' \
  ! -name 'dm-*' \
  -printf '/dev/disk/by-id/%f\n'

# 2. Automatically select the primary target drive
export TARGET_DEVICE=$(find /dev/disk/by-id -type l \
  ! -name '*-part*' \
  ! -name '*_1' \
  ! -name '*eui.*' \
  ! -name '*wwn.*' \
  ! -name 'dm-*' \
  -printf '/dev/disk/by-id/%f\n' | head -n 1)

if [ -z "$TARGET_DEVICE" ]; then
  echo "Error: No primary disk found in /dev/disk/by-id/" >&2
  exit 1
fi

echo "Targeting drive: $TARGET_DEVICE"

# 3. Run Disko directly passing the target device parameter
sudo nix --extra-experimental-features 'nix-command flakes' run \
  github:nix-community/disko -- \
  --mode disko \
  --argstr device "$TARGET_DEVICE" \
  --flake "github:0xnryn/0xnryn#0xnryn-laptop0"
```

nix build .#nixosConfigurations.stfs-mqtt-cloud.config.system.build.tarball

docker import result/tarball/*.tar.xz stfs-mqtt-cloud:latest

docker compose up -d

docker logs stfs-mqtt-cloud

docker exec -it stfs-mqtt-cloud /run/current-system/sw/bin/bash

echo "ey..." | base64 -d

