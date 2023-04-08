wind = {}
-- Add wind state variables
  player.windState = false
  player.windPlatform = nil

function wind.windupdate(dt)
-- Toggle wind state
-- function love.keypressed(key) 
--         if key =='2' then
--             player.windState = not player.windState
--             if player.windState then
--                 print("Entered wind state")
--             else
--                 print("Exited wind state")
--             end
--         end
--     end
        -- Wind state
        if player.windState then
            local px, py = player:getPosition()
            if love.mouse.isDown('1') then
                if not player.windPlatform then
                    local mouseX, mouseY = love.mouse.getPosition()
                    player.windPlatform = world:newRectangleCollider(mouseX, mouseY, 200, 10, {collision_class = "Platform"})
                    player.windPlatform:setType("static")
                end
            else
                if player.windPlatform then
                    player.windPlatform:destroy()
                    player.windPlatform = nil
                end
            end
            if player.windPlatform and player.grounded and math.abs(py - player.windPlatform:getY()) < 10 and math.abs(px - player.windPlatform:getX()) < 100 then
                player:applyLinearImpulse(0, -5000)
            end
        end
    end

return wind