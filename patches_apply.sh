#!/bin/bash

THISDIR=$PWD

cd ..
TOPDIR=$PWD

cd build/make
echo "Patching $PWD (user/host metadata)"
patch -p1 < $THISDIR/patch_001_build.patch
echo "-"
cd $TOPDIR

cd packages/apps/SetupWizard
echo "Patching $PWD (Setup Wizard)"
patch -p1 < $THISDIR/patch_002_SetupWizard.patch
echo "-"
cd $TOPDIR


cd $THISDIR





