-- enemy.lua
local enemy = {}
local enemies = {}

function enemy.spawnenemy()
    local enemy1 = world:newRectangleCollider(VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT - 200, 60, 80, {collision_class = "Enemy"})
    enemy1.direction = 1
    enemy1:setFixedRotation(true)
    enemy1.speed = 300
    enemy1.width = 60
    enemy1.height = 80
    enemy1.life = 100
    table.insert(enemies, enemy1)
end

function enemy.enemyupdate(dt, player)
    local playerX, playerY = player:getPosition()
    local playerWidth =  55
    local playerHeight = 80
    local isOnEnemy = false
    
    for i, e in ipairs(enemies) do
        local ex, ey = e:getPosition()
        local ewidth, eheight = e.width, e.height
        ex = ex + e.speed * dt * e.direction
        e:setPosition(ex, ey) -- Update the enemy's position in the object
        
        if checkCollision({x = playerX, y = playerY, width = playerWidth, height = playerHeight}, {x = ex, y = ey, width = ewidth, height = eheight}) then
            isOnEnemy = true
            player.onenemy = true
            if player.isslashing then
            knife_sound:play()
        end
            break
        end
    end
    return isOnEnemy
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

return enemy
