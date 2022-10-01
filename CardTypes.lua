
local function placeInlay(inlay_type)
    local slot = InlaySlot.HoveredSlot()
    if slot ~= nil then
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
    },
    makeTestInlay = {
        new = function() return {
            name = "Inlay Maker",
            action = function()
                placeInlay(InlayTypes.cycle)
             end
        } end
    }
}

return CardTypes
