-- Add fire state variables
-- player.fireState = false
player.fireDashSpeed = 500
player.fireDashDuration = 0.3
player.fireDashTimer = 0
player.forceMeter = 0
-- firesheet = love.graphics.newImage("sprite/tsheet_fire.png")


function fireupdate(dt)
--         -- Toggle fire state
 if love.keyboard.isDown("k") then
      player.forceMeter = math.min(player.forceMeter + dt, 2) -- You can adjust the maximum force value
    elseif player.forceMeter > 0 then
        local mouseX, mouseY = love.mouse.getPosition()
        local px,py = player:getPosition()
        local dx, dy = mouseX - px, mouseY - py
        local magnitude = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / magnitude, dy / magnitude
        local force = player.forceMeter * 500 -- Adjust the multiplier for desired force amount
        px, py = px + dx * force * dt, py + dy * force * dt
        player.forceMeter = 0
    end
end



