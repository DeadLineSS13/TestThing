#define BIG_CHUNK_X 24
#define BIG_CHUNK_Y 24
#define CHUNK_X 8
#define CHUNK_Y 8

/client/proc/reroll_chunks()
	set name = "Reroll Anomalies"
	set category = "Stalker"

	SSzonegenerator.regenerate_chunks()



/datum/stack_record
	var/x = 0
	var/y = 0

/datum/stack_record/New(var/xi, var/yi)
	x = xi
	y = yi

SUBSYSTEM_DEF(zonegenerator)
	name = "Zone Generator"
	priority = -1
	flags = SS_NO_FIRE

	var/list/anomalies

	var/chunks[1]
	var/list/turf/anomaly_chunks = list()
	var/list/datum/stack_record/stack = list()
	var/z = 2
	var/ON = 0

/datum/controller/subsystem/zonegenerator/Initialize()
	..()
	if(ON)
		create_chunks()

/datum/controller/subsystem/zonegenerator/proc/create_chunks()
	chunks.len = (world.maxx/CHUNK_X)*(world.maxy/CHUNK_Y)
	var/current_chunk = 0
	for(var/i = 1 to world.maxy/BIG_CHUNK_Y)
		for(var/j = 1 to world.maxx/BIG_CHUNK_X)
			for(var/n = 1 to (BIG_CHUNK_Y/CHUNK_Y))
				for(var/m = 1 to (BIG_CHUNK_X/CHUNK_X))
					current_chunk++
					chunks[current_chunk] = block(locate(1+(j-1)*BIG_CHUNK_X+(m-1)*CHUNK_X, 1+(i-1)*BIG_CHUNK_Y+(n-1)*CHUNK_Y, 1),locate(m*CHUNK_X+(j-1)*BIG_CHUNK_X, n*CHUNK_Y+(i-1)*BIG_CHUNK_Y, z))
					anomaly_chunks += chunks[current_chunk]
					CHECK_TICK
	create_anomaly_chunks(world.maxx/BIG_CHUNK_X, world.maxy/BIG_CHUNK_Y, z)
	spawn_anomaly_chunks()

	chunks.Cut()
	stack.Cut()
	anomaly_chunks.Cut()

	anomalies = GLOB.anomalies

/datum/controller/subsystem/zonegenerator/proc/regenerate_chunks()
	if(!ON)
		return
	for(var/obj/anomaly/natural/A in GLOB.anomalies)
		qdel(A)
		CHECK_TICK

	create_chunks()

/datum/controller/subsystem/zonegenerator/proc/create_anomaly_chunks(var/width, var/height, var/z)
	var/list/matrix[width][height]

	for(var/y = 1, y <= width, y++)
		for(var/x = 1, x <= height, x++)
			matrix[x][y] = 0
		CHECK_TICK

	var/mx = 1
	var/my = 1

	CreateAnomalyChunk(mx, my, z)
	matrix[mx][my] = 1

	while(1)
		PrintMatrix(matrix, width, height)
		var/list/vecDir = FindNeighbour(matrix, mx, my, width, height)

		if(!vecDir.len)
			//world << "Empty vecDir"
			var/datum/stack_record/sr = FindEmptyCell(matrix, mx, my, width, height)
			if(!sr)
				return
			mx = sr.x
			my = sr.y
			stack += new /datum/stack_record(mx, my)
		else
			mx += vecDir[1]
			my += vecDir[2]
//			world.log << "Creating chunk at mx: [mx], my: [my]"
			CreateAnomalyChunk(mx, my, z)
			matrix[mx][my] = 1

		CHECK_TICK

/datum/controller/subsystem/zonegenerator/proc/FindEmptyCell(var/list/matrix, var/mx, var/my, var/w, var/h)
	for(var/ptr = stack.len, ptr > 0, ptr--)
		var/datum/stack_record/sr = stack[ptr]
		var/list/vecDir = FindNeighbour(matrix, sr.x, sr.y, w, h)
		if(vecDir.len)
			return sr
		CHECK_TICK
	return

/proc/PrintMatrix(var/list/matrix, w, h)
	for(var/y = 1, y <= h, y++)
		var/line = ""
		for(var/x = 1, x <= w, x++)
			var/matrix_val = matrix[x][y]
			line += "[matrix_val] "
//		world.log << line


