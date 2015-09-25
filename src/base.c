#define __gnuc_va_list __builtin_va_list
typedef int wint_t;

#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/luadep.h"
#include "lua/lauxlib.h"

const char *global_msg = "Bar";

void
_start() {
    lua_State *L = luaL_newstate();
    const char *local_dsg = "Foo";
    const char *local_msg = global_msg;
}
