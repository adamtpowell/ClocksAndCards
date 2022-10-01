local Pos = require "Pos"
local u = require "u"
local Cursor = {}

function Cursor.Create(pos)
    return u.addId({
        holding_id = -1,
        pos = Pos.mousePos()
    })
end

function Cursor.Update(e)
    e.pos = Pos.mousePos()

    -- Move the card to the mouse
    local held_card = u.withId(cards, e.holding_id)
    if held_card ~= nil then
        held_card.pos = Pos.add(e.pos, Pos.new(-held_card.bb.width / 2, -held_card.bb.height / 2))
    end
end

function Cursor.Draw(e)
    if debug then
        u.debugRect(e.pos.x, e.pos.y, 10, 10)
    end
end

function Cursor.GrabCard(e, card)
    e.holding_id = card.id
end

function Cursor.DropCard(e)
    e.holding_id =-1
end

function Cursor.HoldingCard(e)
    return e.holding_id ~= -1
end

return Cursor
