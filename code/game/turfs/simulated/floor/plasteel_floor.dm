/turf/simulated/floor/plasteel
	icon_state = "floor"
//	floor_tile = /obj/item/stack/tile/plasteel
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")

/turf/simulated/floor/plasteel/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		icon_state = icon_regular_floor



/turf/simulated/floor/plasteel/stairs
	icon_state = "stairs"
/turf/simulated/floor/plasteel/stairs/stalker
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "ladder"
/turf/simulated/floor/plasteel/stairs/left
	icon_state = "stairs-l"
/turf/simulated/floor/plasteel/stairs/left/stalker
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "ladder_left"
/turf/simulated/floor/plasteel/stairs/medium
	icon_state = "stairs-m"
/turf/simulated/floor/plasteel/stairs/medium/stalker
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "ladder_middle"
/turf/simulated/floor/plasteel/stairs/right
	icon_state = "stairs-r"
/turf/simulated/floor/plasteel/stairs/right/stalker
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "ladder_right"
/turf/simulated/floor/plasteel/stairs/old
	icon_state = "stairs-old"