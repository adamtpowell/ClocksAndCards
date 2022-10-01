local Pos = require "Pos"
local BB  = require "BB"
local Hand = {}

local handWidth = 250

function Hand.Create(pos)
    local e = u.addId({
        pos = pos,
        card_ids = {},
    })
    return BB.addBB(e, 250, 60)
end

function Hand.Update(e)
    for i, card_id in ipairs(e.card_ids) do
        local card = u.withId(cards, card_id)
        -- This is wrong but will do for now
        local offsetPos =  Pos.new(5 + (i - 1) * 60, 0)--Pos.new(e.pos.x - handWidth + (i * (handWidth / #e.card_ids)), e.pos.y)
        card.pos = Pos.add(e.pos, offsetPos)
    end
end

function Hand.GrabCard(e, card)
    table.insert(e.card_ids, card.id)
end

function Hand.DropCard(e, card)
    table.remove(
        e.card_ids,
        u.indexWhere(e.card_ids, function(id)
            return id == card.id
        end))
end
function Hand.Draw(e)
    if debug == true then
        u.debugRect(e.pos.x, e.pos.y, e.bb.width, e.bb.height)
    end
end

return Hand
