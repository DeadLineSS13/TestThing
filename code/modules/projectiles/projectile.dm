/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = 0
	unacidable = 1
	pass_flags = PASSTABLE
	mouse_opacity = 0
	hitsound = 'sound/weapons/pierce.ogg'
	ismetal = 1
	var/hitsound_wall = ""
	pressure_resistance = INFINITY
	var/def_zone = ""	//Aiming at
	var/mob/living/firer = null//Who shot it
	var/obj/item/ammo_casing/ammo_casing = null
	var/obj/item/weapon/gun/gun = null
	var/suppressed = 0	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/paused = FALSE	//for suspending the projectile midair
	var/last_projectile_move = 0
	var/last_process = 0
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!

	var/speed = 0.2		//Amount of deciseconds it takes for projectile to travel
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/spread = 0			//amount (in degrees) of projectile spread
	var/legacy = 0			//legacy projectile system
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy

	var/dice_num = 3
	var/damage_add = 0
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/flag = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb
	var/projectile_type = "/obj/item/projectile"
	var/range = 50 //This will de-increment every step. When 0, it will delete the projectile.
		//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/slur = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/stamina = 0
	var/jitter = 0
	var/forcedodge = 0
	var/damagelose = 0
	// 1 to pass solid objects, 2 to pass solid turfs (results in bugs, bugs and tons of bugs)

	var/add_accuracy = 0
	var/pul = PUL0
	var/armp = 0
	var/expan = 0
	var/burst_penalty = 0
	var/isfraction = 0

	var/temporary_unstoppable_movement = FALSE
	var/impact_effect_type

/obj/item/projectile/proc/Range()
	range--
	if(range <= 0 && loc)
		on_range()

/obj/item/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	qdel(src)

/obj/item/projectile/proc/on_hit(atom/target, damage, def_zone)
	var/turf/target_loca = get_turf(target)
	if(!isliving(target))
		if(impact_effect_type)
			if(isfraction)
				for(var/i= 1 to 8)
					new impact_effect_type(target_loca, target)
			else
				new impact_effect_type(target_loca, target)
		return 0
	var/mob/living/L = target

	if(damage > L.str_const/2)
		var/splatter_dir = dir
		if(starting)
			splatter_dir = get_dir(starting, target_loca)
		new/obj/effect/overlay/temp/dir_setting/bloodsplatter(target_loca, splatter_dir)

	var/organ_hit_text = ""
	var/organ_hit_text_ru = ""
	if(L.has_limbs)
		organ_hit_text = " [parse_zone(def_zone)]"
		organ_hit_text_ru = " [parse_zone_ru(def_zone)]"
	if(suppressed)
		var/volume = vol_by_damage()
		playsound(loc, hitsound, volume, 1, -1, channel = "regular", time = 10)
		L << L.client.select_lang("<span class='userdanger'>В твой[organ_hit_text] попадает [name_ru]!</span>", "<span class='userdanger'>[src] hits your[organ_hit_text]!</span>")
	else
		if(hitsound)
			var/volume = vol_by_damage()
			playsound(loc, hitsound, volume, 1, -1, channel = "regular", time = 10)
		if(damage > L.str_const/2)
			L.direct_visible_message("<span class='danger'>DOER hits the[organ_hit_text] from TARGET! Severely damaged!</span>",\
							"<span class='danger'>DOER hits your[organ_hit_text]! Severely damaged!</span>", \
							"<span class='danger'>DOER попадает в[organ_hit_text_ru] TARGET! Нанесен сильный вред!</span>", \
							"<span class='danger'>DOER влетает в твою[organ_hit_text_ru]! Нанесен сильный вред!</span>","danger",src,L)
		else
			L.direct_visible_message("<span class='danger'>DOER hits the[organ_hit_text] TARGET!</span>",\
							"<span class='danger'>DOER hits your[organ_hit_text]!</span>", \
							"<span class='danger'>DOER попадает в[organ_hit_text_ru] TARGET!</span>", \
							"<span class='danger'>DOER попадает в твою[organ_hit_text_ru]!</span>","danger",src,L)
	L.on_hit(src)
	return 1
