run:
  #!/bin/bash
  sudo -E capsh --keep=1 --user=$USER --inh=cap_net_admin --addamb=cap_net_admin -- -c 'RUST_BACKTRACE=1 /home/charley/.cargo/bin/cargo run --bin vmm -- --memory 512 --cpus 1 --kernel kernel/linux-cloud-hypervisor/arch/x86/boot/compressed/vmlinux.bin --network-host-ip 172.29.0.1 --network-host-netmask 255.255.0.0'

build-kernel:
  #!/bin/bash
  pushd kernel/linux-cloud-hypervisor && \
    KCFLAGS="-Wa,-mx86-used-note=no" make bzImage -j `nproc`
