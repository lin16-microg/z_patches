#!/bin/bash

THISDIR=$PWD

cd ..
TOPDIR=$PWD


cd device/lineage/sepolicy
echo "Patching $PWD (genfs_contexts)"
rm common/private/genfs_contexts
echo "-"
cd $TOPDIR

cd external/tinycompress
echo "Patching $PWD (Kernel Headers)"
patch -p1 < $THISDIR/patch_101_tinycompress.patch
echo "-"
cd $TOPDIR

cd packages/apps/SetupWizard
echo "Patching $PWD (Setup Wizard)"
patch -p1 < $THISDIR/patch_002_SetupWizard.patch
echo "-"
cd $TOPDIR

cd packages/apps/Camera2
echo "Patching $PWD (Disable Camera location tagging)"
patch -p1 < $THISDIR/patch_003_Camera2.patch
echo "-"
cd $TOPDIR


cd $THISDIR





