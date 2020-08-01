push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 120
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local bird = Bird()
local pipePairs = {}
local spawnTimer = 0
local lastY = math.random(80) + 20
local scrolling = true

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy Bird')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	if scrolling then
		backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		    % BACKGROUND_LOOPING_POINT
		groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
		    % GROUND_LOOPING_POINT

	    if love.keyboard.isDown('space') then
	    	bird:jump()
	    end

		spawnTimer = spawnTimer + dt
	    if spawnTimer > 1.5 then    	
	    	local y = math.max(10, math.min(lastY + math.random(-80, 80), VIRTUAL_HEIGHT - 90))
	        lastY = y

	    	table.insert(pipePairs, PipePair(y))
	    	spawnTimer = 0
	    end

	    bird:update(dt)

	    for k, pair in pairs(pipePairs) do
	    	pair:update(dt)
	    end

	    for k, pair in pairs(pipePairs) do
	        if pair.remove then
	            table.remove(pipePairs, k)
	        end
	    end

	    for k, pair in pairs(pipePairs) do
	    	if bird:collides(pair) then
	    		scrolling = false
	    	end
	    end

	    if bird.y + bird.height > VIRTUAL_HEIGHT - 16 then
	    	scrolling = false
	    end
    end
end

function love.draw()
	push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pair in pairs(pipePairs) do
    	pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

	push:finish()
end
