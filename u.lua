local u = {}

local index = 0

function u.nextId()
    index = index + 1
    return index
end

function u.addId(e)
    e.id = u.nextId()
    return e
end

function u.forEach(array, func)
    for i, e in ipairs(array) do
        local res = func(e, i)
        if res ~= nil then
            return res
        end
    end
end

function u.hasId(id)
    return function (e)
        return e.id == id
    end
end

function u.withId(array, id)
    return u.where(array, u.hasId(id))
end

function u.where(array, func)
    for i, e in ipairs(array) do
        if func(e) then
            return e
        end
    end
end

function u.filter(array, func)
    local ret = {}
    for i, e in ipairs(array) do
        if func(e) then
            table.insert(ret, e)
        end
    end
    return ret
end

function u.withIds(array, ids)
    local ret = {}

    -- Very bad loop but whatever
    u.forEach(ids, function(id)
        local e = u.withId(array, id)
        table.insert(ret, e)
    end)

    return ret
end

function u.indexWhere(array, func)
    for i, e in ipairs(array) do
        if func(e) then
            return i
        end
    end
end

function u.indexWithId(array, id)
    return u.indexWhere(array, function(e) return e.id == id end)
end

function u.removeWithId(array, id)
    table.remove(array, u.indexWithId(array, id))
end

function u.debugRect(x, y, width, height)
    love.graphics.rectangle("line", x, y, width, height)
end

function u.drawBB(e)
    love.graphics.rectangle("line", e.pos.x, e.pos.y, e.bb.width, e.bb.height)
end


return u