/datum/controller/subsystem/zonegenerator/proc/FindNeighbour(var/list/matrix, var/x, var/y, var/max_x, var/max_y)
	//world << "Searching for neighbours at ([x], [y])"

	var/list/dirs = list()
	dirs["[NORTH]"] = 1
	dirs["[SOUTH]"] = 1
	dirs["[EAST]"] = 1
	dirs["[WEST]"] = 1

	if((y - 1) > 0)
		dirs["[NORTH]"] = matrix[x][y - 1]

	if((x + 1) <= max_x)
		dirs["[EAST]"] = matrix[x + 1][y]

	if((y + 1) <= max_y)
		dirs["[SOUTH]"] = matrix[x][y + 1]

	if((x - 1) > 0)
		dirs["[WEST]"] = matrix[x - 1][y]

	var/list/empty = list()

	for(var/dir in dirs)
		//world << dir
		if((dir == "[NORTH]" || dir == "[SOUTH]" || dir == "[EAST]" || dir == "[WEST]") && !dirs[dir])
			//world << "Empty dir: [dir]"
			empty += dir

	if(!empty.len)
		//world << "No empty dirs"
		return list()

	var/r = rand(1, empty.len)

	if(empty[r] == "[NORTH]")
		return list(0, -1)
	else if(empty[r] == "[EAST]")
		return list(1, 0)
	else if(empty[r] == "[SOUTH]")
		return list(0, 1)
	else if(empty[r] == "[WEST]")
		return list(-1, 0)

	return list()

/datum/controller/subsystem/zonegenerator/proc/CreateAnomalyChunk(var/mx, var/my, var/z)
	var/prevDir = "WEST"

	var/num = (my-1)*16*9+(mx-1)*9

	var/list/anom_chunks = list()
	anom_chunks["[NORTH]"] = chunks[num+8]
	anom_chunks["[SOUTH]"] = chunks[num+2]
	anom_chunks["[EAST]"] = chunks[num+6]
	anom_chunks["[WEST]"] = chunks[num+4]

	if(stack.len)
		var/datum/stack_record/sr = stack[stack.len]


		if(mx < sr.x)
			prevDir = "EAST"

		if(mx > sr.x)
			prevDir = "WEST"

		if(my < sr.y)
			prevDir = "SOUTH"

		if(my > sr.y)
			prevDir = "NORTH"

	stack += new /datum/stack_record(mx, my)

	if(stack.len <= 1)
		for(var/i = 1 to 9)
			anomaly_chunks -= chunks[num+i]
	else
		anomaly_chunks -= chunks[num+5]
		switch(prevDir)
			if("EAST")
				anomaly_chunks -= chunks[num+6]
				anomaly_chunks -= chunks[num+9+4]
			if("WEST")
				anomaly_chunks -= chunks[num+4]
				anomaly_chunks -= chunks[num-9+6]
			if("SOUTH")
				anomaly_chunks -= chunks[num+8]
				anomaly_chunks -= chunks[num+144+2]
			if("NORTH")
				anomaly_chunks -= chunks[num+2]
				anomaly_chunks -= chunks[num-144+8]


/datum/controller/subsystem/zonegenerator/proc/spawn_anomaly_chunks()
/*
	var/anomaly_list = list(/obj/anomaly/natural/gravy/tramplin = 2200, /obj/anomaly/natural/gravy/vortex = 1900,
							/obj/anomaly/natural/gravy/mosquito_net = 100,/obj/anomaly/natural/gravy/trap = 775, /obj/anomaly/natural/gravy/mobius = 5,
							/obj/anomaly/natural/electro = 1900, /obj/anomaly/natural/tesla_ball = 5, /obj/anomaly/natural/tesla_ball_double = 2,
							/obj/anomaly/natural/fire/jarka = 1900, /obj/anomaly/natural/fire/demon = 3,
							/*/obj/anomaly/natural/toxic/rust_puddle = 100,*/ /obj/anomaly/natural/toxic/vedmin_studen = 100)
*/
	for(var/turf/T in anomaly_chunks)
		var/area/stalker/area = get_area(T)
		if(area.anomalies_to_spawn.len)
			if(prob(area.anomaly_chance))
				var/A = pickweight(area.anomalies_to_spawn)
				var/turf/TF = locate(T.x+rand(-2, 2), T.y+rand(-2,2), T.z)
				if(!TF.density && !T.contents.Find(/obj/anomaly/natural))
					if(A)
						new A(TF)

		CHECK_TICK