#!/bin/bash

print_help() {
  echo "usage: build_oneplus3 <device> test|sign"
  echo "----------------------------------------"
  echo " <device> Device name (oneplus3)"
  echo "test - build with testkeys (insecure, but compatible)"
  echo "sign - create a signed build"
}

print_device() {
  echo "Building $1 ..."
}


# Check parameters
case "$1" in
  oneplus3)
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

# CCache
# ------
# uncomment the below line to set own cache 
# directory (default is ~/.ccache)
export USE_CCACHE=1
#export CCACHE_DIR=~/android/.ccache
prebuilts/misc/linux-x86/ccache/ccache -M 48G

# un-comment below line, if you want to build with root baked in
# export WITH_SU=true

# Normalize build metadata
export KBUILD_BUILD_USER=android
export KBUILD_BUILD_HOST=localhost

#start build
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
fi
brunch $1

