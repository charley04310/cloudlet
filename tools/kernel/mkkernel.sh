#!/usr/bin/bash

LINUX_REPO=linux-cloud-hypervisor
cd ./tools/kernel/

if [ ! -d $LINUX_REPO ]
then
    git clone --depth 1 "https://github.com/cloud-hypervisor/linux.git" -b "ch-6.2" $LINUX_REPO
fi

cd $LINUX_REPO
cp ../linux-config-x86_64 .config
KCFLAGS="-Wa,-mx86-used-note=no" make bzImage -j `nproc`
