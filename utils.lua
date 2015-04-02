--temporary; once i learn an equation for getting the correct x and y values for taps in coordination with love.graphics.scale, we'll use that instead
--dimensions: 1080 x 1920 (w/h)
--landscape: 1920 x 1080

--MAKE SURE THIS IS SET WHEN YOU COMPILE!!!!
phone = false

if phone == false then
	scale = 1
else
	scale = 4
end

--will check if an object is tapped (obj must have an x, y, width, and height variable in it's table)
function checkTouch(tapx, tapy, obj)
	if tapx >= obj.x and tapx < obj.x + obj.w
	and tapy >= obj.y and tapy < obj.y + obj.h then
		return true
	else
		return false
	end
end

-- Collision detection function.
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end