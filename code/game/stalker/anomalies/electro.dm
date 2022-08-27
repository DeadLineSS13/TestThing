/obj/anomaly/natural/electro
	name = "electra"
	cooldown = 5
	range = 1
	anim_time = 0.96
	sound = 'sound/stalker/anomalies/electra_blast1.ogg'
	activated_luminosity = 4
	inactive_icon_state = ""
	active_icon_state = "electra1"
	light_color = COLOUR_LTEMP_SKY_CLEAR
	artefacts = list(/obj/item/artefact/electro/mozaika = 1.5)
	anomaly_type = "electro"

/obj/anomaly/natural/electro/Activate(atom/A)
	if(isliving(A))
		var/mob/living/M = A
		if(M.stat != DEAD)
			if(!(M in trapped))
				trapped.Add(M)
	else if(A.ismetal)
		if(!(A in trapped))
			trapped.Add(A)
	if(trapped.len)
		Think()

/obj/anomaly/natural/electro/Deactivate(atom/A)
	if(A in trapped)
		trapped.Remove(A)

/obj/anomaly/natural/electro/Think()
	if(active || incooldown)
		return
	active = 1
	SSstat.anomalies_triggered++
	playsound(src.loc, src.sound, 50, 0, 0, 1, , channel = "regular", time = 15)
	set_light(src.activated_luminosity)
	for(var/mob/living/M in trapped)
		var/damage = dice6(4)
		damage *= (M.wet ? 1 : 2) * (M.artefacts_effects["zapzap"] ? 2 : 1)
//		world << "damage: [damage]"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/limb/affected = H.get_organ(ran_zone("chest", 65))
			var/armor = H.get_newarmor(affected, "burn")
//			world << "armor: [armor]"
			H.damage_apply(0, 0, damage-(armor/2), affected, src)
		else
			M.damage_apply(0, 0, damage, null, src)
		if(M.stat == DEAD)
			for(var/mob/living/mob in view() - M)
				mob.give_achievement("An awful show")
		if(!M.rolld(dice6(3), M.hlt))
			M.Paralyse(10)
	set_light(src.activated_luminosity)
	flick(active_icon_state, src)
	sleep(anim_time * 10)
	incooldown = 1
	active = 0
	set_light(src.idle_luminosity)
	trapped.Cut()
	give_exp()
	spawn(cooldown*10)
		incooldown = 0
		for(var/atom/A in range(range, src))
			if((ishuman(A) || A.ismetal) && !(trapped.Find(A)))
				if(A.ismetal && prob(10))
					qdel(A)
				else
					trapped.Add(A)
				Think()
	return


/obj/anomaly/natural/tesla_ball
	name = "tesla_ball"
	icon_state = "vaflya"
	active_icon_state = "vaflya_trig"
	sound = 'sound/stalker/anomalies/electra_blast1.ogg'
	idle_luminosity = 3
	activated_luminosity = 5
	cooldown = 5
	light_color = COLOUR_LTEMP_SKY_CLEAR
	layer = 5
	can_be_spotted = 0
	exp_give = 40
	var/move_num = 0
	var/minded = 1

/obj/anomaly/natural/tesla_ball/examine(mob/user)
	user.give_achievement("Display of power")
	..()

/obj/anomaly/natural/tesla_ball/LateInitialize()
	..()
	range = 3
	GLOB.tesla_balls.Add(src)
	SSteslas.processing.Add(src)
	set_light(idle_luminosity)

/obj/anomaly/natural/tesla_ball/Destroy()
	GLOB.tesla_balls.Remove(src)
	SSteslas.processing.Remove(src)
	return ..()

/obj/anomaly/natural/tesla_ball/process()
	if(!move_num && minded)
		move_num = dice6(3)
		dir = pick(GLOB.cardinal)
	else if(minded)
		move_num -= 1
		if(active)
			var/mob/living/target
			var/closest = 10
			for(var/mob/living/L in range(10, src))
				var/dist = get_dist(src, L)
				if(dist < closest)
					closest = dist
					target = L
			if(target)
				Move(get_step(src, get_cardinal_dir(src, target)))
		else
			if(!Move(get_step(src, dir)))
				move_num = dice6(3)
				dir = pick(GLOB.cardinal)

	for(var/atom/A in range(range, src))
		if(!(A in trapped))
			if(A.ismetal || isliving(A))
				trapped.Add(A)

	for(var/atom/A in trapped)
		if(!(A in range(range, src)))
			trapped.Remove(A)

	Think()
	update_light()


/obj/anomaly/natural/tesla_ball/Crossed(atom/A)
	if(!istype(A, /obj/item) && !isliving(A))
		return
	if(isliving(A))
		var/mob/living/M = A
		M.dust()

	if(!active && minded)
		active = 1
		range = 5
		icon_state = active_icon_state
		set_light(activated_luminosity)
		spawn(600)
			qdel(src)

