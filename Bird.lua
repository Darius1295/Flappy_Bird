Bird = Class{}

function Bird:init()
	self.image = love.graphics.newImage('bird.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = VIRTUAL_WIDTH/2 - self.width/2
	self.y = VIRTUAL_HEIGHT/2 - self.height/2

	self.dy = 0
end

function Bird:update(dt)
	self.dy = self.dy + 500 * dt
	self.y = self.y + self.dy * dt
end

function Bird:jump()
	self.dy = -200
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end 