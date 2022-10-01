local Card = require("Card")
local Hand = require("Hand")
local Pos = require("Pos")

local Deck = {}

function Deck.Create(pos)
    local e = {
        pos = pos,
        card_types = { CardTypes.cycle, CardTypes.draw1, CardTypes.draw1 }
    }
    u.addId(e)
    BB.addBB(e, CARD_WIDTH, CARD_HEIGHT)
    return e
end

function Deck.Update(e)
end

function Deck.DrawCard(e)
    local card_type = love.math.random( 1, #e.card_types )
    local new_card = Card.Create(e.pos, e.card_types[card_type].new())
    table.insert(cards, new_card)
    Hand.GrabCard(hand, new_card)
end

function Deck.Draw(e)
    u.drawBB(e)
end

return Deck
