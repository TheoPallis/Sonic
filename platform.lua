local platforms = {}
local minPlatformWidth = 500
local maxPlatformWidth = 700
local minPlatformHeight = 400
local maxPlatformHeight = 600
local minPlatformDistance = 100
local maxPlatformDistance = 400
local lastPlatformX = 0
local lastPlatformY = 200
local platformBuffer = 500 -- Buffer to ensure platforms are generated off-screen

wf = require 'lib/windfield/windfield'
world = wf.newWorld(0,800,true) --gravity in both directions, always/when out of an edge apply gravity
world : setQueryDebugDrawing(true) --show circle that detects colliders
world:addCollisionClass('IceDagger')
world:addCollisionClass('Platform') 
world:addCollisionClass('Enemy') 
world:addCollisionClass('Player'--[[,{ignores = {'Ground'}}]])
world:addCollisionClass('Wall')


cameraFile =  require ('lib/camera')
cam = cameraFile()

platform1 = world:newRectangleCollider(0,500,800,5,{collision_class = "Platform"})
platform1:setType("static")            

platform2 = world:newRectangleCollider(1500 ,500,800,5,{collision_class = "Platform"})
platform2:setType("static")            

ground1 = world:newRectangleCollider(0,VIRTUAL_HEIGHT - 20,VIRTUAL_WIDTH*100,10,{collision_class = "Platform"})
ground1:setType("static")

local wallWidth = 20 -- The width of the walls
local wallHeight = love.graphics.getHeight() -- The height of the walls, which is equal to the screen height

local leftWall = world:newRectangleCollider(0- 60, 0, wallWidth, wallHeight,{collision_class = "Wall"})
leftWall:setType('static')

local rightWall = world:newRectangleCollider(60 + love.graphics.getWidth() - wallWidth, 0, wallWidth, wallHeight,{collision_class = "Wall"})
rightWall:setType('static')


function generatePlatform()
    local platformWidth = math.random(minPlatformWidth, maxPlatformWidth)
    local platformHeight = math.random(minPlatformHeight, maxPlatformHeight)
    local platformDistanceX = math.random(minPlatformDistance, maxPlatformDistance)
    local platformDistanceY = math.random(-maxPlatformDistance / 2, maxPlatformDistance / 2)

    local newX = lastPlatformX + platformWidth + platformDistanceX
    local newY = lastPlatformY + platformDistanceY
    local platform = world:newRectangleCollider(newX, newY, platformWidth, 5, {collision_class = "Platform"})
    platform:setType("static")

    lastPlatformX = newX
    lastPlatformY = newY
end

-- function platforms.generateInitialPlatforms()
--     for i = 1, 5 do
--         platforms.generatePlatform()
--     end
-- end


function platforms.platformupdate(dt)
local playerX, playerY = player:getPosition()
--Check if the player is close to the edge of the existing platforms
if playerX + platformBuffer > lastPlatformX then
    generatePlatform()
    end
end


return platforms


