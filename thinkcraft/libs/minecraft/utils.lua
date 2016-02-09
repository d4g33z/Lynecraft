require ('math')

--From minecraft.lua
map = function(func, table)
    for k,v in pairs(table) do
   --    print("in map ")
   --    print(k,v)
       table[k] = func(v)
    end
--    print ("end map")
--    print (table)
    return table
end

value_map = function(func,table)
    tmp = {}
    local i=1
    for k,v in pairs(table) do
        tmp[i] = func(v)
        i = i+1
    end
    return tmp
end

--TODO implement a split like functin
split = function(sep, string)
    assert (sep ~= "")
    local t={}
    for i in string.gmatch(string, '[^'..sep..']+') do
    --    print (t, i)
        table.insert(t, i)
    end
    return t
end

intFloor = function(inputArray)
    return map(toInteger, inputArray)
end

toInteger = function (num)
    return math.floor(tonumber(num)) or error("Could not create integer from "..tostring(num))
    --return math.floor(tonumber(num)) or error("Could not create integer from "..tostring(num))
end

getNumFromStatusBool = function(boolean)
    if (boolean == 1 or string.lower(boolean) == 'true') then
        return 1
    else
        return 0
    end
end


--From connection.lua
function join(sep, tbl)
    local str = ""
    local numElements = table.getn(tbl)
    local iter = 1
    for k,v in pairs(tbl) do
       str = str..v
       if iter ~= numElements then
           str = str..","
       end
       iter = iter + 1
    end
    return str

end

function flattenIndexedTable (tbl)
    flatTable = {}
--    print( type(tbl), tbl)
    if (tbl ~= nil and type(tbl) == 'table') then
        for k,v in ipairs(tbl) do
        --    print(k,v)
            if (v ~= nil and type(v) == 'table') then
                table.insert(flatTable, flattenIndexedTable(v))
            else
                table.insert(flatTable, v)
            end
        end
    else
        table.insert(flatTable, tbl)
    end
    for k,v in pairs(flatTable) do
    --    print(k,v)
    end
    return flatTable
end

function flattenIndexedTableToString(tbl)
--    print( type(tbl), tbl)
    if (tbl ~= nil and type(tbl)== 'table') then
        local arrSz = table.getn(tbl)
    --    print("arrsz "..arrSz)
        if(arrSz > 0)then
            --Remove empty strings and join together
            return join(",", flattenIndexedTable(tbl));
        else
            return ""
        end
    else
        return tbl
    end
end


