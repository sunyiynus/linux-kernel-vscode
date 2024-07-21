#!/bin/bash

ROOTFS_DOWNLOAD_URL=http://dl-cdn.alpinelinux.org/alpine/v3.13/main
mkdir -p rootfs
mkdir -p `pwd`/tmp
curl $ROOTFS_DOWNLOAD_URL/x86_64/APKINDEX.tar.gz | tar -xz -C `pwd`/tmp/
APK_TOOL=`grep -A1 apk-tools-static `pwd`/tmp/APKINDEX | cut -c3- | xargs printf "%s-%s.apk"`
curl $ROOTFS_DOWNLOAD_URL/x86_64/$APK_TOOL | fakeroot tar -xz -C rootfs
fakeroot rootfs/sbin/apk.static \
    --repository $ROOTFS_DOWNLOAD_URL --update-cache \
    --allow-untrusted \
    --root $PWD/rootfs --initdb add alpine-base
echo $ROOTFS_DOWNLOAD_URL > rootfs/etc/apk/repositories
echo "LABEL=ALPINE_ROOT / auto defaults 1 1" >> rootfs/etc/fstab