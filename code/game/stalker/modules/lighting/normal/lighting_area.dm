//Makes a tile fully lit no matter what
/obj/effect/fullbright
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_ADD

/area
	luminosity           = TRUE
	var/dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	var/open_space		 = FALSE

/area/proc/set_dynamic_lighting(var/new_dynamic_lighting = DYNAMIC_LIGHTING_ENABLED)
	if (new_dynamic_lighting == dynamic_lighting)
		return FALSE

	dynamic_lighting = new_dynamic_lighting

	if (IS_DYNAMIC_LIGHTING(src))
		cut_overlay(/obj/effect/fullbright)
		for (var/turf/T in src)
			if (IS_DYNAMIC_LIGHTING(T))
				T.lighting_build_overlay()

	else
		add_overlay(/obj/effect/fullbright)
		for (var/turf/T in src)
			if (T.lighting_overlay)
				T.lighting_clear_overlay()

	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("dynamic_lighting")
			set_dynamic_lighting(var_value)
			return TRUE
	return ..()