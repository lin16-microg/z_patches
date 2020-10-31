#!/bin/bash

THISDIR=$PWD

cd ..
TOPDIR=$PWD

cd build/make
echo "Patching $PWD (user/host metadata)"
patch -p1 < $THISDIR/patch_001_build.patch
echo "-"
cd $TOPDIR

cd packages/apps/Email
echo "Patching $PWD (AOSP E-Mail Widget)"
patch -p1 < $THISDIR/patch_010_Email.patch
echo "-"
cd $TOPDIR

cd vendor/lineage
echo "Patching $PWD (build signing method)"
patch -p1 < $THISDIR/patch_002_vendor-lineage.patch
patch -p1 < $THISDIR/patch_003_vendor-lineage.patch
echo "-"
cd $TOPDIR

cd $THISDIR





