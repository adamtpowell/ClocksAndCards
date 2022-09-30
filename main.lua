local terebi = require "lib.terebi" -- Screen scaling
local baton = require "lib.baton" -- Input
local bitset = require "lib.bitser" -- Serialization

------ INITIALIZATION ------

function love.load()
    terebi.initializeLoveDefaults()

    screen = terebi.newScreen(320, 240, 2)
        :setBackgroundColor(0.25, 0.25, 0.25)
end

------ UPDATES ------

function love.update()

end

------ DRAWING ------

local function terebiDraw()

end

function love.draw()
    screen:draw(terebiDraw)
end
