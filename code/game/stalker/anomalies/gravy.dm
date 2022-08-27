/obj/anomaly/natural/gravy
	anomaly_type = "gravy"

/obj/anomaly/natural/gravy/vortex
	name = "vortex"
	damage_type = DMG_TYPE_GIB
	range = 1
	cooldown = 15
	pixel_x = -32
	pixel_y = -32
	sound = 'sound/stalker/anomalies/gravi_blowout1.ogg'
	icon = 'icons/stalker/anomalies96.dmi'
	inactive_icon_state = ""
	active_icon_state = "voronka"
	exp_give = 40
	artefacts = list(/obj/item/artefact/gravy/puzir = 1.5)
	var/power = 5

/obj/anomaly/natural/gravy/vortex/lelev/LateInitialize()
	if(inactive_icon_state)
		icon_state = inactive_icon_state
	name = ""
	for(var/turf/stalker/T in range(range, src))
		if(!T.triggers)
			T.triggers = list()
		T.triggers.Add(src)

/obj/anomaly/natural/gravy/vortex/LateInitialize()
	..()
	power = rand(3, 10)

/obj/anomaly/natural/gravy/vortex/Crossed(atom/A)
	..()
	if(isliving(A) && !incooldown)
		var/mob/living/M = A
		if(M.stat != DEAD)
			if(!(M in trapped))
				trapped.Add(M)
			M.resting = 1
			M.update_canmove()


//	if(istype(A, /obj/item/projectile))
//		var/obj/item/projectile/P = A
//		var/turf/T = get_turf(src)
//		P.target


/obj/anomaly/natural/gravy/vortex/Activate(atom/A)
	if(!incooldown)
		if(isliving(A))
			var/mob/living/M = A
			if(!trapped.Find(M))
				trapped.Add(M)
				Think()

		if(istype(A, /obj/item))
			var/obj/item/I = A
			if(!trapped.Find(A))
				if(I.get_weight() > power / 10)
					trapped.Add(I)
					Think()
				else
					affect_bolt(I)


/obj/anomaly/natural/gravy/vortex/Deactivate(atom/A)
	if(trapped.Find(A))
		trapped.Remove(A)

/obj/anomaly/natural/gravy/vortex/Think()
	if(active || incooldown)
		return

	active = 1
	SSstat.anomalies_triggered++
	icon_state = active_icon_state
	var/mob/living/M

	for(var/obj/item/I in range(2, src))
		if(!(I in trapped))
			trapped |= I
	for(M in range(2, src))
		if(!(M in trapped))
			trapped |= M

	for(var/i=1 to 3)
		for(var/atom/A in trapped)
			if(!(A in range(range, src)))
				continue
			if(istype(A, /obj/item))
				var/obj/item/I = A
				if(I.get_weight() > power * 10)
					continue
			if(isliving(A))
				var/mob/living/L = A
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.get_weight() > power * 10)
						continue
				L.resting = 1
			step_towards(A, src)
		sleep(10)
	playsound(loc, sound, 50, 0, 0, 1, channel = "regular", time = 20)

	for(M in trapped)
		if(M.loc == loc)
			trapped.Remove(M)
			if(istype(src, /obj/anomaly/natural/gravy/vortex/lelev))
				M.give_achievement("Welcome to the Zone")
			M.gib(1,1)
			for(var/mob/living/mob in view())
				mob.give_achievement("An awful show")
		else if(M in range(2, src))
			M.throw_at(get_step_away(M, src, 3), 3, 1)
			if(!M.resting)
				M.resting = 1
			trapped.Remove(M)
		else
			trapped.Remove(M)

	for(var/obj/item/I in trapped)
		if(I.loc == loc)
			trapped.Remove(I)
			qdel(I)
		else if(I in range(2, src))
			I.throw_at(get_step_away(I, src, 3), 3, 1)
			trapped.Remove(I)
		else
			trapped.Remove(I)

	give_exp()
	incooldown = 1
	active = 0
	icon_state = inactive_icon_state
	spawn(cooldown*10)
		incooldown = 0
		var/mob/living/MB = locate() in range(range, src)
		if(MB)
			Think()
			return
		var/obj/item/I = locate() in range(range, src)
		if(I)
			Think()
			return
	return

