
--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu
    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.lastY = math.random(80) + 20
    self.score = 0
end

function PlayState:update(dt)
    if love.keyboard.isDown('space') then
    	sounds['jump']:play()
    	self.bird:jump()
    end

	self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 1.5 then    	
    	local y = math.max(10, math.min(self.lastY + math.random(-80, 80), VIRTUAL_HEIGHT - 90))
        self.lastY = y

    	table.insert(self.pipePairs, PipePair(y))
    	self.spawnTimer = 0
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
    	pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    for k, pair in pairs(self.pipePairs) do
    	if self.bird:collides(pair) then
    		sounds['explosion']:play()
    		sounds['hurt']:play()
    		gStateMachine:change('end', {score = self.score})
    	end
    end

    for k, pair in pairs(self.pipePairs) do
    	if not pair.scored then
	    	if self.bird:scores(pair) then
	    		sounds['score']:play()
	            self.score = self.score + 1
	            pair.scored = true
	        end
	    end
    end

    if self.bird.y + self.bird.height > VIRTUAL_HEIGHT - 16 then
    	sounds['explosion']:play()
    	sounds['hurt']:play()
    	gStateMachine:change('end', {score = self.score})
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
    	pair:render()
    end

    self.bird:render()

    love.graphics.setFont(mediumFont)
    love.graphics.printf(tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
end
