export GSTREAMER_ROOT_ANDROID=/home/alex/Загрузки/gstreamer-1.0-android-universal-1.20.0
export ANDROID_HOME=/home/alex/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/21.4.7075529
#23.2.8568313

ROOT=${PWD}
PKG_CONFIG_PATH_OLD=$PKG_CONFIG_PATH
#cd ../../etc
#./android_bootstrap.sh armeabi-v7a
cd ../../
export PKG_CONFIG_PATH=/home/alex/Загрузки/gstreamer-1.0-android-universal-1.20.0/arm64/lib/pkgconfig:/usr/lib64/pkgconfig
echo "Set PKG_CONFIG_PATH to ${PKG_CONFIG_PATH}"
cd servo-media
echo "Building servo-media ${PWD}"
#PKG_CONFIG_ALLOW_CROSS=1 cargo ndk -t arm64-v8a build || return 1

PKG_CONFIG_ALLOW_CROSS=1 cargo build --target=aarch64-linux-android || return 1

export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/23.2.8568313
cd ${ROOT}/lib
echo "Building servo-media-android ${PWD}"
PKG_CONFIG_ALLOW_CROSS=1 cargo ndk -t arm64-v8a build || return 1
#PKG_CONFIG_ALLOW_CROSS=1 cargo build --target=aarch64-linux-android || return 1
echo "Set PKG_CONFIG_PATH to previous state ${PKG_CONFIG_PATH_OLD}"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_OLD
