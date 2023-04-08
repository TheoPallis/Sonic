water = {}
    
function water.waterupdate(dt)
    if player.waterState then
        if love.mouse.isDown('1') then
            player.hydroPumpForce = player.hydroPumpForce + dt * 1000
            player:applyLinearImpulse(-player.direction * player.hydroPumpForce, 0)
            player.hydroPumpForce = 0
        end
    end
end
return water