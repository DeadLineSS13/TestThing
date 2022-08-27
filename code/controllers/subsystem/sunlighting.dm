#define STAGE_SOURCES  1
#define STAGE_CORNERS  2
#define STAGE_OVERLAYS 3

#define STEP_MORNING 1
#define STEP_DAY 2
#define STEP_EVENING 3
#define STEP_NIGHT 4


GLOBAL_LIST_EMPTY(sunlighting_update_lights) // List of lighting sources  queued for update.
GLOBAL_LIST_EMPTY(sunlighting_update_corners) // List of lighting corners  queued for update.
GLOBAL_LIST_EMPTY(sunlighting_update_overlays) // List of lighting overlays queued for update.

var/list/datum/time_of_day/time_cycle_steps_cloudly = list(new /datum/time_of_day/morning_cloudly(), new /datum/time_of_day/day_cloudly(), \
                                 new /datum/time_of_day/evening_cloudly(), new /datum/time_of_day/night_cloudly())

var/list/datum/time_of_day/time_cycle_steps_sunny = list(new /datum/time_of_day/night_sunny(), new /datum/time_of_day/morning_sunny(), new /datum/time_of_day/day_sunny(), \
                                 new /datum/time_of_day/evening_sunny())


SUBSYSTEM_DEF(sunlighting)
	name = "Sun Lighting"
	wait = 20
	priority = 2
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER

	var/list/currentrun_lights = list()
	var/list/currentrun_corners = list()
	var/list/currentrun_overlays = list()
	var/list/sunlighting_planes = list()

	var/datum/time_of_day/current_step_datum
	var/datum/time_of_day/next_step_datum
	var/current_step
	var/next_step
	var/step_started
	var/step_finish
	var/current_color
	var/list/datum/time_of_day/current_list = null
	var/blowout_started

	var/resuming_stage = 0
	var/old_shadow_height = 2

/datum/controller/subsystem/sunlighting/stat_entry()
	..("L:[GLOB.sunlighting_update_lights.len]|C:[GLOB.sunlighting_update_corners.len]|O:[GLOB.sunlighting_update_overlays.len]")