/*
	var/reagent_note
	if(reagents && reagents.reagent_list)
		reagent_note = " REAGENTS:"
		for(var/datum/reagent/R in reagents.reagent_list)
			reagent_note += R.id + " ("
			reagent_note += num2text(R.volume) + ") "
	add_logs(firer, L, "shot", src, reagent_note)
	return L.apply_effects(stun, weaken, paralyze, irradiate, slur, stutter, eyeblur, drowsy, blocked, stamina, jitter)
*/
/obj/item/projectile/proc/vol_by_damage()
	if(dice6(dice_num)+damage_add)
		return Clamp((dice6(dice_num)+damage_add) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then clamp the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume

/obj/item/projectile/Bump(atom/A)
//	var/datum/point/pcache = trajectory.copy_to()
	var/turf/T = get_turf(A)
/*
	if(check_ricochet(A) && check_ricochet_flag(A) && ricochets < ricochets_max)
		ricochets++
		if(A.handle_ricochet(src))
			on_ricochet(A)
			ignore_source_check = TRUE
			decayedRange = max(0, decayedRange - reflect_range_decrease)
			range = decayedRange
			if(hitscan)
				store_hitscan_collision(pcache)
			return TRUE
*/
	var/distance = get_dist(T, starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	def_zone = ran_zone(def_zone, max(100-(7*distance), 5)) //Lower accurancy/longer range tradeoff. 7 is a balanced number to use.

	if(isturf(A) && hitsound_wall)
		var/volume = CLAMP(vol_by_damage() + 20, 0, 100)
		if(suppressed)
			volume = 5
		playsound(loc, hitsound_wall, volume, 1, -1)

	return process_hit(T, select_target(T, A))

#define QDEL_SELF 1			//Delete if we're not UNSTOPPABLE flagged non-temporarily
#define DO_NOT_QDEL 2		//Pass through.
#define FORCE_QDEL 3		//Force deletion.

/obj/item/projectile/proc/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)		//probably needs to be reworked entirely when pixel movement is done.
	if(QDELETED(src) || !T || !target)		//We're done, nothing's left.
		if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement))
			qdel(src)
		return hit_something
	permutated |= target		//Make sure we're never hitting it again. If we ever run into weirdness with piercing projectiles needing to hit something multiple times.. well.. that's a to-do.
	if(!prehit(target))
		return process_hit(T, select_target(T), qdel_self, hit_something)		//Hit whatever else we can since that didn't work.

	var/result = target.bullet_act(src, def_zone)
	if(result == -1 || forcedodge)
		if(target)
			forcedodge = 0
			var/mob/M = target
			if(ishuman(M))
				M.direct_visible_message("<span class='warning'>DOER barely misses TARGET!</span>","<span class='warning'>DOER barely misses you!</span>", "<span class='warning'>DOER пролетает мимо TARGET!</span>","<span class='warning'>DOER со свистом пролетает мимо!</span>","warning",src,target)
			else
				M.direct_visible_message("<span class='warning'>DOER barely misses TARGET!</span>","<span class='warning'>DOER barely misses you!</span>", "<span class='warning'>DOER пролетает мимо TARGET!</span>","<span class='warning'>DOER со свистом пролетает мимо!</span>","warning",src,target)
		return 0

/*	if(result == BULLET_ACT_FORCE_PIERCE)
		if(!CHECK_BITFIELD(movement_type, UNSTOPPABLE))
			temporary_unstoppable_movement = TRUE
			ENABLE_BITFIELD(movement_type, UNSTOPPABLE)
		return process_hit(T, select_target(T), qdel_self, TRUE)		//Hit whatever else we can since we're piercing through but we're still on the same tile.

	else if(result == BULLET_ACT_TURF)									//We hit the turf but instead we're going to also hit something else on it.
		return process_hit(T, select_target(T), QDEL_SELF, TRUE)
	else		//Whether it hit or blocked, we're done!
*/
	qdel_self = QDEL_SELF
	hit_something = TRUE
	if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement))
		qdel(src)
	return hit_something

#undef QDEL_SELF
#undef DO_NOT_QDEL
#undef FORCE_QDEL

/obj/item/projectile/proc/select_target(turf/T, atom/target)			//Select a target from a turf.
	if((original in T) && can_hit_target(original, permutated, TRUE, TRUE))
		return original
	if(target && can_hit_target(target, permutated, target == original, TRUE))
		return target
	var/list/mob/mobs = list()
	for(var/mob/living/M in T)
		if(!can_hit_target(M, permutated, M == original, TRUE))
			continue
		mobs += M
	var/list/obj/objs = list()
	for(var/obj/O in T)
		if(!can_hit_target(O, permutated, O == original, TRUE))
			continue
		objs += O
	var/obj/O = safepick(objs)
	if(O)
		return O
	//Nothing else is here that we can hit, hit the turf if we haven't.
	if(!(T in permutated) && can_hit_target(T, permutated, T == original, TRUE))
		return T
	//Returns null if nothing at all was found.

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/item/projectile/proc/can_hit_target(atom/target, list/passthrough, direct_target = FALSE, ignore_loc = FALSE)
	if(QDELETED(target))
		return FALSE
	if(firer)
		var/mob/M = firer
		if((target == firer) || (target == firer.loc) || /*(target in firer.buckled_mobs) ||*/ (istype(M) && (M.buckled == target)))
			return FALSE
	if(!ignore_loc && (loc != target.loc))
		return FALSE
	if(target in passthrough)
		return FALSE
	if(target.density)		//This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	return TRUE


