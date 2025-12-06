#define LITE_XL_PLUGIN_ENTRYPOINT
#include <lite_xl_plugin_api.h>

#ifndef LIBGL_VERSION
  #define LIBGL_VERSION "unknown"
#endif

int luaopen_renderer(lua_State* L);
int luaopen_renwindow(lua_State* L);
int ren_init();

int luaopen_lite_xl_libgl(lua_State* L, void* XL) {
  lite_xl_plugin_init(XL);
  lua_newtable(L);
  lua_pushliteral(L, LIBGL_VERSION);
  lua_setfield(L, -2, "version");
  luaopen_renderer(L);
  lua_setfield(L, -2, "renderer");
  luaopen_renwindow(L);
  lua_setfield(L, -2, "renwindow");
  if (ren_init() != 0)
    return luaL_error(L, "unable to initailize renderer");
  return 1;
}

