## gl

This plugin implements an SDL-based hardware accelerated renderer.

### Building

This plugins statically compiles SDL with GPU features into the plugin.

#### Linux

To build, on linux, simply do:

```
build.sh
```


#### Linux -> Windows

```
./build.sh clean && CC=x86_64-w64-mingw32-gcc AR=x86_64-w64-mingw32-gcc-ar WINDRES=x86_64-w64-mingw32-windres \
  CMAKE_DEFAULT_FLAGS="-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=NEVER -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=NEVER\
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_SYSTEM_INCLUDE_PATH=/usr/share/mingw-w64/include"\
  GIT2_CONFIGURE="-DDLLTOOL=x86_64-w64-mingw32-dlltool" BIN=libgl.dll ./build.sh -lgdi32 -DLIBGL_VERSION='"'$VERSION-x86_64-windows-`git rev-parse --short HEAD`'"'
```


