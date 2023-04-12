        ice= {}
        -- Add ice state variables
        player.iceState = false
        player.iceDagger = nil
        player.iceDaggerProjectile = false
        player.iceDaggerSpeed = 600
        player.bulletSpeed = 700
        spritesheet = 'sprite/tsheet.png'
        iceDaggerImage = love.graphics.newImage('sprite/ice_dagger.png')
        cursorImage = love.graphics.newImage('sprite/cursor_ice.png')
        local projectiles = {}
        local fireRate = 3
        local mouseClicked = false
        knife  = love.audio.newSource('sounds/knife.mp3','static')
        bullet_fireRate = 0.4    -- The time between shots in seconds (0.2 means 5 shots per second)
        ice_fireRate = 0.1
        player.timeSinceLastShot = 0

        player.shootingAnimationProgress = 0
        player.shootingAnimationDuration = 0.3-- You can change this to match the duration of your shooting animation


        function fireProjectile(x, y)
            local dirX, dirY = x - px, y - py
            local length = math.sqrt(dirX * dirX + dirY * dirY)
            local projectile = {
                x = px,
                y = py,
                dirX = dirX / length,
                dirY = dirY / length
            }
            table.insert(projectiles, projectile)
            return projectile
        end


        if love.keyboard.isDown('8') then
            for _, projectile in ipairs(projectiles) do
            projectile.destroy()
        end
    end


        function updateProjectiles(dt)
            for _, projectile in ipairs(projectiles) do
                projectile.x = projectile.x + projectile.dirX * player.iceDaggerSpeed * dt
                projectile.y = projectile.y + projectile.dirY * player.iceDaggerSpeed * dt
            end
        end

        function drawProjectiles()
            for _, projectile in ipairs(projectiles) do
                local x, y = projectile.x, projectile.y
                if player.iceDagger then
                    x, y = player.iceDagger:getPosition()
                end
                love.graphics.draw(iceDaggerImage, x, y, 0, 1, 1, iceDaggerImage:getWidth() / 2, iceDaggerImage:getHeight() / 2)
            end
        end


        function onPlatformCollision()
            -- player.iceDaggerProjectile = false
            player.iceDagger:setLinearVelocity(0, 0) 
            player.iceDagger:setType("dynamic")
            knife_sound:play()
        end


        function projectileupdate(dt)
            if player.iceState and player.iceDagger then
                updateProjectiles(dt)
                player.iceDagger:setPosition(projectiles[#projectiles].x, projectiles[#projectiles].y)
            elseif player.iceState == false and player.iceDagger == false then
                updateProjectiles(dt)
                player.iceDagger:setPosition(projectiles[#projectiles].x, projectiles[#projectiles].y)
            end
            
            if player.iceDagger and love.keyboard.isDown('tab') then
                player.iceDagger:destroy()
                player.iceDagger = nil
                player.iceDaggerProjectile = false
            end
            
            if player.iceDagger and love.mouse.isDown(2) then
                iceDaggerX, iceDaggerY = player.iceDagger:getPosition()
                player:setPosition(iceDaggerX, iceDaggerY)
                player.iceDagger:destroy()
                player.iceDagger = nil
                player.iceDaggerProjectile = false
                player:setLinearVelocity(0,-100)
            end

          if player.isTeleporting then
                player.teleportProgress = player.teleportProgress + dt
                local t = player.teleportProgress
                local startX, startY = player:getPosition()
                local endX, endY = player.iceDagger:getPosition()
                local newX = startX + (endX - startX) * t
                local newY = startY + (endY - startY) * t
                player:setPosition(newX, newY)
                if t >= 1 then
                    player.isTeleporting = false
                    player.teleportProgress = 0
                    player.iceDagger:destroy()
                    player.iceDagger = nil
                    player.iceDaggerProjectile = false
                    player:setLinearVelocity(0, -100)
                end
            end
        end

function ice.iceDaggerupdate(dt)
    player.timeSinceLastShot = player.timeSinceLastShot + dt
    if player.iceState then
        
        if love.mouse.isDown(1) and not player.iceDagger and player.timeSinceLastShot >= ice_fireRate and player.shootingAnimationProgress == 0 then
            player.shootingAnimationProgress = dt
            player.isteleporting = true
            end

        if player.shootingAnimationProgress > 0 then
            player.shootingAnimationProgress = player.shootingAnimationProgress + dt 
            if player.shootingAnimationProgress >= player.shootingAnimationDuration then
                player.shootingAnimationProgress = 0                
                player.isteleporting = false
                local mouseX, mouseY = love.mouse.getPosition()
                local px, py = player:getPosition()
                local projectile = fireProjectile(mouseX, mouseY)
                player.iceDagger = world:newRectangleCollider(projectile.x, projectile.y, 60, 15, {collision_class = "IceDagger"})
                player.iceDaggerX, player.iceDaggerY = player.iceDagger:getPosition()
                player.iceDagger:setType("dynamic")
                player.iceDagger:setLinearVelocity((mouseX - px) * player.iceDaggerSpeed * dt, (mouseY - py) * player.iceDaggerSpeed * dt)
                player.iceDaggerProjectile = true
                knife:play()
            end
        end

        if player.iceDaggerProjectile == true then 
            projectileupdate(dt)
        end
                    
            elseif player.bulletstate == true then
                if love.mouse.isDown(1) and not player.iceDagger  and player.timeSinceLastShot >= bullet_fireRate then
                player.timeSinceLastShot = 0
                local mouseX, mouseY = love.mouse.getPosition()
                local px, py = player:getPosition()
                local projectile = fireProjectile(mouseX, mouseY)
                player.bullet = world:newRectangleCollider(projectile.x, projectile.y, 60, 15, {collision_class = "IceDagger"})
                player.bulletX, player.bulletY = player.bullet:getPosition()
                player.bullet:setType("dynamic")
                player.bullet:setLinearVelocity((mouseX - px) * player.bulletSpeed * dt, (mouseY - py) * player.bulletSpeed * dt)
                player.bulletProjectile = true
                player.isshooting = true
                knife:play()
                if player.bulletProjectile == true then 
                    projectileupdate(dt)
                    -- player:applyLinearImpulse(impulseX, impulseY)

                end
                else
                    player.isshooting = false
                
            end

            if player.iceDagger then
                if player.iceDagger:enter('Platform') then
                    onPlatformCollision()
                end
            end
        end
        end

        function ice.icedraw()
            if player.iceState then
                love.mouse.setVisible(false)
                local cursorX, cursorY = love.mouse.getPosition()
                love.graphics.draw(cursorImage, cursorX, cursorY)
            else
                love.mouse.setVisible(true)
            end

            if player.iceDagger then
                local x, y = player.iceDagger:getPosition()
                love.graphics.draw(iceDaggerImage, x, y, 0, 1, 1, iceDaggerImage:getWidth() / 2, iceDaggerImage:getHeight() / 2)
             elseif player.bullet then
                local bx,by = player.bullet:getPosition()
                love.graphics.draw(iceDaggerImage, bx, by, 0, 1, 1, iceDaggerImage:getWidth() / 2, iceDaggerImage:getHeight() / 2)
                end
            end
        

        return ice

--  Code that is executed in other files 
    -- animations.teleport = anim8.newAnimation(grid('1-7',15),0.1) 
    -- if player.isteleporting or player.isshooting then
    --             player.animation = animations.teleport
    