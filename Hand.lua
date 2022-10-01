local Pos = require "Pos"
local BB  = require "BB"
local Hand = {}

local CARD_DISTANCE = 20

function Hand.Create(pos)
    local e = u.addId({
        pos = pos,
        card_ids = {},
    })
    return BB.addBB(e, 250, 60)
end

function Hand.Update(e)
    local j = 0
    for i, card_id in ipairs(e.card_ids) do
        j = j + 1
        local card_distance = CARD_WIDTH + CARD_DISTANCE

        local offsetx = (card_distance * (j - 1)) - ((#e.card_ids - 1) * card_distance) / 2
        local offsetPos = Pos.new(offsetx - CARD_WIDTH / 2, 0)

        local card = u.withId(cards, card_id)
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
