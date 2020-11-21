#!/bin/bash

list_repos() {
cat <<EOF
external/ant-wireless/ant_native:patch_700_ant-wireless.patch
external/conscrypt:patch_701_conscrypt.patch
external/neven:patch_702_neven.patch
frameworks/rs:patch_703_rs.patch
frameworks/ex:patch_704_ex.patch
packages/apps/FMRadio:patch_705_FMRadio.patch
packages/apps/Bluetooth:patch_706_Bluetooth.patch
packages/apps/Nfc:patch_707_Nfc.patch
packages/apps/Terminal:patch_708_Terminal.patch
art:patch_709_art.patch
hardware/qcom/fm:patch_710_fm.patch
libcore:patch_711_libcore.patch
vendor/nxp/opensource/commonsys/packages/apps/Nfc:patch_712_nxp-Nfc.patch
EOF
}

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


list_repos | while read STR; do
  DIR=$(echo $STR | cut -f1 -d:)
  PTC=$(echo $STR | cut -f2 -d:)
  cd $DIR
  echo "Constify JNI method tables: $DIR"
  patch -p1 < $THISDIR/$PTC
  cd $TOPDIR
done

cd $THISDIR





