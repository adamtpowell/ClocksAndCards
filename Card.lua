local Pos = require "Pos"
local u = require "u"
local BB = require "BB"

local Card = {}

-- Updates card position. Card position is set by other things.
-- Card prototype is the type of the card.
function Card.Create(pos, card_prototype)
    local new = {
        card_type = card_prototype,
        pos = pos,
        draw_pos = pos,
    }
    BB.addBB(new, CARD_WIDTH, CARD_HEIGHT)
    return u.addId(new)
end

function Card.Update(e)
    e.draw_pos = Pos.lerp(e.draw_pos, e.pos, 0.2)
end

function Card.Draw(e)
    u.debugRect(e.draw_pos.x, e.draw_pos.y, e.bb.width, e.bb.height)
    love.graphics.print(e.card_type.name, math.floor(e.draw_pos.x), math.floor(e.draw_pos.y))
    love.graphics.print(e.card_type.price, math.floor(e.draw_pos.x), math.floor(e.draw_pos.y + 12))
end

function Card.Recycle(id, trash)
    -- Remove card from existence.
    u.removeWithId(cards, id)
    Cursor.DropCard(cursor)

    if love.math.random(1,3) > 1 then
        u.drawCards(1, trash.pos)
    else
        u.addGears(150, trash.pos)
    end
end

function Card.Activate(e)
    played = nil
    if gears >= e.card_type.price then
        played = e.card_type.action(e)
    end

    if played then
        gears = gears - e.card_type.price
        -- Remove from cards list and drop from cursor.
        u.removeWithId(cards, cursor.holding_id)
        Cursor.DropCard(cursor)
    end
end

return Card
