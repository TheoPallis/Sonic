Class = require 'class'
WINDOW_WIDTH  = 2560
WINDOW_HEIGHT = 1440
VIRTUAL_WIDTH = WINDOW_WIDTH
VIRTUAL_HEIGHT = WINDOW_HEIGHT
timer = 0
camera = 'static'
zoom  = 1
visibleworld = false
debugger = false

function love.load()
    love.physics.setMeter(64)
    love.graphics.setDefaultFilter('nearest','nearest') --Apply nearest to upscaling and downscaling
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    sprites = require'sprites'
    sprites.anim()
    platforms  = require("platform")
    char = require("smooth_player")
    enemy = require('enemy')
    debugging = require('config/debugging')
end

function love.update(dt)
    timer = timer + 1 * dt / 2  
    world:update(dt)
    -- platforms.platformupdate(dt)
    char.playerUpdate(dt)
    enemy.enemyupdate(dt,player)
    if camera == 'dynamic' then
    cam:lookAt(player:getPosition())
    end
    end

function love.draw()
love.graphics.setColor(1, 1, 1) -- Set color to white
if camera == 'dynamic' then
    local wx, wy = love.window.getMode()
    love.graphics.translate(wx / 2, wy / 2)
    love.graphics.scale(zoom)
    love.graphics.translate(-wx / 2, -wy / 2)

    cam:attach()
end
--gamemap :drawLayer(gamemap.layers("Tile Layer 1"))
if visibleworld == true then
world:draw()
end
char.drawPlayer()

if camera == 'dynamic'then
    cam:detach()
end
if debugger == true then
debugging.debug()
end
end


function love.wheelmoved(x, y)
    if y > 0 then
        zoom = zoom * 1.1
    elseif y < 0 then
        zoom = zoom / 1.1
    end
end
