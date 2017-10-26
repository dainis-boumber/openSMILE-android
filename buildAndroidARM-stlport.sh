#!/bin/sh

#see buildAndroidARM-gnustl file for detailed comments - they are almost identical
if [ "$1" = "" ]; then
	echo "Usage sudo buildAndroidARM-stlport.sh <api> <optional-config-args>\ne.g. sudo sh buildARM.sh android-8"
	exit 1
else

	./autogen.sh ;
	./autogen.sh ;
	mkdir inst

    platform=$1
	shift
	
	export NDK=../android-ndk-r8e

	cp ${NDK}/config.guess .
	cp ${NDK}/config.sub .
	
	export NDK_TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin
	export CROSS_COMPILE=arm-linux-androideabi
	export CC=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-gcc
	export CXX=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-g++
	export LD=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-ld
	export AR=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-ar
	export RANLIB=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-ranlib
	export STRIP=${NDK_TOOLCHAIN}/${CROSS_COMPILE}-strip
	export ac_cv_func_malloc_0_nonnull=yes
	export ac_cv_func_realloc_0_nonnull=yes
	
	export LDFLAGS="-Wl,-rpath-link=${NDK}/platforms/${platform}/arch-arm/usr/lib -L${NDK}/platforms/${platform}/arch-arm/usr/lib -L${NDK}/sources/cxx-stl/stlport/libs/armeabi"
	export SYSROOT=${NDK}/platforms/${platform}/arch-arm
	export CXXFLAGS="-I${NDK}/platforms/${platform}/arch-arm/usr/include -I${NDK}/sources/cxx-stl/stlport/stlport --sysroot=${SYSROOT}"
	export CPPFLAGS="--sysroot=${SYSROOT}"
	export CFLAGS="--sysroot=${SYSROOT} -nostdlib" 

	argStr=""
	
	while [ "$1" != "" ]; do
		argStr="${argStr} $1"
		shift
	done
	
	./configure --enable-static --enable-shared=no --host=arm-linux-androideabi --target=arm-linux-androideabi LIBS="-lc -lgcc -lstlport_static" $argStr

	if [ $? != 0 ]; then
  		echo "failed to configure openSMILE!";
  		exit -1;
	fi

	make clean &&
	make ; make 
	if [ $? != 0 ]; then
  		echo "failed to build or install openSMILE!";
  		exit -1;
	fi

    chmod 777 SMILExtract

	echo ""
	echo "build successfull. You can now use the SMILExtract binary."
	echo ""
fi
