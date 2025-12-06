#!/usr/bin/env bash

: ${CC=gcc}
: ${BIN=libgl.so}

CFLAGS="$CFLAGS -fPIC -Ilib/lite-xl/resources/include"
LDFLAGS="$LDFLAGS -lSDL3"

[[ "$@" == "clean" ]] && rm -f *.so *.dll && exit 0
[[ $OSTYPE != 'msys'* && $OSTYPE != 'cygwin'* && $CC != *'mingw'* ]] && LDFLAGS="$LDFLAGS -lutil"

if [[ "$@" != *"-lfreetype"* ]]; then
  echo "FT_USE_MODULE( FT_Module_Class, autofit_module_class ) FT_USE_MODULE( FT_Driver_ClassRec, tt_driver_class ) FT_USE_MODULE( FT_Driver_ClassRec, cff_driver_class ) \
    FT_USE_MODULE( FT_Module_Class, psnames_module_class ) FT_USE_MODULE( FT_Module_Class, pshinter_module_class ) FT_USE_MODULE( FT_Module_Class, sfnt_module_class )\
    FT_USE_MODULE( FT_Renderer_Class, ft_smooth_renderer_class ) FT_USE_MODULE( FT_Renderer_Class, ft_raster1_renderer_class )" > lib/freetype/include/freetype/config/ftmodule.h
  CFLAGS="$CFLAGS -Ilib/freetype/include"
  LLFLAGS="$LLFLAGS -Ilib/freetype/include -DFT2_BUILD_LIBRARY"
  LLSRCS=" $LLSRCS lib/freetype/src/base/ftsystem.c lib/freetype/src/base/ftinit.c lib/freetype/src/base/ftdebug.c lib/freetype/src/base/ftbase.c \
    lib/freetype/src/base/ftbbox.c lib/freetype/src/base/ftglyph.c lib/freetype/src/sfnt/sfnt.c lib/freetype/src/truetype/truetype.c lib/freetype/src/raster/raster.c \
    lib/freetype/src/smooth/smooth.c lib/freetype/src/autofit/autofit.c lib/freetype/src/psnames/psnames.c lib/freetype/src/pshinter/pshinter.c lib/freetype/src/cff/cff.c \
    lib/freetype/src/gzip/ftgzip.c lib/freetype/src/base/ftbitmap.c"
fi

$CC $CFLAGS *.c api/*.c $@ -shared -o $BIN $LDFLAGS
