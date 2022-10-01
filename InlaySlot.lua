local InlaySlot = {}

function InlaySlot.Create(pos)
    local e = {
        number = -1,
        inlay_ids = {},
        pos = Pos.copy(pos),
        angle = 0,
    }
    u.addId(e)
    Pos.addPos(e, Pos.add(pos, Pos.new(-25, -25)))
    BB.addBB(e, 50, 50)
    return e
end

function InlaySlot.Update(e)
    u.forEach(u.withIds(inlays, e.inlay_ids), function(inlay, i)
        local from_center = Pos.vectorDirection(e.angle, CLOCK_RADIUS - i * 30)
        inlay.pos = Pos.add(Pos.add(clock_center, from_center), Pos.new(-10, -10)) -- Move the inlay to the inlay slots position
    end)
end

function InlaySlot.Draw(e)
    u.drawBB(e)
    love.graphics.print(e.number, math.floor(e.pos.x), math.floor(e.pos.y))
end

function InlaySlot.Activate(e)
    u.forEach(u.withIds(inlays, e.inlay_ids), Inlay.Activate)
end

function InlaySlot.GetInlay(e, inlay)
    table.insert(e.inlay_ids, inlay.id)
end

function InlaySlot.HoveredSlot()
    local mouse_pos = Pos.mousePos()
    return u.forEach(inlay_slots, function(slot)
        if BB.collidesWithPoint(slot, mouse_pos) then
            print("COLLIDED")
            return slot
        end
    end)
end

return InlaySlot
