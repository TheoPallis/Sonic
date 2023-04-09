function love.keypressed(key) 
    if key == '1' then
        player.iceState = not player.iceState
    elseif key =='2' then
        player.windState = not player.windState
     elseif key == '3' then
        player.iceState = not player.iceState
        player.windState = not player.windState
    elseif key == '4' then
        player.waterState = not player.waterState
    elseif key == '5' then
        player.steelState = not player.steelState
    elseif key == '6' then 
        player.bulletstate = not player.bulletstate

    elseif key == 'o' then
        enemy.spawnenemy()
    elseif key == 'i' then
        player:applyLinearImpulse(2000 * player.direction, 100)
    elseif key == 'j' then
        player.isslashing = true
    elseif key =='c' then
        camera = 'static'
    elseif key == 'v' then
        camera = 'dynamic'
    elseif key == ']' then
        visibleworld = true
    elseif key == '[' then
        visibleworld = false
    elseif key == ';' then
        debugger = true
    elseif key == '/' then
        debugger = false
    elseif key == 'u' then
        player.hook.manualControl = false
    elseif key == 'i' then
        player.hook.manualControl = true
    elseif key == 'escape' then
        love.event.quit('restart')
    end

    end