#!/bin/bash

THISDIR=$PWD

cd ..
TOPDIR=$PWD

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





