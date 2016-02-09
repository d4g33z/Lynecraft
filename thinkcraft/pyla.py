from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)

def doLua(path):
    for line in open(path,'r').readlines():
        lua.execute(line.strip())

def table2dict(table):
    return {k:v for k,v in table.items()}

