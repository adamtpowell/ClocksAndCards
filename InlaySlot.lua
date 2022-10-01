local InlaySlot = {}

function InlaySlot.Create(pos)
    local e = {
        number = -1,
        inlay_ids = {},
        pos = Pos.copy(pos),
        angle = 0,
    }
    u.addId(e)
    Pos.addPos(e, pos)
    return e
end

function InlaySlot.Update(e)
    u.forEach(u.withIds(inlays, e.inlay_ids), function(inlay, i)
        local from_center = Pos.vectorDirection(e.angle, CLOCK_RADIUS - i * 30)
        inlay.pos = Pos.add(Pos.add(clock_center, from_center), Pos.new(-10, -10)) -- Move the inlay to the inlay slots position
    end)
end

function InlaySlot.Draw(e)
    love.graphics.rectangle("line", e.pos.x - 25, e.pos.y - 25, 50, 50)
    love.graphics.print(e.number, math.floor(e.pos.x), math.floor(e.pos.y))
end

function InlaySlot.Activate(e)

end

return InlaySlot