/obj/item/projectile/process()
	last_process = world.time
	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		last_projectile_move += world.time - last_process		//Compensates for pausing, so it doesn't become a hitscan projectile when unpaused from charged up ticks.
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = speed > 0? FLOOR(elapsed_time_deciseconds / speed, 1) : -1			//Would be better if a 0 speed made hitscan but everyone hates those so I can't make it a universal system :<

	if(required_moves > SSprojectiles.global_max_tick_moves)
		var/overrun = required_moves - SSprojectiles.global_max_tick_moves
		required_moves = SSprojectiles.global_max_tick_moves
		time_offset += overrun * speed
	time_offset += MODULUS(elapsed_time_deciseconds, speed)

	for(var/i in 1 to required_moves)
		pixel_move(1, FALSE)

/obj/item/projectile/proc/prehit(atom/target)
	return TRUE

/obj/item/projectile/proc/fire(angle, atom/direct_target)
	starting = get_turf(firer)
	if(direct_target)
		direct_target.bullet_act(src, def_zone)
		qdel(src)
		return
	//If no angle needs to resolve it from xo/yo!
	if(isnum(angle))
		setAngle(angle)
	if(spread)
		setAngle(Angle + ((rand() - 0.5) * spread))
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(CLAMP(starting + xo, 1, world.maxx), CLAMP(starting + yo, 1, world.maxy), starting.z)
		setAngle(Get_Angle(src, target))
	original_angle = Angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	trajectory_ignore_forcemove = FALSE
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, SSprojectiles.global_pixel_speed)
	last_projectile_move = world.time
	fired = TRUE
	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSprojectiles, src)
	pixel_move(1, FALSE)	//move it now!

/obj/item/projectile/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, Angle))
			setAngle(var_value)
			return TRUE
		else
			return ..()

/obj/item/projectile/proc/set_pixel_speed(new_speed)
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/item/projectile/proc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	if(!loc || !trajectory)
		return
	last_projectile_move = world.time
	if(!nondirectional_sprite && !hitscanning)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	var/forcemoved = FALSE
	for(var/i in 1 to SSprojectiles.global_iterations_per_move)
		if(QDELETED(src))
			return
		trajectory.increment(trajectory_multiplier)
		var/turf/T = trajectory.return_turf()
		if(!istype(T))
			qdel(src)
			return
		if(T.z != loc.z)
			trajectory_ignore_forcemove = TRUE
			forceMove(T)
			trajectory_ignore_forcemove = FALSE
			if(!hitscanning)
				pixel_x = trajectory.return_px()
				pixel_y = trajectory.return_py()
			forcemoved = TRUE
		else if(T != loc)
			step_towards(src, T)
	if(!hitscanning && !forcemoved && trajectory)
		pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	Range()

//Spread is FORCED!
/obj/item/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)
	trajectory_ignore_forcemove = TRUE
	forceMove(get_turf(source))
	trajectory_ignore_forcemove = FALSE
	starting = get_turf(source)
	original = target
	if(targloc || !params)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(Get_Angle(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		setAngle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(Get_Angle(src, targloc) + spread)
	else
		stack_trace("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		var/list/screenview = getviewsize(user.client.view)
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = ATAN2(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	qdel(trajectory)
	trajectory = null
	ammo_casing = null
	gun = null
	firer = null
	original = null
	starting = null
	return ..()

/obj/item/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	..()
	if(isliving(AM) && AM.density && !checkpass(PASSMOB))
		Bump(AM, 1)

/obj/item/projectile/Move(atom/newloc, dir = NONE)
	. = ..()
	if(.)
		if(temporary_unstoppable_movement)
			temporary_unstoppable_movement = FALSE
		if(fired && can_hit_target(original, permutated, TRUE))
			Bump(original)

/obj/item/projectile/proc/dumbfire(var/dir)
	current = get_ranged_target_turf(src, dir, world.maxx)
	fire()
