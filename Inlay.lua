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
end

function Inlay.Activate(e)
    e.inlay_type.action()
end



return Inlay
