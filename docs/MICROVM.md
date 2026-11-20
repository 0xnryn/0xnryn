
# `0xnryn-microvm0` Operations Cheatsheet

`0xnryn-microvm0` is a declarative NixOS MicroVM managed by the host's `systemd` (`0xnryn-laptop0` and `0xnryn-server0`)[cite: 2]. It boots directly from the host's read-only `/nix/store` via `virtiofs`[cite: 1, 2] onto an ephemeral `512M` `tmpfs` root[cite: 2], meaning reboots wipe `/` completely clean while taking almost zero disk space[cite: 1, 2].

---

## 1. Connect to the VM

`machinectl` is **not** used[cite: 1]. Connect directly over `AF_VSOCK` (CID `3`)—this works even if TAP networking (`vm-micro0`) is down[cite: 1, 2]:

```bash
ssh root@vsock%3
# or
ssh sudha@vsock%3

```

---

## 2. Start, Stop & Inspect

Managed on the host (`0xnryn-laptop0` or `0xnryn-server0`) via `systemctl`:

```bash
# Check status & see the last few lines of serial boot output
systemctl status microvm@0xnryn-microvm0.service

# Start / Stop / Restart
sudo systemctl start microvm@0xnryn-microvm0.service
sudo systemctl stop microvm@0xnryn-microvm0.service
sudo systemctl restart microvm@0xnryn-microvm0.service

# Enable or disable auto-start on host boot
sudo systemctl enable microvm@0xnryn-microvm0.service
sudo systemctl disable microvm@0xnryn-microvm0.service

# Follow live serial console logs
journalctl -u microvm@0xnryn-microvm0.service -f

```

---

## 3. Update & Apply Config Changes

Because `microvm.vms."0xnryn-microvm0".flake` points to `inputs.self`, updating the host builds the new VM closure automatically:

```bash
# 1. Rebuild the host (builds the new 0xnryn-microvm0 closure)
sudo nixos-rebuild switch --flake .#0xnryn-laptop0   # or .#0xnryn-server0

# 2. Restart the VM to boot into the new generation
sudo systemctl restart microvm@0xnryn-microvm0.service

```

---

## 4. Architecture & Host Requirements

* **Hypervisor & Resources:** `qemu` (`-M microvm`), `1024M` RAM, `1` vCPU, `vsock.cid = 3`.


* **Filesystem Layout:**
* `/` $\rightarrow$ Ephemeral `512M` `tmpfs` (wiped on every restart).


* `/nix/.ro-store` $\rightarrow$ Host `/nix/store` mounted read-only via `virtiofs` (`ro-store`).


* `/etc/microvm` $\rightarrow$ Host `/etc/microvm` mounted read-only via `virtiofs` (`age-key-share`) for `sops-nix` decryption.




* **Network Interface:** TAP device `vm-micro0` (guest MAC `02:00:00:00:01:01`).



### Troubleshooting Checklist

If `microvm@0xnryn-microvm0.service` fails to start, check its two helper units and host directory:

```bash
# 1. Ensure the host age-key share directory exists (even if empty)
sudo mkdir -p /etc/microvm

# 2. Check virtiofsd shares (/nix/store and /etc/microvm)
systemctl status microvm-virtiofsd@0xnryn-microvm0.service

# 3. Check TAP interface creation (vm-micro0)
systemctl status microvm-tap-interfaces@0xnryn-microvm0.service
```

```bash
sudo chown -R microvm:kvm /etc/microvm
sudo chmod 0750 /etc/microvm
sudo chmod 0440 /etc/microvm/0xnryn-microvm0.txt
```
