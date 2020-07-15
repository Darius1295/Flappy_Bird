push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local pipes = {}
local spawnTimer = 0

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
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
	    % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
	    % VIRTUAL_WIDTH

    if love.keyboard.isDown('space') then
    	bird:jump()
    end

	spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
    	table.insert(pipes, Pipe())
    	spawnTimer = 0
    end

    bird:update(dt)

    for k, pipe in pairs(pipes) do
    	pipe:update(dt)

    	if pipe.x < -pipe.width then
    		table.remove(pipes, k)
    	end
    end
end

function love.draw()
	push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipe in pairs(pipes) do
    	pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

	push:finish()
end