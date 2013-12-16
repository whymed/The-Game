function showDebug(txt,var)	
	self.txt = txt
	self.var = var
	if debug == true then
				love.graphics.print(txt..':  '.., 10, 10)
		--Prueba si playerDead es true 
	end
end	