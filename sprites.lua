local sprites = {}

function sprites.anim()
anim8 = require 'lib/anim8'     
-- sti  =  require'lib/Simple-Tiled-Implementation/sti'  
spritesheet = 'sprite/tsheet_.png'
sprites = {} --create a sprite table to create the spritesheet attrib
sprites.playersheet  =  love.graphics.newImage(spritesheet)
local grid = anim8.newGrid(55,40,sprites.playersheet:getWidth(),sprites.playersheet:getHeight())
animations = {}
animations.idle = anim8.newAnimation(grid('1-6',1),0.15)    
animations.walk = anim8.newAnimation(grid('1-8',2),0.15)    
animations.run = anim8.newAnimation(grid('1-6',3),0.17)     
--animations.run = anim8.newAnimation(grid('1-3',12),0.15)     
animations.jump = anim8.newAnimation(grid('4-6',4),0.15)    
animations.boost = anim8.newAnimation(grid('1-6',3),0.090)  
animations.surf = anim8.newAnimation(grid('1-3',7),0.1) 
animations.surf_jump = anim8.newAnimation(grid('1-3',8),0.1) 
animations.spin = anim8.newAnimation(grid('1-6',4),0.1) 
animations.bounce  = anim8.newAnimation(grid('1-6',4),0.1)
animations.teleport = anim8.newAnimation(grid('1-7',13),0.1) 
animations.fall = anim8.newAnimation(grid('1-4',11),0.1)    
animations.slash = anim8.newAnimation(grid('1-4',16),0.1)    
animations.dash = anim8.newAnimation(grid('1-4',17),0.5)    

end

function sprites.draw()
player.animation:draw(sprites.playersheet, px + player.width / 3, py - player.height / 3, 0, 3 * player.direction, 3,20,20)--pangle()             )--20, 20)
end


return sprites