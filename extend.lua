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

function table.count(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

function table.find(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
end

function table.findif(t, condition)
    for k, v in pairs(t) do
        if condition(k, v) then
            return k
        end
    end
end

function table.keys(t)
    local ret = {}
    for k in pairs(t) do
        tinsert(ret, k)
    end
    return ret
end

function table.values(t)
    local ret = {}
    for _, v in pairs(t) do
        tinsert(ret, v)
    end
    return ret
end

function table.tomap(list)
    local ret = {}
    for _, v in ipairs(list) do
        ret[v] = true
    end
    return ret
end

function table.reverse(list)
    local left, right = 1, #list
    while left < right do
        list[left], list[right] = list[right], list[left]
        left, right = left + 1, right - 1
    end
    return list
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

function table.foreach(t, f)
    for _, v in pairs(t) do
        f(v)
    end
end

function table.map(t, f)
    local ret = {}
    for k, v in pairs(t) do
        ret[k] = f(v)
    end
    return ret
end

function table.filter(t, filter)
    local ret = {}
    for k, v in pairs(t) do
        if filter(v) then
            ret[k] = v
        end
    end
    return ret
end

function table.reduce(list, calc, init)
    init = init or 0
    for _, v in ipairs(list) do
        init = calc(init, v)
    end
    return init
end

function table.zip(lhs, rhs, f)
    local ret = {}
    if next(lhs) and next(rhs) then
        local j, size = 1, #rhs
        for _, v in ipairs(lhs) do
            tinsert(ret, f(v, rhs[j]))
            j = j + 1
            if j > size then
                j = 1
            end
        end
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
