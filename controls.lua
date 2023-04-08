local controls = {}
buttons = require('buttons')
platform = require('platform')
local updateDash = require("dash")

local hook = require("hook") -- make sure this line is at the beginning of the file
player.hook = hook.new(px, py) -- create a new hook instance for the player
player.velocityX = 0
local vector = require("vector")
local slashTimer = 0

-- Define target speed and set acceleration
local baseSpeed = 200
local targetSpeed = 0
local acceleration = 1500 -- Increased acceleration for snappier movement
local deceleration = 3000 -- Increased deceleration for snappier stops


healthBarWidth = 200
healthBarHeight = 20
healthBarX = 10
healthBarY = 10
healthBarBorder = 2
damage = 10 -- Damage taken per frame when hit
healthRegen = 0.5 -- Health regenerated per frame

player.maxHealth = 100
player.currentHealth = 100



function controls.controlsupdate(dt)
    -- Grounded and moving set state
    local isMoving = false
    player.groundedPrev = player.grounded or false
    player.groundedPrev = updateDash(player, dt, player.groundedPrev)
    -- Walking
    local speedMultiplier = 1
    if love.keyboard.isDown('d') then
        isMoving = true
        player.iswalking = true
        player.direction = 1
        speedMultiplier = 1
    elseif love.keyboard.isDown('a') then
        isMoving = true
        player.iswalking = true
        player.direction = -1
        speedMultiplier = 1
    else
        player.iswalking = false
    end

    -- Running
    if love.keyboard.isDown('e') then
        isMoving = true
        player.iswalking = false
        player.isrunning = true
        player.direction = 1
        speedMultiplier = 3
    elseif love.keyboard.isDown('q') then
        isMoving = true
        player.iswalking = false
        player.isrunning = true
        player.direction = -1
        speedMultiplier = 3
    else
        player.isrunning = false
    end

    -- Calculate target speed
    targetSpeed = player.direction * player.baseSpeed * speedMultiplier

    -- Apply acceleration
    local currentSpeed = player.velocityX
    if math.abs(targetSpeed - currentSpeed) > 0.01 then
        local direction = (targetSpeed - currentSpeed) / math.abs(targetSpeed - currentSpeed)
        local newSpeed = currentSpeed + direction * acceleration * dt

        -- Avoid overshooting the target speed
        if direction == 1 and newSpeed > targetSpeed or direction == -1 and newSpeed < targetSpeed then
            newSpeed = targetSpeed
        end

        player.velocityX = newSpeed
    else
        player.velocityX = targetSpeed
    end

    -- Apply deceleration when not moving
    if not isMoving then
        if player.velocityX > 0 then
            player.velocityX = math.max(0, player.velocityX - deceleration * dt)
        elseif player.velocityX < 0 then
            player.velocityX = math.min(0, player.velocityX + deceleration * dt)
        end
    end

    -- Update player position
    player:setX(px + player.velocityX * dt)

    -- Fall
    if love.keyboard.isDown('s') then
        if player.grounded then -- if there is a collider below the player
            player.isspinning = true
            down_sound:play()
        else
            player.isbouncing = true
            player.isjumping = false
    end
else
    player.isspinning = false
    player.isbouncing = false
end

-- Jump
function jump()
    if love.keyboard.isDown('space') then
        if player.grounded then
            player:applyLinearImpulse(0, -player.jumpForce)
            player.iswalking = false
            player.isrunning = false
            player.iskicking = false
            player.issurfing = false
            player.isteleporting = false
            player.isfalling = false
            player.isjumping = true
            jump_sound:play()
            player.jumpcount = 1
            player.grounded = false
        elseif player.isjumping and player.jumpcount < player.maxjumps and not player.spaceDown then
            player.jumpcount  = player.jumpcount + 1
            player:setLinearVelocity(player:getLinearVelocity(), 0) -- Reset vertical velocity
            player:applyLinearImpulse(0, -player.jumpForce)
            jump_sound:play()
            player.spaceDown = true
        end
    else
        player.spaceDown = false
    end
end



if love.keyboard.isDown('r') and not player.hook.active then
    hook.fire(player.hook, px, py, mx, my)
    player.hook.active = true
elseif love.keyboard.isDown('t') and player.hook.active then
    hook.detach(player.hook)
    player.hook.active = false
end
jump()
hook.update(player.hook, dt, player)

