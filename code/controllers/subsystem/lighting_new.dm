GLOBAL_LIST_EMPTY(lighting_update_lights) // List of lighting sources  queued for update.
GLOBAL_LIST_EMPTY(lighting_update_corners) // List of lighting corners  queued for update.
GLOBAL_LIST_EMPTY(lighting_update_overlays) // List of lighting overlays queued for update.
GLOBAL_LIST_EMPTY(turfs_with_corners_to_delete)		//list of lighting corners queued for delete.

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 1
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[GLOB.lighting_update_lights.len]|C:[GLOB.lighting_update_corners.len]|O:[GLOB.lighting_update_overlays.len]")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if (CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_overlays()
		initialized = TRUE

	fire(FALSE, TRUE)

	return ..()

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	var/i = 0
	for (i in 1 to GLOB.lighting_update_lights.len)
		var/datum/light_source/L = GLOB.lighting_update_lights[i]

		L.update_corners()

		L.needs_update = LIGHTING_NO_UPDATE

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.lighting_update_lights.Cut(1, i+1)
		i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	for (i in 1 to GLOB.lighting_update_corners.len)
		var/datum/lighting_corner/C = GLOB.lighting_update_corners[i]

		C.update_overlays()
		C.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.lighting_update_corners.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for (i in 1 to GLOB.lighting_update_overlays.len)
		var/atom/movable/lighting_overlay/O = GLOB.lighting_update_overlays[i]

		if (QDELETED(O))
			continue

		O.update()
		O.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.lighting_update_overlays.Cut(1, i+1)
/*		i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK
																					//?? ????? ?????? ????? ????? ???????? ?? ????????? ?????????
	for(var/turf/T in GLOB.turfs_with_corners_to_delete)
		if(T.affecting_lights)
			continue

		if(T.corners)
			var/need_delete = 1
			for(var/datum/lighting_corner/C in T.corners)
				C.update_active()
				if(C.affecting)
					need_delete = 0
					break
			if(need_delete)
				T.lighting_corners_initialised = FALSE
				T.corners = null
		GLOB.turfs_with_corners_to_delete -= T

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
*/

/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()