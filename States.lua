
local States = {
    instructions = {
        entry = function(arguments) return {
            init = function()

            end,
            update = function()

            end,
            draw = function()

            end
        } end
    },
    level = {
        entry = function(arguments) return {
            init = function()

            end,
            update = function()

            end,
            draw = function()

            end
        } end
    },
}

function States.Switch(state_name, arguments) -- arguments is a list
    game_state = States[state_name].entry(arguments)

end

return States
