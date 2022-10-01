local CardTypes = {
    cycle = {
        new = function() return {
            name = "Grandfather Clock",
            action = function()
                for _=1,3 do
                    Deck.DrawCard(deck)
                end
             end
        } end
    },
    draw1 = {
        new = function() return {
            name = "Digital Watch",
            action = function()
                Deck.DrawCard(deck)
             end
        } end
    }
}

return CardTypes
