-- Require necessary libraries
local vector = require("vector")

hook = {}
hook.radius = 10
hook.speed = 800
hook.active = false
hook.maxDistance = 300 

-- Create a new hook object
function hook.new(x, y)
    local new_hook = {}
    new_hook.position = vector(x, y)
    new_hook.velocity = vector(0, 0)
    new_hook.active = false
    new_hook.speed = 800 
    return new_hook
end

-- Update the hook object
function hook.update(hook, dt)
    if hook.active then
        hook.position.x = hook.position.x + hook.velocity.x * dt
        hook.position.y = hook.position.y + hook.velocity.y * dt

    end
end

-- Draw the hook object
function hook.draw(hook)
    hook.radius = 10
    if hook.active then
        local px,py = player:getPosition()
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.line(px, py, hook.position.x, hook.position.y)
        love.graphics.setColor(1, 1, 1)
    end
end

-- Fire the hook
function hook.fire(hook, x, y, targetX, targetY)
    --  local direction = vector(targetX - x, targetY - y):normalized()
    --    hook.velocity = vector(direction.x * hook.speed, direction.y * hook.speed)
    --  hook.position = vector(x, y)
    hook.position = vector(targetX, targetY)
    hook.active = true

    
    end

-- Attach the hook to a point
function hook.attach(hook, x, y)
    hook.active = false
    hook.velocity = vector(0, 0)
    hook.position = vector(x, y)
end

-- Detach the hook
function hook.detach(hook)
    hook.active = false
    hook.velocity = vector(0, 0)
end

return hook
