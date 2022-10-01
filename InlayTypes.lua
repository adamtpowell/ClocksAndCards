local InlayTypes = {
    clock = {
        new = function() return {
            name = "Grandfather Clock",
            action = function()
                for _=1,1 do
                    Deck.DrawCard(deck)
                end
            end,
            card_type = CardTypes.makeClock,
        } end
    },
    factory = {
        new = function() return {
            name = "Factory",
            action = function(_, inlay)
                u.addGears(200, inlay.pos)
             end,
             card_type = CardTypes.makeFactory,
        } end
    },
    skyscraper = {
        new = function() return {
            name = "Skyscraper",
            action = function(inlay_slot, inlay)
                local num_buildings = #inlay_slot.inlay_ids
                u.addGears(num_buildings * 75, inlay.pos)
             end,
             card_type = CardTypes.makeSkyscraper,
        } end
    },
    trashcan = {
        new = function() return {
            name = "Trashcan",
            desc = "Any card played on trashcan is recycled.",
            action = function(inlay_slot)
            end
        } end
    }
}

return InlayTypes
