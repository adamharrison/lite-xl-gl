#define LITE_XL_PLUGIN_ENTRYPOINT
#include <lite_xl_plugin_api.h>

#ifndef LIBGL_VERSION
  #define LIBGL_VERSION "unknown"
#endif

int luaopen_renderer(lua_State* L);
int luopen_renwindow(lua_State* L);

int luaopen_lite_xl_libgl(lua_State* L, void* XL) {
  lite_xl_plugin_init(XL);
  lua_newtable(L);
  lua_pushliteral(L, LIBGL_VERSION);
  lua_setfield(L, -2, "version");
  luaopen_renderer(L);
  lua_setfield(L, -2, "renderer");
  luopen_renwindow(L);
  lua_setfield(L, -2, "renwindow");
  return 1;
}

