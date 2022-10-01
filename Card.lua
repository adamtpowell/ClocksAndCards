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
end

return Card