/obj/anomaly/natural/gravy/vortex/affect_bolt(obj/item/I)
	if(!trapped.Find(I))
		trapped.Add(I)
	else
		return
	I.throwing = 0
	spawn(1)
		I.loc = loc


/obj/anomaly/natural/gravy/mosquito_net
	name = ""
	range = 3
	artefacts = list(/obj/item/artefact/gravy/puzir = 0.5)
	var/weight_rise = 2
	var/list/affected_items = list()
	can_be_spotted = 1

/obj/anomaly/natural/gravy/mosquito_net/LateInitialize()
	range = rand(1, 3)
	weight_rise = rand(2, 4)
	..()

/obj/anomaly/natural/gravy/mosquito_net/Activate(atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!(H in trapped))
			trapped.Add(H)
//				H.stamina_coef += 1

		var/list/items = H.get_all_slots()
		items += H.get_active_held_item()
		items += H.get_inactive_held_item()
		for(var/obj/item/I in items)
			if(!(I in affected_items))
				if(istype(I, /obj/item/weapon/storage))
					var/obj/item/weapon/storage/S = I
					for(var/obj/item/IT in S.contents)
						IT.weight *= weight_rise
						affected_items.Add(IT)
				I.weight *= weight_rise
				affected_items.Add(I)
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		if(I.throwing)
			I.throwing = 0
		if(!(I in trapped))
			trapped.Add(I)
			if(!(I in affected_items))
				if(istype(I, /obj/item/weapon/storage))
					var/obj/item/weapon/storage/S = I
					for(var/obj/item/IT in S.contents)
						IT.weight *= weight_rise
						affected_items.Add(IT)
				I.weight *= weight_rise
				affected_items.Add(I)

/obj/anomaly/natural/gravy/mosquito_net/Deactivate(atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H in trapped)
			trapped.Remove(H)
//			H.stamina_coef -= 1

		var/list/items = H.get_all_slots()
		items += H.get_active_held_item()
		items += H.get_inactive_held_item()
		for(var/obj/item/I in items)
			if(I in affected_items)
				if(istype(I, /obj/item/weapon/storage))
					var/obj/item/weapon/storage/S = I
					for(var/obj/item/IT in S.contents)
						IT.weight /= weight_rise
						affected_items.Remove(IT)
				I.weight /= weight_rise
				affected_items.Remove(I)
			if(I in trapped)
				trapped.Remove(I)
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		if(I in trapped)
			trapped.Remove(I)
		if(I in affected_items)
			if(istype(I, /obj/item/weapon/storage))
				var/obj/item/weapon/storage/S = I
				for(var/obj/item/IT in S.contents)
					IT.weight /= weight_rise
					affected_items.Remove(IT)
			I.weight /= weight_rise
			affected_items.Remove(I)

/obj/anomaly/natural/gravy/mosquito_net/Destroy()
	for(var/atom/A in trapped)
		Deactivate(A)
	return ..()

/obj/anomaly/natural/gravy/trap
	name = "trap"
	range = 1

/obj/anomaly/natural/gravy/trap/Activate(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.stat != DEAD)
			if(!trapped.Find(L))
				trapped.Add(L)
				SSstat.anomalies_triggered++

/obj/anomaly/natural/gravy/trap/Deactivate(atom/A)
	if(isliving(A))
		if(A in trapped)
			trapped.Remove(A)


