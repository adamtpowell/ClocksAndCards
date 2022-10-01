local InlayTypes = {
    cycle = {
        new = function() return {
            name = "Grandfather Clock",
            action = function()
                for _=1,1 do
                    Deck.DrawCard(deck)
                end
             end
        } end
    }
}

return InlayTypes
