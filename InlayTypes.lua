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
            end,
            card_type = CardTypes.makeTrashcan,
        } end
    },
    fangs = {
        new = function() return {
            name = "Fangs",
            desc = "When activated, discard your hand and draw that many cards.",
            action = function(inlay_slot, e)
                local num_cards = #hand.card_ids
                for k in pairs (hand.card_ids) do
                    local card_index = u.indexWithId(cards, hand.card_ids[k])
                    hand.card_ids[k] = nil
                    table.remove(cards, card_index)
                end

                for i=1,num_cards do
                    u.drawCards(num_cards, e.pos)
                end
            end,
            card_type = CardTypes.makeFangs,
        } end
    },
    bridge = {
        new = function() return {
            name = "Bridge",
            desc = "Adds 100 gears. If both adjacent numbers have inlays, draw a card as well.",
            action = function(inlay_slot, e)
                local i = inlay_slot.number
                local iminus1 = inlay_slot.number - 1
                local iplus1 = inlay_slot.number + 1

                if iminus1 < 1 then iminus1 = 6 end
                if iplus1 > 6 then iplus1 = 1 end

                local last = inlay_slots[iminus1]
                local next = inlay_slots[iplus1]

                u.addGears(100, e.pos)

                if #last.inlay_ids > 0 and #next.inlay_ids > 0 and #inlay_slot.inlay_ids > 0 then
                    u.drawCards(1, e.pos)
                end
            end,
            card_type = CardTypes.makeTrashcan,
        } end
    }
}

return InlayTypes
