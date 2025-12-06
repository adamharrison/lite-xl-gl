#!/usr/bin/env bash

: ${CC=gcc}
: ${BIN=libgl.so}
: ${MAKE=make}


COMPILE_FLAGS="$CFLAGS -I`pwd`/lib/lite-xl/resources/include -I`pwd`/lib/prefix/include -fPIC -Ilib/lite-xl/resources/include" # We specifically rename this and LDFLAGS, because exotic build environments export these to subprocesses.
LINK_FLAGS="$LDFLAGS -lm -L`pwd`/lib/prefix/lib -L`pwd`/lib/prefix/lib64"   # And ideally we don't want to mess with the underlying build processes, unless we're explicit about it.
CMAKE_DEFAULT_FLAGS=" $CMAKE_DEFAULT_FLAGS -DCMAKE_PREFIX_PATH=`pwd`/lib/prefix -DCMAKE_INSTALL_PREFIX=`pwd`/lib/prefix -DBUILD_SHARED_LIBS=OFF"


[[ "$@" == "clean" ]] && rm -rf *.so *.dll lib/freetype2/build lib/SDL/build lib/prefix && exit 0
[[ $OSTYPE != 'msys'* && $OSTYPE != 'cygwin'* && $CC != *'mingw'* ]] && LINK_FLAGS="$LINK_FLAGS -lutil"

cmake --version >/dev/null 2>/dev/null || { echo "Please ensure that you have cmake installed." && exit -1; }
mkdir -p lib/prefix/include lib/prefix/lib

if [[ "$@" != *"-lfreetype"* ]]; then
  echo "FT_USE_MODULE( FT_Module_Class, autofit_module_class ) FT_USE_MODULE( FT_Driver_ClassRec, tt_driver_class ) FT_USE_MODULE( FT_Driver_ClassRec, cff_driver_class ) \
    FT_USE_MODULE( FT_Module_Class, psnames_module_class ) FT_USE_MODULE( FT_Module_Class, pshinter_module_class ) FT_USE_MODULE( FT_Module_Class, sfnt_module_class )\
    FT_USE_MODULE( FT_Renderer_Class, ft_smooth_renderer_class ) FT_USE_MODULE( FT_Renderer_Class, ft_raster1_renderer_class )" > lib/freetype/include/freetype/config/ftmodule.h
  COMPILE_FLAGS="$COMPILE_FLAGS -Ilib/freetype/include"
  LINK_FLAGS="$LINK_FLAGS -Ilib/freetype/include -DFT2_BUILD_LIBRARY"
  LLSRCS=" $LLSRCS lib/freetype/src/base/ftsystem.c lib/freetype/src/base/ftinit.c lib/freetype/src/base/ftdebug.c lib/freetype/src/base/ftbase.c \
    lib/freetype/src/base/ftbbox.c lib/freetype/src/base/ftglyph.c lib/freetype/src/sfnt/sfnt.c lib/freetype/src/truetype/truetype.c lib/freetype/src/raster/raster.c \
    lib/freetype/src/smooth/smooth.c lib/freetype/src/autofit/autofit.c lib/freetype/src/psnames/psnames.c lib/freetype/src/pshinter/pshinter.c lib/freetype/src/cff/cff.c \
    lib/freetype/src/gzip/ftgzip.c lib/freetype/src/base/ftbitmap.c"
fi


if [[ "$@" != *"-lSDL"* ]]; then
  CFLAGS="$CFLAGS -Ilib/prefix/include"
  LLFLAGS="$LLFLAGS -Llib/prefix/lib"
  [ ! -e "lib/SDL/build" ] && { cd lib/SDL && mkdir build && cd build && cmake .. -G "Unix Makefiles" $CMAKE_DEFAULT_FLAGS \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DSDL_INSTALL=ON -DSDL_INSTALL_DOCS=OFF -DSDL_DEPS_SHARED=ON \
		-DSDL_AVX=OFF -DSDL_AVX2=OFF -DSDL_AVX512F=OFF -DSDL_SSE3=OFF -DSDL_SSE4_1=OFF -DSDL_SSE4_2=OFF \
		-DSDL_DBUS=ON -DSDL_IBUS=ON -DSDL_AUDIO=OFF -DSDL_GPU=ON -DSDL_RPATH=OFF -DSDL_PIPEWIRE=OFF \
		-DSDL_CAMERA=OFF -DSDL_JOYSTICK=OFF -DSDL_HAPTIC=OFF -DSDL_HIDAPI=OFF -DSDL_DIALOG=OFF \
		-DSDL_POWER=OFF -DSDL_SENSOR=OFF -DSDL_VULKAN=OFF -DSDL_LIBUDEV=OFF -DSDL_SHARED=OFF -DSDL_STATIC=ON \
		-DSDL_X11=ON -DSDL_WAYLAND=ON -DSDL_VIDEO=ON -DSDL_TESTS=OFF -DSDL_EXAMPLES=OFF -DSDL_VENDOR_INFO=lite-xl && 
		$MAKE -j $JOBS && $MAKE install && cd ../../../ || exit -1; }
  LINK_FLAGS="-lSDL3 $LINK_FLAGS"
fi

$CC $COMPILE_FLAGS *.c api/*.c $@ -shared -o $BIN $LINK_FLAGS 
