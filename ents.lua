--Entities
anim8 = require 'lib/anim8'
collider     = require 'lib/ATL/Collider'
class = require	'lib/class'
Obj = class {x=0, y=0, w=45, h=45, r=255, g=255, b=255,img='test'}
Obj.__name='Objeto'

--Class constructor for basic Ents
function Obj:__init(x,y,w,h)
	self.x, self.y = x,y
	self.w, self.h = w,h
end

--Draw method
function Obj:draw(img,r,g,b)
	self.r,self.g,self.b = r,g,b
	self.img = img
	local Img = love.graphics.newImage('img/'..self.img..'.png')
	love.graphics.setColor(255,255,255)
	love.graphics.draw(Img,self.x,self.y)
	if debug then		
		love.graphics.setColor(self.r,self.g,self.b)
		love.graphics.rectangle('line',self.x,self.y,self.w,self.h)
	end
end

--==========================================

Char = class{x=10,y=10,w=32,h=32,r=0,g=255,b=0,img='char',state=0}
Char.__name='Character'
function Char:__init(x,y,w,h)
	self.x, self.y = x,y
	self.w, self.h = w,h
	self.col = collider.new(self.x,self.y,self.w,self.h,map,metaLayer)  -- Collision detection with map
	local Img = love.graphics.newImage('img/'..self.img..'.png')
	--animation grid and frames
	self.g = anim8.newGrid(self.w, self.h, Img:getWidth(),Img:getHeight())
	self.a={}
	self.a[0] = anim8.newAnimation(self.g(1,1), 0.2) -- Idle
	self.a[1] = anim8.newAnimation(self.g('1-3',4), 0.2) -- Up
	self.a[2] = anim8.newAnimation(self.g('1-3',1), 0.2) -- Dow
	self.a[3] = anim8.newAnimation(self.g('1-3',2), 0.2) -- Left
	self.a[4] = anim8.newAnimation(self.g('1-3',3), 0.2) -- Right
end

function Char:update(dt)
	self.a[self.state]:update(dt)
end

function Char:draw(img,r,g,b)
	self.r,self.g,self.b = r,g,b
	self.img = img
	local Img = love.graphics.newImage('img/'..self.img..'.png')
	love.graphics.setColor(255,255,255)
	self.a[self.state]:draw(Img, self.x, self.col.y)
	if debug then
		love.graphics.setColor(self.r,self.g,self.b,100)
		self.col:draw('fill') -- Collision box
		-- My collison box...   love.graphics.rectangle('line',self.x,self.y,self.w,self.h)
		-- Collision box adjusted love.graphics.rectangle('line',self.x,self.y+self.h/2,self.w,self.h/2)
	end
end

--===================================================

Player = Char:extends{s=0.8,hp=1}
function Player:__init(x,y,w,h,img,s)
	Player.super.__init(self,x,y,w,h,img,state)
	self.col = collider.new(self.x,self.y,self.w,self.h,map,metaLayer)  -- Collision detection with map
	self.s = s
	self.collision = false
	
	--===================================================
	--==						    		Custom Collision Callback								    ==
	--===================================================
	function self.col:isResolvable(side,tile,x,y)
	local tp = tile.properties
		if tp.solid then
			if side == 'top' then return true end
			if side == 'bottom' then return true end
			if side == 'right' then return true end
			if side == 'left' then return true end
		end
	end
	--====================================================
end

function Player:update(dt)
	--Updates animation
	self.a[self.state]:update(dt)
	--Run
	if love.keyboard.isDown"lshift" then
		self.s = 1.3
	end
	--Controls
	if love.keyboard.isDown"w" then
		self.a[self.state]:resume(dt)
		self.state = 1
		self.y = self.col.y-self.s
	elseif love.keyboard.isDown"s" then
		self.a[self.state]:resume(dt)
		self.state = 2
		self.y = self.col.y+self.s
	end
	if love.keyboard.isDown"a" then
		self.a[self.state]:resume(dt)
		self.state = 3
		self.x = self.col.x-self.s
	elseif love.keyboard.isDown"d" then
		self.a[self.state]:resume(dt)
		self.state = 4
		self.x = self.col.x+self.s
	end
	
	--Updates Collision 
	self.col:moveTo(self.x,self.y) 
	
	--Tile position
	self.tx = math.floor((self.x+self.w/2+ 0.5)/32)
	self.ty = math.floor((self.y+self.h/2+ 0.5)/32)
end

function Player:isIdle()
	self.a[self.state]:pauseAtStart(dt)
	self.s = 0.7
end



---- Lets me pick a colour ---->   rgb(217, 54, 0)