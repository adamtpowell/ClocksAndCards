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
InlayTypes = require "InlayTypes"
TextParticle = require "TextParticle"
States = require "States"

debug = false

silkscreen = love.graphics.newFont( "Silkscreen-Regular.ttf", 8, "none")
love.graphics.setFont(silkscreen)

clockface_font = love.graphics.newFont( "Silkscreen-Regular.ttf", 24, "none")

CARD_WIDTH = 65
CARD_HEIGHT = 40

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768

CLOCK_RADIUS = 300

ROUND_LENGTH = 5 * 60

HAND_SIZE = 5

MAX_INLAYS = 5

left_down = false

hour_hand_time = 0
------ INITIALIZATION ------

function love.load()
    terebi.initializeLoveDefaults()

    screen = terebi.newScreen(1024, 768, 3)
        :setBackgroundColor(0.25, 0.25, 0.25)

    cards = { }

    cursor = Cursor.Create()
    cursor.holding_id = -1

    deck = Deck.Create(Pos.new(SCREEN_WIDTH - CARD_WIDTH - 40, 700))

    time = 0
    total_time = 0

    States.Switch("instructions")

    clock_center = Pos.new(SCREEN_HEIGHT / 2, SCREEN_HEIGHT / 2 - 50)

    hand = Hand.Create(Pos.new(clock_center.x, 700))
    hand.card_ids = { }

    for i = 1, 3 do
        Deck.DrawCard(deck)
    end

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

    -- Create the initial inlay for drawing cards at noon
    local new_inlay = Inlay.Create(InlayTypes.clock.new())
    table.insert(inlay_slots[1].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)
    -- Create the initial inlay for drawing cards at anti noon
    local new_inlay = Inlay.Create(InlayTypes.clock.new())
    table.insert(inlay_slots[4].inlay_ids, new_inlay.id)
    table.insert(inlays, new_inlay)

    gears = 750

    text_particles = {}
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
    hour_hand_time = hour_hand_time + dt

    if time > 10 then
        time = time - 10
        inlay_slot_index = inlay_slot_index + 1
        if inlay_slot_index > 6 then
            inlay_slot_index = 1
        end
        InlaySlot.Activate(inlay_slots[inlay_slot_index])
        u.addGears(50, inlay_slots[inlay_slot_index].pos)
    end

    if total_time > 60 then
        total_time = total_time - 60
    end

    u.forEach(cards, Card.Update)

    u.forEach(inlay_slots, InlaySlot.Update)

    u.forEach(text_particles, TextParticle.Update)

    if left_pressed then
        mouse_press()
    end

    left_pressed = false
end

function mouse_press()
    local pos = Pos.mousePos()

    -- Pick up
    for i, card in ipairs(cards) do
        if BB.collidesWithPoint(card, pos) and not Cursor.HoldingCard(cursor) then
            Cursor.GrabCard(cursor, card)
            Hand.DropCard(hand, card)
            return
        end
    end

    -- Put a card back in the hand.
    if pos.y > 700 and Cursor.HoldingCard(cursor) then
        Hand.GrabCard(hand, u.withId(cards, cursor.holding_id))
        Cursor.DropCard(cursor)
        return
    end
    -- TODO: Add special case for playing onto the trashcan.

    if Cursor.HoldingCard(cursor) then

        local trash = nil
        for i, inlay in ipairs(inlays) do
            if inlay.inlay_type.name == "Trashcan" and BB.collidesWithPoint(inlay, pos) then
                trash = inlay
            end
        end

        if trash then
            Card.Recycle(cursor.holding_id, trash)
        else
            local played_card = u.withId(cards, cursor.holding_id)

            Card.Activate(played_card)
        end
    end
end

------ DRAWING ------

local function terebiDraw()
    love.graphics.circle("line", clock_center.x, clock_center.y, CLOCK_RADIUS)
    love.graphics.print(gears)
    love.graphics.line(
        clock_center.x,
        clock_center.y,
        clock_center.x + (math.cos((total_time / 60) * math.pi * 2 - math.pi / 2) * CLOCK_RADIUS),
        clock_center.y + (math.sin((total_time / 60) * math.pi * 2 - math.pi / 2) * CLOCK_RADIUS)
    )

    love.graphics.line(
        clock_center.x,
        clock_center.y,
        clock_center.x + (math.cos((hour_hand_time / ROUND_LENGTH) * math.pi * 2 - math.pi / 2) * (CLOCK_RADIUS / 2)),
        clock_center.y + (math.sin((hour_hand_time / ROUND_LENGTH) * math.pi * 2 - math.pi / 2) * (CLOCK_RADIUS / 2))
    )

    Cursor.Draw(cursor)
    Hand.Draw(hand)
    Deck.Draw(deck)
    u.forEach(cards, Card.Draw)
    u.forEach(inlay_slots, InlaySlot.Draw)
    u.forEach(inlays, Inlay.Draw)
    u.forEach(text_particles, TextParticle.Draw)
end

function love.draw()
    screen:draw(terebiDraw)
end