/obj/anomaly/natural/tesla_ball/Think()
	if(incooldown || !trapped.len)
		return

	SSstat.anomalies_triggered++
	playsound(src.loc, src.sound, 50, 0, 0, 1, channel = "regular", time = 15)
	for(var/mob/living/M in trapped)
		var/damage = active ? dice6(4) : dice6(2)
		damage *= (M.wet ? 1 : 2) * (M.artefacts_effects["zapzap"] ? 1 : 2)
//		world << "damage: [damage]"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/limb/affected = H.get_organ(ran_zone("chest", 65))
			var/armor = H.get_newarmor(affected, "burn")
//			world << "armor: [armor]"
			H.damage_apply(0, 0, damage-(armor/2), affected, src)
		else
			M.damage_apply(0, 0, damage, null, src)
		if(M.stat == DEAD)
			for(var/mob/living/mob in view() - M)
				mob.give_achievement("An awful show")
		if(!M.rolld(dice6(3), M.hlt))
			M.Paralyse(10)
		M.do_jitter_animation(1000)
	for(var/atom/A in trapped)
		Beam(A,icon_state="lightning[rand(1,12)]",icon='icons/effects/effects.dmi',time=3)
	src.incooldown = 1
	give_exp()
	spawn(cooldown*10)
		incooldown = 0


/obj/anomaly/natural/tesla_ball_double
	name = "tesla_ball_double"
	can_be_spotted = 0
	var/obj/anomaly/natural/tesla_ball/first
	var/obj/anomaly/natural/tesla_ball/second
	var/list/path1 = list(NORTH,NORTHEAST,NORTH,NORTHEAST,EAST,NORTHEAST,EAST,EAST,SOUTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHEAST,SOUTH,SOUTH,SOUTHWEST,SOUTH,SOUTHWEST,WEST,SOUTHWEST,WEST,WEST,NORTHWEST,WEST,NORTHWEST,NORTH,NORTHWEST,NORTH)
	var/list/path2 = list(SOUTH,SOUTHWEST,SOUTH,SOUTHWEST,WEST,SOUTHWEST,WEST,WEST,NORTHWEST,WEST,NORTHWEST,NORTH,NORTHWEST,NORTH,NORTH,NORTHEAST,NORTH,NORTHEAST,EAST,NORTHEAST,EAST,EAST,SOUTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHEAST,SOUTH)
	var/lenth = 0

/obj/anomaly/natural/tesla_ball_double/LateInitialize()
	..()
	var/turf/T = get_turf(src)
	var/turf/Tnew = locate(T.x-5, T.y, T.z)
	first = new/obj/anomaly/natural/tesla_ball(Tnew)
	first.minded = 0
	Tnew = locate(T.x+5, T.y, T.z)
	second = new/obj/anomaly/natural/tesla_ball(Tnew)
	second.minded = 0
	lenth = path1.len
	SSobj.processing.Add(src)

/obj/anomaly/natural/tesla_ball_double/Destroy()
	SSobj.processing.Remove(src)
	return ..()


/obj/anomaly/natural/tesla_ball_double/process()
	if(lenth < path1.len)
		lenth += 1
	else
		lenth = 1
	if(!first)
		if(second)
			qdel(second)
			qdel(src)
	if(!second)
		if(first)
			qdel(first)
			qdel(src)
	if(first)
		first.Move(get_step(first, path1[lenth]))
	if(second)
		second.Move(get_step(second, path2[lenth]))






/obj/anomaly/natural/tesla_ball_royale
	icon_state = "vaflya"
	layer = 30
	plane = 30
	opacity = 1
	var/move_dir = NORTH
	var/steps = 0
	var/walk_delay = 0

/obj/anomaly/natural/tesla_ball_royale/LateInitialize()
	..()

/obj/anomaly/natural/tesla_ball_royale/proc/pizduy()
	walk(src, move_dir, walk_delay)
	spawn(steps*walk_delay)
		walk(src, 0)
		switch(move_dir)
			if(NORTH)
				if((src.x < SSbr_zone.c0.x) || (src.x > SSbr_zone.c1.x))
					qdel(src)
			if(SOUTH)
				if((src.x < SSbr_zone.c0.x) || (src.x > SSbr_zone.c1.x))
					qdel(src)
			if(EAST)
				if((src.y < SSbr_zone.c0.y) || (src.y > SSbr_zone.c1.y))
					qdel(src)
			if(WEST)
				if((src.y < SSbr_zone.c0.y) || (src.y > SSbr_zone.c1.y))
					qdel(src)

/obj/anomaly/natural/tesla_ball_royale/Move(NewLoc, direct)
	if(NewLoc)
		loc = NewLoc
		for(var/atom/A in NewLoc)
			A.Crossed(src)

/obj/anomaly/natural/tesla_ball_royale/Crossed(atom/A)
	if(isliving(A))
		var/mob/living/M = A
		M.dust()