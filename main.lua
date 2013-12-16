
function love.load()
--libs
	Entidades= require 'Ents' --Entidades
	loader= require('lib/ATL/loader') -- Map Loader
	loader.path = 'maps/' -- path of the maps dir.
	map = loader.load('map.tmx') --Name of the map
	metaLayer = map('META') -- Meta layer for colision, items, doors, etc.
	sup = love.graphics.newImage('img/shadows.png')	
--debug
	debug = true
-- all the other shit
	player=Player(63,377)
end

function love.update(dt)
	metaLayer.visible = debug
	player:update(dt)
end

function love.draw()
	love.graphics.setColor(255,255,255)
	map:draw()
	map:setDrawRange(0,0,love.graphics.getWidth(), love.graphics.getHeight())
	player:draw('char')
	love.graphics.draw(sup,0,0)
	--debug
	if debug == true then
		love.graphics.print('state - '.. player.state, 10, 10)
		love.graphics.print('pos - '.. player.x..' , '..player.y, 10, 30)
		love.graphics.print('ColBox pos - '.. player.col.x..' , '..player.col.y, 10, 50)
		love.graphics.print('speed - '.. player.s, 10, 80)
	end	
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
	if key == "`" then
		debug = not debug
	end
end

function love.keyreleased( key, unicode )
	if key == "w" or key == "s" or key == "a" or key == "d" or key =="lshift"then
		player:isIdle()
	end
end

function love.mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
end

function love.quit()
end

function shot()
end

----  9.81

--45*75