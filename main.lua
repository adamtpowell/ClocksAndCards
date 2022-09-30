local terebi = require "lib.terebi" -- Screen scaling
local baton = require "lib.baton" -- Input
local bitser = require "lib.bitser" -- Serialization

------ INITIALIZATION ------

function love.load()
    terebi.initializeLoveDefaults()

    screen = terebi.newScreen(320, 240, 2)
        :setBackgroundColor(0.25, 0.25, 0.25)

    input = baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action_z = {'key:z', 'button:a'},
            action_x = {'key:x', 'button:b'},
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }
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
