#!/bin/bash

export LANG=C
bindir=$(dirname $(realpath $0))

imagename=FW_DR2800.bin

cp origin/${imagename} out/${imagename}

pushd proj
rm rootfs.es.gz
rm rootfs.es
rm customer.es

echo cpio rootfs.es...
pushd rootfs.dir
find ./* | cpio -o -H newc > ../rootfs.es
popd
echo gzip rootfs.es...
gzip -9 rootfs.es
mv rootfs.es.gz rootfs.es

echo Pack customer...
mksquashfs customer.dir customer.es -comp xz

echo Umount misc...
umount misc.dir
umount /dev/loop7
losetup -d /dev/loop7

$bindir/dr2800 i ../out/$imagename rootfs.es customer.es misc.es
popd

