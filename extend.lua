-- extend by ixtWuko

local tinsert = table.insert

local EMPTY_METATABLE = {
    __newindex = function()  end,
    __metatable = "",
}

local EMPTY_TABLE = setmetatable({}, EMPTY_METATABLE)

function table.empty()
    return EMPTY_TABLE
end

function table.prepend(target, source)
    for i, v in ipairs(source) do
        tinsert(target, i, v)
    end
    return target
end

function table.append(target, source)
    for _, v in ipairs(source) do
        tinsert(target, v)
    end
    return target
end

function table.copy(t)
    local ret = {}
    for k, v in pairs(t) do
        ret[k] = v
    end
end

local function deepcopy(t, mem)
    if type(t) ~= "table" then
        return t
    end
    if mem[t] then
        return mem[t]
    end

    local copy = {}
    mem[t] = copy
    for k, v in pairs(t) do
        copy[deepcopy(k, mem)] = deepcopy(v, mem)
    end
    -- setmetatable(copy, deepcopy(getmetatable(t), mem))
    setmetatable(copy, getmetatable(t))
    return copy
end

function table.deepcopy(t)
    local mem = {}
    return deepcopy(t, mem)
end

function table.tomap(list)
    local ret = {}
    for _, v in ipairs(list) do
        ret[v] = true
    end
    return ret
end

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

function table.map(t, f)
    local ret = {}
    for k, v in pairs(t) do
        ret[k] = f(v)
    end
    return ret
end


function string.split(s, delimiter)
    if s == nil or delimiter == nil then return nil end

    local ret = {}
    local from  = 1
    local strFind = string.find
    local strSub = string.sub

    local delimiterFrom, delimiterTo = strFind(s, delimiter, from)
    while delimiterFrom do
        tinsert(ret, strSub(s, from, delimiterFrom - 1))
        from  = delimiterTo + 1
        delimiterFrom, delimiterTo = strFind(s, delimiter, from)
    end

    tinsert(ret, strSub(s, from))

    return ret
end
