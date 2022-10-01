
local function placeInlay(inlay_type)
    local slot = InlaySlot.HoveredSlot()
    if slot ~= nil then
        if #slot.inlay_ids >= MAX_INLAYS then
            TextParticle.Create(Pos.mousePos(), "This number is full!")
            return false
        end
        local inlay = Inlay.Create(inlay_type.new())
        table.insert(inlays, inlay)
        InlaySlot.GetInlay(slot, inlay)
        return true
    else
        return false
    end
end



local CardTypes = {
    cycle = {
        new = function() return {
            name = "Pendulum",
            desc = "Draw three cards instantly.",
            action = function()
                Deck.DrawCard(deck)
                Deck.DrawCard(deck)
                Deck.DrawCard(deck)

                return true
             end,
             price = 400
        } end
    },
    gearpile = {
        new = function() return {
            name = "Gear Pile",
            desc = "Play anywhere for 250 gears.",
            action = function(card)
                u.addGears(250, card.pos)

                return true
             end,
             price = 0
        } end
    },
    winding_key = {
        new = function() return {
            name = "Winding Key",
            desc = "Play on a number to activate all inlays at that number.",
            action = function()
                local slot = InlaySlot.HoveredSlot()
                if slot == nil then
                    return false -- Don't activate if not hovering a slot.
                end
                InlaySlot.Activate(slot)
                return true
             end,
             price = 300
        } end
    },
    wheel = {
        new = function() return {
            name = "Wheel",
            desc = "Activate all inlays which are alone on their number.",
            action = function()
                for i, slot in ipairs(inlay_slots) do
                    if #slot.inlay_ids == 1 then
                        InlaySlot.Activate(slot)
                    end
                end
                return true
             end,
             price = 400
        } end
    },
    makeBridge = {
        new = function() return {
            name = "Bridge",
            desc = "Make a bridge which makes 150 gears, and also draws a card if both adjacent numbers have inlays.",
            action = function()
                return placeInlay(InlayTypes.clock)
             end,
             price = 300
        } end
    },
    makeFangs = {
        new = function() return {
            name = "Fangs",
            desc = "Reduces maximum hand size by 1. Draw two cards when activated.",
            action = function()
                return placeInlay(InlayTypes.clock)
             end,
             price = 600
        } end
    },
    screwdriver = {
        new = function() return {
            name = "Screwdriver",
            desc = "Play on an inlay to transform it bcak to a (free) card, then draw another card",
            action = function()
                print(#inlays)
                local i, inlay = BB.getHoveredFromArray(inlays)

                if inlay == nil then
                    return false
                end

                table.remove(inlays, i)

                local conjured_card = Card.Create(Pos.mousePos(), inlay.inlay_type.card_type.new())
                conjured_card.card_type.price = 0
                table.insert(cards, conjured_card)
                Hand.GrabCard(hand, conjured_card)


                u.forEach(inlay_slots, function (slot)
                    for i, id in ipairs(slot.inlay_ids) do
                        if id == inlay.id then
                            table.remove(slot.inlay_ids, i)
                            return
                        end
                    end
                end)

                Deck.DrawCard(deck)

                return true
             end,
             price = 200
        } end
    },
    makeClock = {
        new = function() return {
            name = "Clock",
            desc = "Place a clock inlay which draws one card when activated.",
            action = function()
                return placeInlay(InlayTypes.clock)
             end,
             price = 600
        } end
    },
    makeFactory = {
        new = function() return {
            name = "Factory",
            desc = "Place a factory inlay which earns 200 gears when activated.",
            action = function()
                return placeInlay(InlayTypes.factory)
             end,
             price = 300
        } end,

    },
    makeSkyscraper = {
        new = function() return {
            name = "Skyscraper",
            desc= "Place a skyscraper inlay which earns 75 gears for each building on a number.",
            action = function()
                return placeInlay(InlayTypes.skyscraper)
             end,
             price = 300
        } end,

    },
    makeTrashcan = {
        new = function() return {
            name = "Trashcan",
            desc= "Place a trashcan which you can use to recycle unwanted cards.",
            action = function()
                return placeInlay(InlayTypes.trashcan)
             end,
             price = 150
        } end,

    }
}

return CardTypes
