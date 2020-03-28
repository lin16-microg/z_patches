#!/bin/bash

##
## Final file processing
##
create_files() {
  TARGET_FILE=treble_arm64_a_lineage16_$(date +%Y%m%d)_system.img
  ln -f $OUT/system.img $OUT/$TARGET_FILE
  if [ "$MAKE_ZIP" = true ] ; then
    echo "Making ZIP file..."
    zip $OUT/$TARGET_FILE.zip $OUT/$TARGET_FILE
  fi
}

# Check parameters
case "$1" in
  test) TESTKEY=true
    ;;
  sign) TESTKEY=false
    ;;
  *) echo "usage: build_treble test|sign [root] [zip]"
     echo "-----------------------------------------------------"
     echo "test - build with testkeys (insecure, but compatible)"
     echo "sign - create a signed build"
     echo "root - if passed, include root"
     echo "zip  - if passed, create also a compressed ZIP file"
     exit
    ;;   
esac

# Initiate environment
source build/envsetup.sh

# CCache
# ------
# uncomment the below line to set own cache 
# directory (default is ~/.ccache)
export USE_CCACHE=1
#export CCACHE_DIR=~/android/.ccache
prebuilts/misc/linux-x86/ccache/ccache -M 48G

# Normalize build metadata
export KBUILD_BUILD_USER=android
export KBUILD_BUILD_HOST=localhost

if [ "$TESTKEY" = false ] ; then
  export OWN_KEYS_DIR=~/.android-certs
  export RELEASE_TYPE=UNOFFICIAL-microG-signed

  # We need symlinks to fake the existence of a testkey 
  # for the selinux build process
  if [ ! -e $OWN_KEYS_DIR/testkey.pk8 ] ; then
    ln -s $OWN_KEYS_DIR/releasekey.pk8 $OWN_KEYS_DIR/testkey.pk8
    echo "Symlink testkey.pk8 created"
  fi
  if [ ! -e $OWN_KEYS_DIR/testkey.x509.pem ] ; then
    ln -s $OWN_KEYS_DIR/releasekey.x509.pem $OWN_KEYS_DIR/testkey.x509.pem
    echo "Symlink testkey.x509.pem created"
  fi
else
  export RELEASE_TYPE=UNOFFICIAL-microG
fi

if [ "$2" == "root" ]; then
  echo "Including ROOT..."
  export WITH_SU=true
fi

if [ "$3" == "zip" ]; then
  MAKE_ZIP=true
else
  if [ "$2" == "zip" ]; then
    MAKE_ZIP=true
  else
    MAKE_ZIP=false
  fi
fi

lunch treble_arm64_avN-userdebug
make WITHOUT_CHECK_API=true systemimage && create_files

