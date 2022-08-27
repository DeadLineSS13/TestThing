/obj/anomaly/natural/fire/jarka
	name = "jarka"
	cooldown = 10
	anim_time = 6.1
	sound = 'sound/stalker/anomalies/zharka1.ogg'
	activated_luminosity = 4
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = ""
	active_icon_state = "jarka1"
	artefacts = list(/obj/item/artefact/fire/crystalblood = 1.5, /obj/item/artefact/fire/chertovrog = 0.5)
	light_color = COLOUR_LTEMP_CANDLE
	anomaly_type = "fire"

/obj/anomaly/natural/fire/jarka/DealDamage(mob/living/M)
	give_exp()
	SSstat.anomalies_triggered++
	if(!M.wet)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/clothing/C = H.get_item_by_slot(slot_wear_suit)
			var/obj/item/clothing/head/CH = H.get_item_by_slot(slot_head)
			if(!C)
				C = H.get_item_by_slot(slot_wear_suit_hard)
			if(!CH)
				CH = H.get_item_by_slot(slot_head_hard)
			if(istype(C, /obj/item/clothing/suit/hooded/sealed) && istype(CH, /obj/item/clothing/head/winterhood/stalker/sealed))
				return
			M.fire_act()
			for(var/obj/item/organ/limb/L in H.organs)
				var/damage = dice6(1)-1
				if(damage)
					L.take_damage(0, 0, damage)
			if(M.stat == DEAD)
				for(var/mob/living/mob in view() - M)
					mob.give_achievement("An awful show")
		else
			M.fire_act()
	else
		M.wet = 0

/obj/anomaly/natural/fire/jarka/Crossed(atom/A)
	..()
	if(isliving(A))
		src.trapped.Add(A)
		if(src.trapped.len && !incooldown)
			src.Think()
		for(var/mob/living/L in range(1, src))
			if(!L.wet)
				L.fire_act()
			else
				L.wet = 0
	affect_bolt(A)


/obj/anomaly/natural/fire/jarka/Uncrossed(atom/A)
	..()
	src.trapped.Remove(A)

/obj/anomaly/natural/fire/jarka/affect_bolt(atom/A)
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(AC.BB)
			for(var/i = 1 to AC.current_stack)
				if(i < AC.current_stack)
					spawn(i)
						var/obj/item/ammo_casing/AC2 = new AC.type(loc)
						AC2.melt()
				else
					AC.melt()

	if(istype(A, /obj/item/weapon/stalker/bolt))
		var/obj/item/weapon/stalker/bolt/B = A
		B.blend_mode = BLEND_OVERLAY
		B.color = "#ff5500"
		B.hot = 1
		animate(B, color = null, 600)
		spawn(300)
			B.hot = 0

/obj/anomaly/natural/fire/demon
	name = "Demon"
	artefacts = list(/obj/item/artefact/fire/korsar = 10)
	exp_give = 80
	cooldown = 5 SECONDS

/obj/effect/demon
	name = "Demon_mother"
	icon = 'icons/stalker/anomalies.dmi'
	icon_state = ""

/obj/effect/demon/New()
	flick("demon", src)
	spawn(3 SECONDS)
		qdel(src)

/obj/effect/demon/Crossed(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		L.fire_act()
		if(ishuman(A))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/organ/limb/O in H.organs)
				var/damage = dice6(1) - 1
				if(damage)
					O.take_damage(0, 0, damage)
			if(H.stat == DEAD)
				for(var/mob/living/mob in view() - H)
					mob.give_achievement("An awful show")

/obj/anomaly/natural/fire/demon/LateInitialize()
	range = dice6(1)+4
	SSobj.processing.Add(src)
	..()

/obj/anomaly/natural/fire/demon/Destroy()
	SSobj.processing.Remove(src)
	return ..()

/obj/anomaly/natural/fire/demon/Activate(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!trapped.Find(L))
			trapped.Add(L)

/obj/anomaly/natural/fire/demon/Deactivate(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		trapped.Remove(L)

/obj/anomaly/natural/fire/demon/process()
	if(incooldown || active || !trapped.len)
		return

	active = 1
	SSstat.anomalies_triggered++
	var/mob/living/target = pick(trapped)

	var/list/turfs = list()
	for(var/turf/T in orange(1, get_turf(target)))
		turfs += T

	var/turf/T = pick(turfs)
	new /obj/effect/demon(T)

	spawn(1.5 SECONDS)
		for(var/mob/living/L in range(1, T))
			L.fire_act()
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				for(var/obj/item/organ/limb/O in H.organs)
					var/damage = dice6(1) - 4
					if(damage)
						O.take_damage(0, 0, damage)
			if(L.stat == DEAD)
				for(var/mob/living/mob in view() - L)
					mob.give_achievement("An awful show")

		give_exp()
		active = 0
		incooldown = 1
		spawn(cooldown)
			incooldown = 0