if player.hook.active and player.steelState == true then
    local hookDirection = vector(player.hook.position.x - px, player.hook.position.y - py):normalized()
    local pullForce = 1500 -- Adjust the pulling force as needed
    local newVelocityX = hookDirection.x * pullForce * dt
    local newVelocityY = hookDirection.y * pullForce * dt

    -- Get the existing player velocity
    local currentVelocityX, currentVelocityY = player:getLinearVelocity()

    -- Combine the new velocity with the existing player velocity
    local combinedVelocityX = currentVelocityX + newVelocityX
    local combinedVelocityY = currentVelocityY + newVelocityY

    player:setLinearVelocity(combinedVelocityX, combinedVelocityY)
end

-- Boost
if love.keyboard.isDown('lshift') then
    if player.grounded then --if there is a collider below the player
        player.isSwinging = not player.isSwinging
        player:applyLinearImpulse(player.direction * player.boostForce , 0) -- Apply kick force in the direction player is facing
        boost_sound:play()
    else
        player.iskicking = false
        player.iswalking = false
        player.isrunning = false
        player.isboosting = false
        player.issurfing = false
        player.isteleporting = false
        player.isfalling = false
    end
end


-- Animations update
if player.grounded then
    if vy < 20 and vy > -20 then
        if player.iswalking then
            player.animation = animations.walk
        elseif player.isrunning then
            player.animation = animations.run
        elseif player.iskicking then
            player.animation = animations.kick
        elseif player.issurfing then
            player.animation = animations.surf
        elseif player.isspinning then
            player.animation = animations.spin
        elseif player.isteleporting then
            player.animation = animations.teleport
        elseif player.iskicking then
            player.animation = animations.kick
        elseif player.isboosting then
            player.animation = animations.boost
        elseif player.isslashing then
            player.animation = animations.slash
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.fall
    end
elseif not player.grounded then
    if player.isDashing then
            player.animation = animations.dash
    
    elseif player.isjumping then
        player.animation = animations.jump
    else
        player.animation = animations.fall
        player:setLinearVelocity(0, 1000)
    end
end

  if slashTimer > 0 then
        slashTimer = slashTimer - dt
        if slashTimer <= 0 then
            player.isslashing = false
        end
    end
updateDash(player, dt)
checkWallCollision()
if player.isWallRunning and love.keyboard.isDown('w') then
        player:applyForce(0, -1200) -- Apply an upward force while wall running
    end

 function takeDamage(damageAmount)
        player.currentHealth = math.max(0, player.currentHealth - damageAmount)
    end

    -- Test damage by pressing 'h'
    if love.keyboard.isDown('h') then
        takeDamage(damage * dt)
    end
if player.currentHealth < player.maxHealth then
        player.currentHealth = math.min(player.currentHealth + healthRegen * dt, player.maxHealth)
    end
end


function controls.controls_render()
hook.draw(player.hook)
love.mouse.setVisible(false)
love.graphics.draw(cursorImage,mx, my)
   -- Draw health bar background
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", healthBarX, healthBarY, healthBarWidth + healthBarBorder * 2, healthBarHeight + healthBarBorder * 2)

    -- Draw health bar
    local healthPercentage = player.currentHealth / player.maxHealth
    love.graphics.setColor(1 - healthPercentage, healthPercentage, 0, 1)
    love.graphics.rectangle("fill", healthBarX + healthBarBorder, healthBarY + healthBarBorder, healthBarWidth * healthPercentage, healthBarHeight)
   -- Draw health number inside the health bar
    love.graphics.setColor(1, 1, 1, 1) -- Set text color to white
    love.graphics.setFont(love.graphics.newFont(16)) -- Set font size (adjust size as needed)
    local healthText = string.format("%d / %d", math.floor(player.currentHealth), player.maxHealth)
    local healthTextWidth = love.graphics.getFont():getWidth(healthText)
    local healthTextHeight = love.graphics.getFont():getHeight(healthText)
    local healthTextX = healthBarX + (healthBarWidth - healthTextWidth) / 2 + healthBarBorder
    local healthTextY = healthBarY + (healthBarHeight - healthTextHeight) / 2 + healthBarBorder
    love.graphics.print(healthText, healthTextX, healthTextY)

  
end

function checkWallCollision()
     local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + player.height, player.width, 2, {'Wall'})
    player.isWallRunning = false
    player.wallDirection = 0

    for _, collider in ipairs(colliders) do
        if collider.collision_class == 'Wall' then
            player.isWallRunning = true
            if collider:getX() < player:getX() then
                player.wallDirection = 1 -- Left wall
            else
                player.wallDirection = -1 -- Right wall
            end
            break
        end
    end
end

return controls




