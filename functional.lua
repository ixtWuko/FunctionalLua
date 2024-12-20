-- functional by ixtWuko
-- functional programming in Lua

require("extend")

local tinsert = table.insert

local fp = {}

function fp.Empty()
end

--function fp.Curry(f, num_params)
--    return function(...)
--        local params = table.pack(...)
--        if params.n >= num_params then
--            return f(...)
--        else
--            local fn = function(...)
--                return f(table.unpack(fp.t.Prepend(params, table.pack(...))))
--            end
--            return fp.Curry(fn, num_params - params.n)
--        end
--    end
--end

---@param f fun(...) : any
---@param num_params integer
---@return fun(...) : any
function fp.Curry(f, num_params)
    local curried = { __f = f, __n = num_params }
    curried.__index = curried
    curried.__newindex = fp.Empty
    curried.__tostring = function(fn) return tostring(fn.__f) end
    curried.__call = function(fn, ...)
        local params = table.pack(...)
        if params.n == 0 then
            return fn
        end

        if fn.__p then
            fp.t.Prepend(fn.__p, params)
            params.n = params.n + fn.__p.n
        end

        if params.n >= fn.__n then
            return fn.__f(table.unpack(params))
        else
            return fn.__new(params)
        end
    end
    curried.__new = function(params)
        local fn = { __p = params }
        setmetatable(fn, curried)
        return fn
    end
    return curried.__new()
end

function fp.Compose(...)
    local fns = table.pack(...)
    return function(...)
        local params = table.pack(...)
        for i = fns.n, 1, -1 do
            params = table.pack(fns[i](table.unpack(params)))
        end
        return table.unpack(params)
    end
end


local insert = function(index, value, list)
    tinsert(list, index, value)
    return list
end

local insertTail = function(value, list)
    tinsert(list, value)
    return list
end

local remove = function(index, list)
    return table.remove(list, index)
end

local removeTail = function(list)
    return table.remove(list)
end

local prepend = function(source, target)
    return table.prepend(target, source)
end

local append = function(source, target)
    return table.append(target, source)
end

local sort = function(comp, list)
    table.sort(list, comp)
    return list
end

local map = function(f, t)
    return table.map(t, f)
end

local concat = function(sep, list)
    return table.concat(list, sep)
end

fp.t = {}

---@type fun(index:integer, value:any, list:table) : table
fp.t.Insert = fp.Curry(insert, 3)

---@type fun(value:any, list:table) : table
fp.t.InsertHead = fp.t.Insert(1)

---@type fun(value:any, list:table) : table
fp.t.InsertTail = fp.Curry(insertTail, 2)

---@type fun(index:integer, list:table) : any
fp.t.Remove = fp.Curry(remove, 2)

---@type fun(list:table) : any
fp.t.RemoveHead = fp.t.Remove(1)

---@type fun(list:table) : any
fp.t.RemoveTail = fp.Curry(removeTail, 1)

---@type fun(source:table, target:table) : table
fp.t.Prepend = fp.Curry(prepend, 2)

---@type fun(source:table, target:table) : table
fp.t.Append = fp.Curry(append, 2)

---@type fun(comp:(fun(a:any, b:any):boolean), list:table) : table
fp.t.Sort = fp.Curry(sort, 2)

---@type fun(f:(fun(a:any):any), t:table) : table
fp.t.Map = fp.Curry(map, 2)

---@type fun(sep:string, list:table) : string
fp.t.Concat = fp.Curry(concat, 2)


local rep = function(sep, n, s)
    return string.rep(s, n, sep)
end

local sub = function(i, j, s)
    return string.sub(s, i, j)
end

local match = function(pattern, init, s)
    return string.match(s, pattern, init)
end

local find = function(pattern, init, plain, s)
    return string.find(s, pattern, init, plain)
end

local gmatch = function(pattern, s)
    return string.gmatch(s, pattern)
end

local gsub = function(pattern, repl, n, s)
    return string.gsub(s, pattern, repl, n)
end

local split = function(delimiter, s)
    return string.split(s, delimiter)
end

fp.s = {}

---@type fun(sep:string, n:integer, s:string) : string
fp.s.Rep = fp.Curry(rep, 3)

---@type fun(i:integer, j:integer, s:string) : string
fp.s.Sub = fp.Curry(sub, 3)

---@type fun(pattern:string, init:integer, s:string) : any
fp.s.Match = fp.Curry(match, 3)

---@type fun(pattern:string, init:integer, plain:boolean, s:string) : integer, integer, string
fp.s.Find = fp.Curry(find, 4)

---@type fun(pattern:string, s:string) : fun(): string
fp.s.Gmatch = fp.Curry(gmatch, 2)

---@type fun(pattern:string, repl:string, n:integer, s:string) : string, number
fp.s.Gsub = fp.Curry(gsub, 4)

---@type fun(delimiter:string, s:string) : string[]
fp.s.Split = fp.Curry(split, 2)

return fp
