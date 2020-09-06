#!/bin/bash

print_help() {
  echo "usage: build_device <device> test|sign [root]"
  echo "----------------------------------------------------------------------"
  echo " <device> Device name (amami|gts210ltexx|gts210vewifi|oneplus3|osprey)"
  echo "test - build with testkeys (insecure, but compatible)"
  echo "sign - create a signed build"
  echo "root - optional, if passed, build with root baked in"
}

print_device() {
  echo "Building $1 ..."
}


# Check parameters
case "$1" in
  amami|gts210ltexx|gts210vewifi|oneplus3|osprey)
     print_device $1
    ;;
  *) print_help
     exit
    ;;
esac
case "$2" in
  test) TESTKEY=true
    ;;
  sign) TESTKEY=false
    ;;
  *) print_help
     exit
    ;;
esac

# Initiate environment
source build/envsetup.sh

# Build with root ?
if [ "$3" == "root" ]; then
  echo "Including ROOT..."
  export WITH_SU=true
fi

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

#start build
if [ "$TESTKEY" = false ] ; then
  export OWN_KEYS_DIR=~/.android-certs
  export RELEASE_TYPE=UNOFFICIAL-signed

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
fi
brunch $1

