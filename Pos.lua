local Pos = {}

function Pos.new(x, y)
    return {x=x,y=y}
end

function Pos.lerp(position1, position2, amount)
    local x = position1.x + ((position2.x - position1.x) * amount)
    local y = position1.y + ((position2.y - position1.y) * amount)

    return Pos.new(x, y)
end

function Pos.mousePos()
    local x, y = screen:getMousePosition()
    return Pos.new(x, y)
end

function Pos.add(pos1, pos2)
    return Pos.new(pos1.x + pos2.x, pos1.y + pos2.y)
end

function Pos.mul(pos, factor)
    return Pos.new(pos.x * factor, pos.y * factor)
end

function Pos.vectorDirection(turns, length)
    length = length or 1

    local x = math.cos(turns * math.pi * 2)
    local y = math.sin(turns * math.pi * 2)

    return Pos.mul(Pos.new(x, y), length)
end

function Pos.addPos(e, pos)
    e.pos = pos
    return e
end

function Pos.copy(pos)
    return Pos.new(pos.x, pos.y)
end

return Pos
