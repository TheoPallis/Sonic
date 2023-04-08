local canDash = true
local dashTimer = 0

local function updateDash(player, dt, groundedPrev)
    local dashDuration = 0.15 -- Duration of the dash in seconds
    local dashSpeed = 500 -- Speed of the dash

    -- Dash
    if love.keyboard.isDown('x') and canDash and not player.isDashing then
        player.isDashing = true
        canDash = false
        dashTimer = dashDuration
        local dashDirection = player.direction
        local currentVelocityX, currentVelocityY = player:getLinearVelocity()
        player:setLinearVelocity(dashSpeed * dashDirection, currentVelocityY)
    end

    if player.grounded and not groundedPrev then
        local _, currentVelocityY = player:getLinearVelocity()
        player:setLinearVelocity(0, currentVelocityY)
    end

    if dashTimer > 0 then
        dashTimer = dashTimer - dt
        if dashTimer <= 0 then
            player.isDashing = false
            if player.grounded then
                local _, currentVelocityY = player:getLinearVelocity()
                player:setLinearVelocity(0, currentVelocityY)
            end
        end
    end

    -- Reset the canDash flag when the player is grounded
    if player.grounded then
        canDash = true
    end

    return player.grounded
end

return updateDash
