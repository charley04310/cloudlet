run:
  #!/bin/bash
  sudo -E capsh --keep=1 --user=$USER --inh=cap_net_admin --addamb=cap_net_admin -- -c 'RUST_BACKTRACE=1 /home/charley/.cargo/bin/cargo run --bin vmm -- --memory 512 --cpus 1 --file-path /home/charley/polytech/martin/cloudlet/src/cli/config/config.template.yaml --kernel kernel/linux-cloud-hypervisor/arch/x86/boot/compressed/vmlinux.bin --network-host-ip 172.29.0.1 --network-host-netmask 255.255.0.0'

setup-agent:
  #!/bin/bash
  docker run --rm \
    -v cargo-cache:/root/.cargo \
    -v $PWD:/volume \
    -w /volume \
    -t clux/muslrust \
    cargo build --release --package agent
  cp target/x86_64-unknown-linux-musl/release/agent rootfs/alpine-minirootfs/agent

build-kernel:
  #!/bin/bash
  pushd kernel/linux-cloud-hypervisor && \
    KCFLAGS="-Wa,-mx86-used-note=no" make bzImage -j `nproc`

cleanup:
  #!/bin/bash
  ps aux | grep "just run" | awk '{print $2}' | head -n 1 | xargs kill -9

mount:
  sudo mount -t proc /proc rootfs/alpine-minirootfs/proc
  sudo mount -t sysfs /sys rootfs/alpine-minirootfs/sys
  sudo mount --bind /dev rootfs/alpine-minirootfs/dev
  sudo mount --bind /run rootfs/alpine-minirootfs/run

chroot: mount
  sudo chroot rootfs/alpine-minirootfs /bin/sh

unmount:
  sudo umount rootfs/alpine-minirootfs/proc
  sudo umount rootfs/alpine-minirootfs/sys
  sudo umount rootfs/alpine-minirootfs/dev
  sudo umount rootfs/alpine-minirootfs/run