/datum/controller/subsystem/sunlighting/Initialize(timeofday)
	for(var/area/A in world)
		if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
			A.luminosity = 0

	sunlighting_planes = list()
	current_list = time_cycle_steps_cloudly

	set_time_of_day(STEP_MORNING)

	create_all_sunlighting_overlays()

	check_cycle()
	update_color()

	resuming_stage = STAGE_SOURCES

	while (GLOB.sunlighting_update_lights.len)
		var/datum/sunlight_source/L = GLOB.sunlighting_update_lights[GLOB.sunlighting_update_lights.len]
		GLOB.sunlighting_update_lights.len--

		if (L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if (!L.destroyed)
				L.apply_lum()

		else if (L.vis_update) //We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

	resuming_stage = STAGE_CORNERS

	while (GLOB.sunlighting_update_corners.len)
		var/datum/sunlighting_corner/C = GLOB.sunlighting_update_corners[GLOB.sunlighting_update_corners.len]
		GLOB.sunlighting_update_corners.len--

		C.update_overlays()
		C.needs_update = FALSE

	resuming_stage = STAGE_OVERLAYS

	while (GLOB.sunlighting_update_overlays.len)
		var/atom/movable/sunlighting_overlay/O = GLOB.sunlighting_update_overlays[GLOB.sunlighting_update_overlays.len]
		GLOB.sunlighting_update_overlays.len--

		if (QDELETED(O))
			continue

		O.update_overlay()
		O.needs_update = FALSE
#if defined(LIGHTING_ANIMATION)
		O.animate_color()
#endif
	resuming_stage = 0

	initialized = TRUE

	..()
proc/set_time_of_day(var/step)
	SSsunlighting.set_time_of_day(step)
/datum/controller/subsystem/sunlighting/proc/set_time_of_day(var/step)
	if(step > current_list.len)
		step = STEP_MORNING
		dodaychange()

	switch(step)
		if(STEP_MORNING)
			old_shadow_height = 1.5
		if(STEP_DAY)
			old_shadow_height = 0.5
		if(STEP_EVENING)
			old_shadow_height = -1.5
		if(STEP_NIGHT)
			old_shadow_height = 2

	step_started = world.time
	current_step = step
	current_step_datum = current_list[current_step]
	step_finish = current_step_datum.duration + world.time

	next_step = current_step + 1
	if(next_step > 4)
		next_step = 1
	next_step_datum = current_list[next_step]

	for(var/thing in SStext.areas_entrances)
		SStext.areas_entrances[thing].Cut()

/datum/controller/subsystem/sunlighting/proc/check_cycle()
	if(world.time > step_finish)
		set_time_of_day(current_step + 1)

/datum/controller/subsystem/sunlighting/proc/update_color()
	var/blend_amount
	if(isblowout)
		blend_amount = (world.time - blowout_started) / (BLOWOUT_DURATION_STAGE_I + BLOWOUT_DURATION_STAGE_II + BLOWOUT_DURATION_STAGE_III)
		var/first_blend = BlendRGB(current_step_datum.color, next_step_datum.color,((world.time - step_started) / current_step_datum.duration))
		var/second_blend = BlendRGB(next_step_datum.color,"#870000",((world.time - step_started) / current_step_datum.duration))
		current_color = BlendRGB(first_blend, second_blend, blend_amount)
	else
		blend_amount = (world.time - step_started) / current_step_datum.duration
		current_color = BlendRGB(current_step_datum.color, next_step_datum.color, blend_amount)
	for(var/obj/screen/plane_master/sunlighting/P in sunlighting_planes)
		P.color = P.darkning ? BlendRGB(current_color, "#000000", P.darkning) : current_color
	if(current_step == STEP_MORNING)
		var/new_shadow_height = 1.5 - 1*((world.time - step_started)/current_step_datum.duration)
		if(old_shadow_height - new_shadow_height >= 0.001)
			old_shadow_height = new_shadow_height
			for(var/obj/shadow/S in world_shadows)
				if(!S.anomaly)
					S.SHADOW_HEIGHT = new_shadow_height
					S.shadow_offset = S.parent.icon_height*1.25-round(0.5*S.parent.icon_height*((world.time - step_started)/current_step_datum.duration))
					S.update(S.parent)
					CHECK_TICK
	else if(current_step == STEP_DAY)
		var/new_shadow_height = 0.5 - 2*((world.time - step_started)/current_step_datum.duration)
		if((old_shadow_height - abs(new_shadow_height) >= 0.001) || (abs(new_shadow_height) - old_shadow_height >= 0.001))
			old_shadow_height = new_shadow_height
			for(var/obj/shadow/S in world_shadows)
				if(!S.anomaly)
					S.SHADOW_HEIGHT = new_shadow_height
					S.shadow_offset = S.parent.icon_height*0.75-round(S.parent.icon_height*((world.time - step_started)/current_step_datum.duration))
					S.update(S.parent)
					CHECK_TICK
	else if(current_step == STEP_EVENING)
		if((world.time - step_started) < current_step_datum.duration/2)
			var/new_shadow_height = -1.5 - 0.5*((world.time - step_started)/current_step_datum.duration)
			if((old_shadow_height - new_shadow_height) >= 0.001)
				old_shadow_height = new_shadow_height
				for(var/obj/shadow/S in world_shadows)
					if(!S.anomaly)
						S.SHADOW_HEIGHT = new_shadow_height
						S.shadow_offset = -round(0.25*S.parent.icon_height*((world.time - step_started)/current_step_datum.duration))+1
						S.update(S.parent)
						CHECK_TICK
		else if(old_shadow_height < 0)
			var/new_shadow_height = 0
			if(new_shadow_height > old_shadow_height)
				old_shadow_height = 2
				for(var/obj/shadow/S in world_shadows)
					if(!S.anomaly)
						S.SHADOW_HEIGHT = 0
						S.update(S.parent)
						CHECK_TICK
	else if(current_step == STEP_NIGHT)
		if((world.time - step_started) > current_step_datum.duration/2)
			var/new_shadow_height = 2 - 0.5*((world.time - step_started)/current_step_datum.duration)
			if(abs(old_shadow_height) - abs(new_shadow_height) >= 0.001)
				old_shadow_height = new_shadow_height
				for(var/obj/shadow/S in world_shadows)
					if(!S.anomaly)
						S.SHADOW_HEIGHT = new_shadow_height
						S.shadow_offset = S.parent.icon_height*1.5-round(0.25*S.parent.icon_height*((world.time - step_started)/current_step_datum.duration))
						S.update(S.parent)
						CHECK_TICK


//	if(need_shadow_update)
//		for(var/atom/T in world_trees)
//			T.shadow_update()
//		need_shadow_update = 0

/datum/controller/subsystem/sunlighting/fire()
	check_cycle()
	update_color()

	resuming_stage = STAGE_SOURCES

	while (GLOB.sunlighting_update_lights.len)
		var/datum/sunlight_source/L = GLOB.sunlighting_update_lights[GLOB.sunlighting_update_lights.len]
		GLOB.sunlighting_update_lights.len--

		if (L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if (!L.destroyed)
				L.apply_lum()

		else if (L.vis_update) //We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		if (MC_TICK_CHECK)
			return

	resuming_stage = STAGE_CORNERS

	while (GLOB.sunlighting_update_corners.len)
		var/datum/sunlighting_corner/C = GLOB.sunlighting_update_corners[GLOB.sunlighting_update_corners.len]
		GLOB.sunlighting_update_corners.len--

		C.update_overlays()
		C.needs_update = FALSE
		if (MC_TICK_CHECK)
			return

	resuming_stage = STAGE_OVERLAYS

	while (GLOB.sunlighting_update_overlays.len)
		var/atom/movable/sunlighting_overlay/O = GLOB.sunlighting_update_overlays[GLOB.sunlighting_update_overlays.len]
		GLOB.sunlighting_update_overlays.len--

		if (QDELETED(O))
			continue

		O.update_overlay()
		O.needs_update = FALSE
#if defined(LIGHTING_ANIMATION)
		O.animate_color()
#endif
		if (MC_TICK_CHECK)
			return
	resuming_stage = 0


/datum/controller/subsystem/sunlighting/Recover()
	initialized = SSsunlighting.initialized
	..()

#undef STAGE_SOURCES
#undef STAGE_CORNERS
#undef STAGE_OVERLAYS