/obj/anomaly/natural/magnetise
	name = "magnetise"
	range = 5
	can_be_spotted = 0
	var/list/affected_items = list()
	var/str_dice = 1

/obj/anomaly/natural/magnetise/LateInitialize()
	..()
	SSobj.processing.Add(src)

/obj/anomaly/natural/magnetise/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/anomaly/natural/magnetise/process()
	Think()

/obj/anomaly/natural/magnetise/Think()
	for(var/mob/living/carbon/human/H in trapped)
		var/should_move = 0
		var/obj/item/clothing/C = H.head_hard
		var/obj/item/clothing/AR = H.wear_suit_hard
		var/obj/item/weapon/W = H.back2
		if(C && C.ismetal)
			if(C.ishelmet)
				if(str_dice && !H.resting)
					str_dice = 0
					if(!H.rolld(dice6(3), H.str))
						H.resting = 1
					else
						spawn(50)
							str_dice = 1
			should_move = 1
			H.magniting = 1
		if(AR && AR.ismetal)
			should_move = 1
			H.magniting = 1
		if(W && W.ismetal)
			should_move = 1
			H.magniting = 1

		if(should_move)
			step_towards(H, src)
		else
			H.magniting = 0


/obj/anomaly/natural/magnetise/Activate(atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!(H in trapped))
			trapped.Add(H)

		var/list/items = H.get_all_slots()
		items += H.get_active_held_item()
		items += H.get_inactive_held_item()
		items -= H.wear_suit_hard
		items -= H.wear_suit
		items -= H.head_hard
		items -= H.back2
		for(var/obj/item/I in items)
			if(istype(I, /obj/item/weapon/storage))
				var/obj/item/weapon/storage/S = I
				for(var/obj/item/IT in S.contents)
					if(IT.ismetal)
						S.remove_from_storage(IT, get_turf(A))
						IT.throw_at_fast(get_turf(src), 7, 1)
						if(!(IT in affected_items))
							affected_items.Add(IT)
			if(I.ismetal)
				H.unEquip(I, 0, 1)
				I.throw_at_fast(get_turf(src), 7, 1)
				if(!(I in affected_items))
					affected_items.Add(I)
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		if(istype(I, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = I
			for(var/obj/item/IT in S.contents)
				if(IT.ismetal)
					S.remove_from_storage(IT, get_turf(A))
					IT.throw_at_fast(get_turf(src), 7, 1)
					if(!(IT in affected_items))
						affected_items.Add(IT)
		if(I.ismetal)
			I.throw_at_fast(get_turf(src), 7, 1)
			if(istype(I, /obj/item/projectile))
				spawn(2)
					qdel(I)
			else if(!(I in affected_items))
				affected_items.Add(I)
	give_exp()
	SSstat.anomalies_triggered++

/obj/anomaly/natural/magnetise/Deactivate(atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H in trapped)
			trapped.Remove(H)


/obj/anomaly/natural/pugalo
	name = "pugalo"
	sound = 'sound/stalker/anomalies/pugalo.ogg'
	cooldown = 30
	can_be_spotted = 0
	var/list/mob/living/feared = list()
	var/moving = 0


/obj/anomaly/natural/pugalo/LateInitialize()
	..()
	SSobj.processing.Add(src)
	for(var/obj/structure/stalker/flora/grass/tall_grass/TG in range(15, src))
		TG.triggers.Add(src)

/obj/anomaly/natural/pugalo/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/anomaly/natural/pugalo/process()
	if(incooldown)
		return
	if(moving)
		return
	if(trapped.len)
		var/mob/living/carbon/human/H = get_closest_atom(/mob/living/carbon/human, trapped, src)
		if(H)
			moving = 1
			spawn(19)
				moving = 0
			Move(get_step(src, get_cardinal_dir(src, H)))
			if(src.loc == H.loc)
				if(!(H in feared))
					H << sound(sound, channel = SSchannels.get_channel(30))
					SSstat.anomalies_triggered++
					if(!H.resting)
						H.resting = 1
					var/obj/item/weapon/storage/S = H.back
					if(S)
						for(var/obj/item/I in S.contents)
							S.remove_from_storage(I, get_step(src, pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)))
							sleep(1)
					if(!H.rolld(dice6(3), H.hlt+4))
						H.death(0, 1)
						for(var/mob/living/mob in view() - H)
							mob.give_achievement("An awful show")
					feared.Add(H)
					trapped.Remove(H)
					incooldown = 1
					spawn(cooldown*10)
						incooldown = 0



/obj/anomaly/natural/others/pit
	name = "pit"
	icon = 'icons/stalker/anomalies96.dmi'
	icon_state = "yama"
	can_be_spotted = 0
	pixel_x = -32
	pixel_y = -32
	appearance_flags = 0
	layer = 3.4
	var/obj/effect/pit_marker/PM = null
	var/list/rare_markers = list()

/obj/anomaly/natural/others/pit/LateInitialize()
	if(inactive_icon_state)
		icon_state = inactive_icon_state
	name = ""
	for(var/turf/stalker/T in block(locate(x-1, y, z), locate(x+1, y+1, z)))
		if(!T.triggers)
			T.triggers = list()
		T.triggers.Add(src)
	for(var/obj/effect/pit_marker/constant/P in world)
		PM = P
		break

	for(var/obj/effect/pit_marker/rare/P in world)
		rare_markers.Add(P)

/obj/anomaly/natural/others/pit/Activate(atom/movable/A)
	A.doMove(null)
	A << "<span class='danger'>Ты отправился в свободное падение!</span>"
	SSstat.anomalies_triggered++
	spawn(5 MINUTES)
		var/turf/stalker/T
		if(prob(50))
			var/obj/effect/pit_marker/P = pick(rare_markers)
			if(P)
				T = pick(range(1, P))
		else
			T = pick(range(3, PM))
		A.doMove(T)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(!H.resting)
				H.resting = 1
			for(var/obj/item/organ/limb/L in H.organs)
				var/damage = dice6(2) - 4
				if(damage)
					L.take_damage(damage, 0, 0)
			if(H.stat == DEAD)
				for(var/mob/living/mob in view() - H)
					mob.give_achievement("An awful show")

/obj/effect/pit_marker
	name = "pit marker"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	invisibility = 101

/obj/effect/pit_marker/constant

/obj/effect/pit_marker/rare