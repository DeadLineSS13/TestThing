/client/New()
	..()
	dir = NORTH
//	pixel_y = 200
/*
/client/verb/spinleft()
	set name = "Spin View CCW"
	set category = "OOC"
	dir = turn(dir, 90)
	switch(dir)
		if(1)
			pixel_y = 200
			pixel_x = 0
		if(2)
			pixel_y = -200
			pixel_x = 0
		if(4)
			pixel_x = 200
			pixel_y = 0
		if(8)
			pixel_x = -200
			pixel_y = 0

/client/verb/spinright()
	set name = "Spin View CW"
	set category = "OOC"
	dir = turn(dir, -90)
	switch(dir)
		if(1)
			pixel_y = 200
			pixel_x = 0
		if(2)
			pixel_y = -200
			pixel_x = 0
		if(4)
			pixel_x = 200
			pixel_y = 0
		if(8)
			pixel_x = -200
			pixel_y = 0

/client/North()
	world << "North, dir: [dir]"
	switch(dir)
		if(NORTH)
			..()
			//Move(get_step(src.mob.loc, NORTH), NORTH)
		if(SOUTH)
			Move(get_step(src.mob.loc, SOUTH), SOUTH)
		if(EAST)
			Move(get_step(src.mob.loc, EAST), EAST)
		if(WEST)
			Move(get_step(src.mob.loc, WEST), WEST)

/client/South()
	world << "South, dir: [dir]"
	if(NORTH)
		North()
	if(SOUTH)
		return
	if(EAST)
		North()
	if(WEST)
		spinright()

/client/West()
	world << "West, dir: [dir]"
	switch(dir)
		if(NORTH)
			spinleft()
		if(SOUTH)
			North()
		if(EAST)
			spinleft()
		if(WEST)
			North()

/client/East()
	world << "East, dir: [dir]"
	switch(dir)
		if(NORTH)
			spinleft()
		if(SOUTH)
			North()
		if(EAST)
			North()
		if(WEST)
			spinleft()
*/