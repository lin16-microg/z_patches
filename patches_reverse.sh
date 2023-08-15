#!/bin/bash

clear_set() {
  cd $1
  echo "Clearing: $PWD"
  git add . > /dev/null
  git stash > /dev/null
  find -name *.orig | while read LINE; do rm $LINE; done
  find -name *.rej | while read LINE; do rm $LINE; done
  git clean -f > /dev/null
  git stash clear > /dev/null
  cd $TOPDIR
}

THISDIR=$PWD

cd ..
TOPDIR=$PWD

clear_set device/common
clear_set hardware/qcom/gps
clear_set packages/apps/Camera2
clear_set packages/apps/SetupWizard
clear_set system/ca-certificates

#Constify JNI method tables, revert
clear_set art
clear_set external/ant-wireless/ant_native
clear_set external/conscrypt
clear_set external/Mulch
clear_set external/neven
clear_set frameworks/rs
clear_set frameworks/ex
clear_set hardware/qcom/fm
clear_set libcore
clear_set packages/apps/FMRadio
clear_set packages/apps/Bluetooth
clear_set packages/apps/Terminal
clear_set vendor/nxp/opensource/commonsys/packages/apps/Nfc

cd $THISDIR
