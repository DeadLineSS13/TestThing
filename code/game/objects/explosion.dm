//TODO: Flash range does nothing currently

/proc/trange(Dist=0,turf/Center=null)//alternative to range (ONLY processes turfs and thus less intensive)
	if(Center==null) return

	//var/x1=((Center.x-Dist)<1 ? 1 : Center.x-Dist)
	//var/y1=((Center.y-Dist)<1 ? 1 : Center.y-Dist)
	//var/x2=((Center.x+Dist)>world.maxx ? world.maxx : Center.x+Dist)
	//var/y2=((Center.y+Dist)>world.maxy ? world.maxy : Center.y+Dist)

	var/turf/x1y1 = locate(((Center.x-Dist)<1 ? 1 : Center.x-Dist),((Center.y-Dist)<1 ? 1 : Center.y-Dist),Center.z)
	var/turf/x2y2 = locate(((Center.x+Dist)>world.maxx ? world.maxx : Center.x+Dist),((Center.y+Dist)>world.maxy ? world.maxy : Center.y+Dist),Center.z)
	return block(x1y1,x2y2)


/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, ignorecap = 0, flame_range = 0 ,silent = 0)
	src = null	//so we don't abort once src is deleted
	epicenter = get_turf(epicenter)

	// Archive the uncapped explosion for the doppler array
//	var/orig_dev_range = devastation_range
//	var/orig_heavy_range = heavy_impact_range
//	var/orig_light_range = light_impact_range

	if(!ignorecap)
		// Clamp all values to MAX_EXPLOSION_RANGE
		devastation_range = min (MAX_EX_DEVESTATION_RANGE, devastation_range)
		heavy_impact_range = min (MAX_EX_HEAVY_RANGE, heavy_impact_range)
		light_impact_range = min (MAX_EX_LIGHT_RANGE, light_impact_range)
		flash_range = min (MAX_EX_FLASH_RANGE, flash_range)
		flame_range = min (MAX_EX_FLAME_RANGE, flame_range)

	spawn(0)
		var/start = world.timeofday
		if(!epicenter) return

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flame_range)
		var/list/cached_exp_block = list()

		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range], [flame_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range], [flame_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")

		// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
		// Stereo users will also hear the direction of the explosion!

		// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
		// 3/7/14 will calculate to 80 + 35

		var/far_dist = 0
		far_dist += heavy_impact_range * 5
		far_dist += devastation_range * 20

		if(!silent)
			var/frequency = get_rand_frequency()
			for(var/mob/M in GLOB.player_list)
				// Double check for client
				if(M && M.client)
					var/turf/M_turf = get_turf(M)
					if(M_turf && M_turf.z == epicenter.z)
						var/dist = get_dist(M_turf, epicenter)
						// If inside the blast radius + world.view - 2
						if(dist <= round(max_range + world.view - 2, 1))
							M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
						// You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
						else if(dist <= far_dist)
							var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
							far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
							M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

		//postpone processing for a bit
		var/postponeCycles = max(round(devastation_range/8),1)
		SSlighting.postpone(postponeCycles)
		SSmachines.postpone(postponeCycles)

		if(heavy_impact_range > 1)
			var/datum/effect_system/explosion/E = new/datum/effect_system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y
		var/z0 = epicenter.z

		var/list/affected_turfs = trange(max_range, epicenter)

		if(CONFIG_GET(flag/reactionary_explosions))
			for(var/turf/T in affected_turfs) // we cache the explosion block rating of every turf in the explosion area
				cached_exp_block[T] = 0
				if(T.density && T.explosion_block)
					cached_exp_block[T] += T.explosion_block

				for(var/obj/structure/window/W in T)
					if(W.reinf && W.fulltile)
						cached_exp_block[T] += W.explosion_block

		for(var/turf/T in affected_turfs)

			var/dist = cheap_hypotenuse(T.x, T.y, x0, y0)

			if(CONFIG_GET(flag/reactionary_explosions))
				var/turf/Trajectory = T
				while(Trajectory != epicenter)
					Trajectory = get_step_towards(Trajectory, epicenter)
					dist += cached_exp_block[Trajectory]

			var/flame_dist = 0
			var/throw_dist = dist

			if(dist < flame_range)
				flame_dist = 1

			if(dist < devastation_range)		dist = 1
			else if(dist < heavy_impact_range)	dist = 2
			else if(dist < light_impact_range)	dist = 3
			else 								dist = 0

			//------- TURF FIRES -------

			if(T)
				if(flame_dist && prob(40) && !istype(T, /turf/space) && !T.density)
					new/obj/effect/hotspot(T) //Mostly for ambience!
				if(dist > 0)
					T.ex_act(dist)

			//--- THROW ITEMS AROUND ---

			var/throw_dir = get_dir(epicenter,T)
			for(var/obj/item/I in T)
				if(I && !I.anchored)
					var/throw_range = rand(throw_dist, max_range)
					var/turf/throw_at = get_ranged_target_turf(I, throw_dir, throw_range)
					I.throw_speed = 4 //Temporarily change their throw_speed for embedding purposes (Reset when it finishes throwing, regardless of hitting anything)
					I.throw_at_fast(throw_at, throw_range, 2)//Throw it at 2 speed, this is purely visual anyway.


		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(GLOB.Debug2)	world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

	return 1



/proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in trange(range, epicenter))
		tile.ex_act(2)


/client/proc/check_bomb_impacts()
	set name = "Check Bomb Impact"
	set category = "Debug"

	var/newmode = alert("Use reactionary explosions?","Check Bomb Impact", "Yes", "No")
	var/turf/epicenter = get_turf(mob)
	if(!epicenter)
		return

	var/dev = 0
	var/heavy = 0
	var/light = 0
	var/list/choices = list("Small Bomb","Medium Bomb","Big Bomb","Custom Bomb")
	var/choice = input("Bomb Size?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			dev = 1
			heavy = 2
			light = 3
		if("Medium Bomb")
			dev = 2
			heavy = 3
			light = 4
		if("Big Bomb")
			dev = 3
			heavy = 5
			light = 7
		if("Custom Bomb")
			dev = input("Devestation range (Tiles):") as num
			heavy = input("Heavy impact range (Tiles):") as num
			light = input("Light impact range (Tiles):") as num

	var/max_range = max(dev, heavy, light)
	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/list/wipe_colours = list()
	for(var/turf/T in trange(max_range, epicenter))
		wipe_colours += T
		var/dist = cheap_hypotenuse(T.x, T.y, x0, y0)

		if(newmode == "Yes")
			var/turf/TT = T
			while(TT != epicenter)
				TT = get_step_towards(TT,epicenter)
				if(TT.density && TT.explosion_block)
					dist += TT.explosion_block

				for(var/obj/structure/window/W in TT)
					if(W.explosion_block && W.fulltile)
						dist += W.explosion_block

//				for(var/obj/effect/blob/B in T)
//					dist += B.explosion_block

		if(dist < dev)
			T.color = "red"
			T.maptext = "Dev"
		else if (dist < heavy)
			T.color = "yellow"
			T.maptext = "Heavy"
		else if (dist < light)
			T.color = "blue"
			T.maptext = "Light"
		else
			continue

	sleep(100)
	for(var/turf/T in wipe_colours)
		T.color = null
		T.maptext = ""


