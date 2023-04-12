function love.keypressed(key)
    local actions = {
        ['1'] = function() player.iceState = not player.iceState end,
        ['2'] = function() player.windState = not player.windState end,
        ['3'] = function()
            player.iceState = not player.iceState
            player.windState = not player.windState
        end,
        ['4'] = function() player.waterState = not player.waterState end,
        ['5'] = function() player.steelState = not player.steelState end,
        ['6'] = function() player.bulletstate = not player.bulletstate end,
        ['p'] = function() enemy.spawnenemy() end,
        ['y'] = function() player:applyLinearImpulse(2000 * player.direction, 100) end,
        -- ['j'] = function() player.isslashing = true end,
        ['k'] = function() player.mattacking2 = true end,
        ['l'] = function() player.mattacking3 = true end,
        ['u'] = function() player.mattacking4 = true end,
        ['i'] = function() player.mattacking5 = true end,
        ['o'] = function() player.mattacking6 = true end,
        ['c'] = function() camera = 'static' end,
        ['v'] = function() camera = 'dynamic' end,
        [']'] = function() visibleworld = true end,
        ['['] = function() visibleworld = false end,
        [';'] = function() debugger = true end,
        ['/'] = function() debugger = false end,
        ['n'] = function() player.hook.manualControl = false end,
        ['m'] = function() player.hook.manualControl = true end,
        ['escape'] = function() love.event.quit('restart') end,
    }

    if actions[key] then
        actions[key]()
    end
end
