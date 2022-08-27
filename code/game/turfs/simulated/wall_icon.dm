/turf/simulated/wall/proc/update_icon()
//	if(!material)
//		return

//	if(!damage_overlays[1]) //list hasn't been populated
//		generate_overlays()

	overlays.Cut()
	var/image/I

//	var/base_color = paint_color ? paint_color : material.icon_colour
//	if(!density)
//		I = image('icons/turf/wall_masks.dmi', "[material.icon_base]fwall_open")
//		I.color = base_color
//		overlays += I
//		return

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image(icon, "[icon_state]_other[wall_connections[i]]", dir = 1<<(i-1))
		else
			I = image(icon, "[icon_state][wall_connections[i]]", dir = 1<<(i-1))
//		I.color = base_color
		overlays += I

	return


/turf/simulated/wall/proc/update_connections(propagate = 0)
	var/list/wall_dirs = list()
	var/list/other_dirs = list()

	for(var/turf/simulated/wall/W in orange(src, 1))
		switch(can_join_with(W))
			if(0)
				continue
			if(1)
				wall_dirs += get_dir(src, W)
			if(2)
				wall_dirs += get_dir(src, W)
				other_dirs += get_dir(src, W)
		if(propagate)
			W.update_connections()
			W.update_icon()

/*	for(var/turf/T in orange(src, 1))
		var/success = 0
		for(var/obj/O in T)
			for(var/b_type in blend_objects)
				if(istype(O, b_type))
					success = 1
				for(var/nb_type in noblend_objects)
					if(istype(O, nb_type))
						success = 0
				if(success)
					break
			if(success)
				break

		if(success)
			wall_dirs += get_dir(src, T)
			if(get_dir(src, T) in GLOB.cardinal)
				other_dirs += get_dir(src, T)
*/
	wall_connections = dirs_to_corner_states(wall_dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(walltype == W.walltype)
		return 1
	for(var/wb_type in canSmoothWith)
		if(istype(W, wb_type))
			return 2
	return 0

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
	turn() is weird:
		turn(icon, angle) turns icon by angle degrees clockwise
		turn(matrix, angle) turns matrix by angle degrees clockwise
		turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE
