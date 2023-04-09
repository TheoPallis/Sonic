
char = {}
spritesheet = 'sprite/tsheet_.png'
-- ice_sheet = 'sprite/tsheet_ice.png'
jump_sound = love.audio.newSource("sounds/jump.mp3", "static") 
boost_sound = love.audio.newSource("sounds/boost.mp3", "static")
down_sound = love.audio.newSource("sounds/down.wav", "static")
walk_sound = love.audio.newSource("sounds/walk.ogg", "static")
knife_sound = love.audio.newSource("sounds/blade.mp3", "static")
-- running_sound = (love.audio.newSource("down.wav", "static")
sprites = require('sprites')
-- Player attributes 1
player = world:newRectangleCollider(VIRTUAL_WIDTH / 2, 800, 55, 80, {collision_class = "Player"}) --x,y,width,height, unites body,fixture,shape
small_player = world:newRectangleCollider(VIRTUAL_WIDTH / 2, 60, 55, 80, {collision_class = "Player"})
player:setFixedRotation(true)
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
-- Add wind state variables
player.windState = false
player.windPlatform = nil
-- Add water state variables
player.waterState = false
player.hydroPumpForce = 0

-- Require 2
controls = require 'controls'
ice =  require 'states/ice'
water = require('states/water')
require('states/wind')

-- B
function char.playerUpdate(dt)
px, py = player:getPosition()
vx, vy = player:getLinearVelocity()
mx, my = love.mouse.getPosition()

if player.body then
    char.updatePlayerDirection()
    px, py = player:getPosition()
    wind.windupdate(dt)
    ice.iceDaggerupdate(dt)
    water.waterupdate(dt)
    -- fireupdate(dt)
    
    local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + player.height, player.width, 2, {'Platform'})
    
    if #colliders > 0 then
        player.grounded = true
    else
        player.grounded = false
    end
end

controls.controlsupdate(dt)
projectileupdate(dt)
player.animation:update(dt)
end

function char.drawPlayer()    

-- Change direction according to mouse
local mouseX, mouseY = love.mouse.getPosition()
    if mouseX > px then
        player.direction = 1
    else
        player.direction = -1
    end
sprites.draw()
controls.controls_render()
ice.icedraw()
 end


function char.updatePlayerDirection()
    local mouseX, mouseY = love.mouse.getPosition()
    local playerX, playerY = player:getPosition()
    local angle = math.atan2(mouseY - playerY, mouseX - playerX)
    if angle < 0 then
        angle = angle + 2 * math.pi
    end
    player.angle = angle
end

return char