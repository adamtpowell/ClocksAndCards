local Inlay = {}

function Inlay.Create(inlay_type)
    local e = {
        pos = Pos.new(0, 0),
        inlay_type = inlay_type
    }
    u.addId(e)
    BB.addBB(e, 20, 20)
    return e
end

function Inlay.Update(e)
end

function Inlay.Draw(e)
    u.drawBB(e)
    love.graphics.print(e.inlay_type.name, e.pos.x, e.pos.y)
end

function Inlay.Activate(e, inlay_slot)
    e.inlay_type.action(inlay_slot, e)
end



return Inlay