/obj/anomaly/natural/gravy/tramplin
	name = "tramplin"
	cooldown = 2
	sound = 'sound/stalker/anomalies/gravi_blowout1.ogg'
	throw_range = 5
	artefacts = list(/obj/item/artefact/gravy/puzir = 1)
	var/mobius = 0
	var/wait_sleep = 0

/obj/anomaly/natural/gravy/tramplin/LateInitialize()
	..()
	if(!mobius)
		dir =  pick(NORTH, SOUTH, WEST, EAST)
	name = ""

/obj/anomaly/natural/gravy/tramplin/Crossed(atom/A)
	if(isliving(A))
		var/mob/living/M = A
		if(!trapped.Find(M))
			trapped.Add(M)

	if(istype(A, /obj/item/projectile))
		var/obj/item/projectile/P = A
		var/target = get_turf(src)

		if(get_dir(target, P.starting) == dir)
			return
		trapped.Add(P)

	if(istype(A, /obj/item))
		var/obj/item/I = A
		if(!trapped.Find(I))
			trapped.Add(I)

	if(trapped.len && !incooldown)
		Think(A)

/obj/anomaly/natural/gravy/tramplin/Think(atom/movable/A)
	if(active || incooldown)
		return

	active = 1
	SSstat.anomalies_triggered++
	sleep(wait_sleep)
	var/damage = dice6(1) - (mobius ? 5 : 0)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!H.resting)
			H.resting = 1
		if(damage > 0)
			H.damage_apply(damage, 0, 0, H.get_organ(ran_zone()))
		if(H.stat == DEAD)
			for(var/mob/living/mob in view() - H)
				mob.give_achievement("An awful show")

	var/target = get_turf(src)

	for(var/o=0, o<throw_range, o++)
		target = get_step(target, dir)

	trapped.Remove(A)

	A.throw_at(target, throw_range, 1, spin=1, speed_sleep = wait_sleep+1)

	give_exp()
	active = 0
	if(cooldown)
		incooldown = 1
		spawn(cooldown*10)
			incooldown = 0
	return

/obj/anomaly/natural/gravy/mobius
	name = "Mobius"
	can_be_spotted = 0
	artefacts = list(/obj/item/artefact/others/spike = 25)
	var/list/tramplins = list()


/obj/anomaly/natural/gravy/mobius/LateInitialize()
	..()

	for(var/i = 0, i < 3, i+=2)
		for(var/j = 0, j < 7, j+=2)
			var/obj/anomaly/natural/gravy/tramplin/TR = new()
			TR.mobius = 1
			TR.throw_range = 2
			TR.cooldown = 0
			TR.wait_sleep = 3
			tramplins += TR
			var/turf/stalker/T = locate(x+i,y+j,z)
			TR.loc = T
			if(T && !T.density && !T.triggers)
				T.triggers = list()
			T.triggers.Add(src)

	tramplins[1].dir = NORTH
	tramplins[2].dir = NORTHEAST
	tramplins[3].dir = SOUTHEAST
	tramplins[4].dir = SOUTH
	tramplins[5].dir = WEST
	tramplins[6].dir = SOUTH
	tramplins[7].dir = NORTH
	tramplins[8].dir = WEST

	SSobj.processing.Add(src)

/obj/anomaly/natural/gravy/mobius/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/anomaly/natural/gravy/mobius/Activate(atom/A)
	if(!trapped.Find(A))
		trapped.Add(A)

/obj/anomaly/natural/gravy/mobius/Deactivate(atom/A)
	if(trapped.Find(A))
		trapped.Remove(A)

/obj/anomaly/natural/gravy/mobius/process()
	var/curweight = 0
	for(var/atom/A in trapped)
		if(isliving(A))
			curweight += 10
		if(isitem(A))
			var/obj/item/I = A
			curweight += I.w_class
	if(curweight >= 30)
		give_exp()
		for(var/obj/anomaly/natural/gravy/tramplin/T in tramplins)
			T.incooldown = 1
			spawn(300)
				T.incooldown = 0

	trapped.Cut()