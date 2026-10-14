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

nix build .#nixosConfigurations.stfs-mqtt-cloud.config.system.build.tarball

docker import result/tarball/*.tar.xz stfs-mqtt-cloud:latest

docker compose up -d

docker logs stfs-mqtt-cloud

docker exec -it stfs-mqtt-cloud /run/current-system/sw/bin/bash

echo "ey..." | base64 -d

