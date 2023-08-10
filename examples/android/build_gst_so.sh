export ANDROID_HOME=/home/alex/Android/Sdk
export NDK_HOME=$ANDROID_HOME/ndk/21.4.7075529
export GSTREAMER_ROOT_ANDROID=/home/alex/Загрузки/gstreamer-1.0-android-universal-1.20.0


if [[ -z "${GSTREAMER_ROOT_ANDROID}" ]]; then
  echo "You must define an environment variable called GSTREAMER_ROOT_ANDROID and point it to the folder where you extracted the GStreamer binaries"
  exit 1
fi

VERSION=1.20.0
DATE=`date "+%Y%m%d-%H%M%S"`

rm -rf ./out
mkdir ./out

for TARGET in arm64
do
  NDK_APPLICATION_MK="jni/${TARGET}.mk"
  echo "\n\n=== Building GStreamer ${VERSION} for target ${TARGET} with ${NDK_APPLICATION_MK} ==="

  ${NDK_HOME}/ndk-build NDK_APPLICATION_MK=$NDK_APPLICATION_MK

  if [ $TARGET = "armv7" ]; then
    LIB="armeabi-v7a"
  elif [ $TARGET = "arm64" ]; then
      LIB="arm64-v8a"
  elif [ $TARGET = "x86_64" ]; then
    LIB="x86_64"
  else
    LIB="x86"
  fi;

  GST_LIB='gst-build-'${LIB}

  cp -r libs/${LIB}/libgstreamer_android.so ${GST_LIB}
  cp -r $GSTREAMER_ROOT_ANDROID/${TARGET}/lib/pkgconfig ${GST_LIB}

  echo 'Processing '$GST_LIB
  cd ${GST_LIB}
  sed -i -e 's?prefix=.*?prefix='${GSTREAMER_ROOT_ANDROID}'/'${TARGET}'?g' pkgconfig/*
#  sed -i -e 's?libdir=.*?libdir='`pwd`'?g' pkgconfig/*
#  sed -i -e 's?.* -L${.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
#  sed -i -e 's?Libs:.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
#  sed -i -e 's?Libs.private.*?Libs.private: -lgstreamer_android?g' pkgconfig/*
#  rm -rf pkgconfig/*pc-e*
  cd ../
  mkdir -p ./out/Gstreamer-$VERSION/$TARGET/lib/
  cp -r ${GST_LIB}/libgstreamer_android.so  ./out/Gstreamer-$VERSION/$TARGET/lib/
#  rm -rf ${GST_LIB}/${LIB}
done

#rm -rf libs obj

echo "\n*** Done ***\n`ls out`"