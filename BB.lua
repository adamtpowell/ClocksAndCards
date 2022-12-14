local BB = {}

function BB.new(width, height)
    return {
        width = width,
        height = height,
    }
end

function BB.addBB(e, width, height)
    e.bb = BB.new(width, height)
    return e
end

function BB.collidesWithPoint(e, pos)
    return
        pos.x > e.pos.x and pos.x < e.pos.x + e.bb.width and
        pos.y > e.pos.y and pos.y < e.pos.y + e.bb.height
end

function BB.getHoveredFromArray(array)
    local mouse_pos = Pos.mousePos()
    for i, e in ipairs(array) do
        if BB.collidesWithPoint(e, mouse_pos) then
            return i, e
        end
    end
end


return BB
