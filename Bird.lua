Bird = Class{}

local GRAVITY = 800
local JUMP_VELOCITY = -200

function Bird:init()
	self.image = love.graphics.newImage('bird.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = VIRTUAL_WIDTH/2 - self.width/2
	self.y = VIRTUAL_HEIGHT/2 - self.height/2

	self.dvy = 0
end

function Bird:update(dt)
	self.dvy = self.dvy + GRAVITY * dt
	self.y = self.y + self.dvy * dt
end

function Bird:jump()
	self.dvy = JUMP_VELOCITY
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pair)
	if self.x + self.width > pair.x + 8 and self.x < pair.x + PIPE_WIDTH - 8 and (self.y + 2 < pair.y or self.y + self.height - 2 > pair.y + GAP_HEIGHT) then
	    return true
    end

    return false
end 