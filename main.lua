local terebi = require "lib.terebi" -- Screen scaling
local baton = require "lib.baton" -- Input
bitser = require "lib.bitser" -- Serialization
Cursor = require "Cursor"
Hand   = require "Hand"
BB     = require "BB"
Pos = require "Pos"
Card = require "Card"
u = require "u"
Deck = require "Deck"
CardTypes = require "CardTypes"
InlaySlot = require "InlaySlot"
Inlay = require "Inlay"

debug = false

silkscreen = love.graphics.newFont( "Silkscreen-Regular.ttf", 8, "none")
love.graphics.setFont(silkscreen)

CARD_WIDTH = 100
CARD_HEIGHT = 40

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768

CLOCK_RADIUS = 300

left_down = false

------ INITIALIZATION ------

function love.load()
    terebi.initializeLoveDefaults()

    screen = terebi.newScreen(1024, 768, 3)
        :setBackgroundColor(0.25, 0.25, 0.25)

    cards = { }

    cursor = Cursor.Create()
    cursor.holding_id = -1

    hand = Hand.Create(Pos.new(220, 700))
    hand.card_ids = { }

    deck = Deck.Create(Pos.new(540, 700))

    time = 0
    total_time = 0

    for i = 1, 1 do
        Deck.DrawCard(deck)
    end

    clock_center = Pos.new(SCREEN_HEIGHT / 2, SCREEN_HEIGHT / 2 - 50)

    inlay_slots = {}
    inlay_slot_index = 1
    for i = 1, 6 do
        local dir = ((1 / 6) * (i - 1)) - 0.25
        local slot = InlaySlot.Create(
            Pos.add(Pos.vectorDirection(dir, CLOCK_RADIUS - 25),
            clock_center
        ))
        slot.number = i
        slot.angle = dir
        table.insert(inlay_slots, slot)
    end

    inlays = { }
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[3].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[3].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    local new_inlay = Inlay.Create()
    table.insert(inlay_slots[3].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
end

------ UPDATES ------

function love.update(dt)
    if love.mouse.isDown(1) then
        if left_down == false then
            left_pressed = true
        end
        left_down = true
    else
        left_down = false
    end

    Cursor.Update(cursor)
    Hand.Update(hand)

    time = time + dt
    total_time = total_time + dt

    if time > 10 then
        time = time - 10
        inlay_slot_index = inlay_slot_index + 1
        if inlay_slot_index > 6 then
            inlay_slot_index = 1
        end
        InlaySlot.Activate(inlay_slots[inlay_slot_index])
    end

    if total_time > 60 then
        total_time = total_time - 60
    end

    u.forEach(cards, Card.Update)

    u.forEach(inlay_slots, InlaySlot.Update)

    if left_pressed then
        mouse_press()
    end

    left_pressed = false
end

function mouse_press()
    local pos = Pos.mousePos()
    for i, card in ipairs(cards) do
        if BB.collidesWithPoint(card, pos) and not Cursor.HoldingCard(cursor) then
            Cursor.GrabCard(cursor, card)
            Hand.DropCard(hand, card)
            return
        end
    end

    if BB.collidesWithPoint(hand, pos) and Cursor.HoldingCard(cursor) then
        Hand.GrabCard(hand, u.withId(cards, cursor.holding_id))
        Cursor.DropCard(cursor)
        return
    end

    if Cursor.HoldingCard(cursor) then
        local played_card = u.withId(cards, cursor.holding_id)

        -- Its not in cards, but its in card ids
        u.removeWithId(cards, cursor.holding_id)
        Cursor.DropCard(cursor)

       played_card.card_type.action()
    end
end

------ DRAWING ------

local function terebiDraw()
    love.graphics.circle("line", clock_center.x, clock_center.y, CLOCK_RADIUS)
    love.graphics.line(
        clock_center.x,
        clock_center.y,
        clock_center.x + (math.cos((total_time / 60) * math.pi * 2 - math.pi / 2) * CLOCK_RADIUS),
        clock_center.y + (math.sin((total_time / 60) * math.pi * 2 - math.pi / 2) * CLOCK_RADIUS)
    )
    Cursor.Draw(cursor)
    Hand.Draw(hand)
    Deck.Draw(deck)
    u.forEach(cards, Card.Draw)
    u.forEach(inlay_slots, InlaySlot.Draw)
    u.forEach(inlays, Inlay.Draw)
end

function love.draw()
    screen:draw(terebiDraw)
end
