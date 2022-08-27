/obj/item/ammo_casing/proc/fire(atom/target, mob/living/user, params, distro, quiet, zone_override, burst_pen, spread)
	distro += variance
	for (var/i = max(1, pellets), i > 0, i--)
		var/targloc = get_turf(target)
		ready_proj(target, user, quiet, zone_override, burst_pen)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else if (pellets > 1) //Smart spread
				spread = ((i / pellets) * distro)
		if(!throw_proj(target, targloc, user, params, spread, distro))
			return 0
		if(i > 1)
			newshot()
	if(click_cooldown_override)
		user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return 1

/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override, burst_pen)
	if(!BB)
		return
	BB.original = target
	BB.firer = user
//	if(istype(get_active_held_item(), /obj/item/weapon/gun))	//По идеи не может быть такого что мы стреляем не держа пушку в руке
	BB.gun = user.get_active_held_item()
	BB.burst_penalty = burst_pen
	if(user.targeting && BB.gun)
		BB.add_accuracy = BB.gun.accuracy
	if (zone_override)
		BB.def_zone = zone_override
	else
		BB.def_zone = user.zone_selected
	BB.suppressed = quiet

/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread, distro)
	var/turf/curloc = get_turf(user)
	if (!istype(targloc) || !istype(curloc) || !BB)
		return 0
	BB.ammo_casing = src

	var/firing_dir
	if(BB.firer)
		firing_dir = BB.firer.dir
	if(!BB.suppressed && firing_effect_type)
		new firing_effect_type(get_turf(src), firing_dir)

	var/direct_target
	if(target && (user in range(1, target)))	//if the target is right on our location we'll skip the travelling code in the proj's fire()
		direct_target = target
	if(!direct_target)
		BB.preparePixelProjectile(target, user, params, spread)
	BB.fire(null, direct_target)
	BB = null
	return TRUE

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)


/obj/item/ammo_casing/proc/melt()
	playsound(src, 'sound/stalker/weapons/ammo_melt.ogg', 100, 1, channel = "regular", time = 10)
	if(prob(50))
		var/turf/startloc = get_turf(src)
		var/mob/living/carbon/human/M = new(loc)
		M.invisibility = 101
		M.name = "himself"
		fire(get_step_rand(src), M, zone_override = ran_zone())
		loc = startloc
		spawn(30)
			qdel(M)
//	world << "BB: [BB]"
	qdel(src)