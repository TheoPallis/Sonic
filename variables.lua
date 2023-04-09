variables = {}

player.width = 55
player.height = 40
player.baseSpeed = 200
player.animation = animations.idle
player.iswalking = false
player.isrunning = false
player.iskicking = false
player.issurfing = false
player.isspinning = false
player.isfalling = true
player.isteleporting = false
player.isboosting = false
player.direction = 1
player.grounded = true
player.jumpcount = 0
player.maxjumps = 3
player.jumpForce = 2500
player.surfSpeed = 400
player.acceleration = 8000
player.deceleration = 8000
player.maxSpeed = 300
player.boostForce = 2000
player.airControlFactor = 0.5
player.stomp  = false
player.onenemy = false
player.isshooting = false
player.isWallRunning = false
player.wallDirection = 0
-- Add wind state variables
player.windState = false
player.windPlatform = nil
-- Add water state variables
player.waterState = false
player.hydroPumpForce = 0

 healthBarWidth = 200
 healthBarHeight = 20
 healthBarX = 10
 healthBarY = 10
 healthBarBorder = 2
 damage = 10 -- Damage taken per frame when hit
 healthRegen = 0.5 -- Health regenerated per frame

player.maxHealth = 100
player.currentHealth = 100
player.hook.manualControl  = false
 function takeDamage(damageAmount)
        player.currentHealth = math.max(0, player.currentHealth - damageAmount)
    end

    -- Test damage by pressing 'h'
    if love.keyboard.isDown('h') then
        takeDamage(damage * dt)
    end


return variables