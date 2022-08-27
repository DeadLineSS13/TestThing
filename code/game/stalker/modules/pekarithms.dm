proc/bresenhamCircle(centre_x, centre_y, radius)
	var x = 0
	var y = radius
	var delta = 1 - 2 * radius
	var error = 0

	var/list/vector/points = list()

	while (y >= 0)
		points += new /vector(centre_x + x, centre_y + y)
		points += new /vector(centre_x + x, centre_y - y)
		points += new /vector(centre_x - x, centre_y + y)
		points += new /vector(centre_x - x, centre_y - y)
		error = 2 * (delta + y) - 1
		if ((delta < 0) && (error <= 0))
			delta += 2 * ++x + 1
			continue
		if ((delta > 0) && (error > 0))
			delta -= 2 * --y + 1
			continue
		delta += 2 * (++x - y--)

	return points

proc/bresenhamLine(x0, y0, x1, y1)
	var/deltax = x1 - x0
	var/deltay = y1 - y0
	var/deltaerr = 0
	if(deltax != 0)
		deltaerr = abs(deltay / deltax)
	var/error = 0.0
	var/y = y0

	var/list/vector/points = list()
	for(var/x=x0, x0 <= x1, x++)
		points += new /vector(x,y)
		error = error + deltaerr
		if(error >= 0.5)
			y = y + sign(deltay) * 1
			error = error - 1.0

	return points