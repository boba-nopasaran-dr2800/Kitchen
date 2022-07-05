#!/bin/bash

export LANG=C
bindir=$(dirname $(realpath $0))

imagename=FW_DR2800.bin

pushd proj
rm -rf rootfs.es
rm -rf rootfs.es.gz
rm -rf rootfs.dir
rm -rf customer.es
rm -rf customer.dir
umount misc.dir
umount /dev/loop7
losetup -d /dev/loop7
rm -rf misc.es
rm -rf misc.dir

$bindir/dr2800 e ../origin/$imagename rootfs.es customer.es misc.es

echo Ungzip rootfs.es...
mv rootfs.es rootfs.es.gz
gzip -d rootfs.es
echo Uncpio rootfs.es...
mkdir rootfs.dir
pushd rootfs.dir
cpio -id < ../rootfs.es
popd

echo Extract customer...
mkdir customer.dir
unsquashfs -f -d customer.dir customer.es

echo Mount misc...
mkdir misc.dir
losetup /dev/loop7 misc.es
lfs --block_size=131072 --block_cycles=500 --read_size=2048 --prog_size=2048 --cache_size=131072 --block_count=11 --lookahead_size=8 /dev/loop7 misc.dir
popd
