#!/bin/sh

#script to generate android-compatible, statically linked, openSMILE binary
if [ "$1" = "" ]; then
	echo "Usage sudo sh buildAndroidARM-gnustl.sh <api> <optional-config-args>\ne.g. sudo sh buildARM.sh android-8"
	exit 1
else
    #run autogen twice
	./autogen.sh ;
	./autogen.sh ;
    #get the platform used, e.g. android-8 or whatever
    platform=$1
	shift
	#assume that ndk is in the same directory and that the ndk version is r8e
	export NDK=../android-ndk-r8e
    #it is recommended to have these but not necessary from my experience
	cp ${NDK}/config.guess .
	cp ${NDK}/config.sub .
	#the following are needed for almost any autoconf port
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
	#you want to make sure linker does not go for default libraries
	export LDFLAGS="-Wl,-rpath-link=${NDK}/platforms/${platform}/arch-arm/usr/lib -L${NDK}/platforms/${platform}/arch-arm/usr/lib -L${NDK}/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/armeabi"
	#some required libraries reside here
	export SYSROOT=${NDK}/platforms/${platform}/arch-arm
	#and incude the headers...
	export CXXFLAGS="-I${NDK}/platforms/${platform}/arch-arm/usr/include -I${NDK}/sources/cxx-stl/gnu-libstdc++/4.4.3/include -I${NDK}/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/armeabi/include --sysroot=${SYSROOT} -O3"
	export CPPFLAGS="--sysroot=${SYSROOT}"
	#remind compiler to not link against default stdlib
	export CFLAGS="--sysroot=${SYSROOT} -nostdlib -O3" 
    #parse any additional args (not really tested...)
	argStr=""
	
	while [ "$1" != "" ]; do
		argStr="${argStr} $1"
		shift
	done
	#run config, we want a static binary
	./configure --enable-static --enable-shared=no --host=arm-linux-androideabi --target=arm-linux-androideabi LIBS="-lc -lgcc -lgnustl_static -lsupc++" $argStr

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
