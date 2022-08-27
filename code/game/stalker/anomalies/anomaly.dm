#define DMG_TYPE_GIB 1
#define DMG_TYPE_BRUTE 2
#define DMG_TYPE_ENERGY 4
#define DMG_TYPE_BURN 8
#define DMG_TYPE_BRAIN 16
#define DMG_TYPE_RADIATION 32
#define DMG_TYPE_IGNITION 64
#define DMG_TYPE_BIO 128
GLOBAL_LIST_EMPTY(anomalies)
GLOBAL_LIST_EMPTY(tesla_balls)
/var/list/obj/item/weapon/spawned_artefacts = list()

/image
	var/obj/anomaly/reference = null

/mob/proc/close_look()
	if(look_incooldown || !client || stat == DEAD)
		return

	look_incooldown = 1
	var/atom/Uloc = loc
	var/list/anomalies_in_view = list()
	for(var/obj/anomaly/A in view())
		if(!A.can_be_spotted)
			continue
		anomalies_in_view += A

	var/sleep_ = look_cooldown / (anomalies_in_view.len ? anomalies_in_view.len : 1)
	var/sleep_timer = min(1, sleep_)
	var/last_spotted = world.time

	var/datum/progressbar/progbar = new(src, look_cooldown, src)

	var/starttime = world.time + 1
	var/list/spotted_turfs = list()
	while(world.time < starttime + look_cooldown)
		progbar.update(world.time - starttime)

		if(stat || weakened || stunned  || loc != Uloc)
			break

		if(anomalies_in_view.len)
			if(world.time >= last_spotted + sleep_)
				last_spotted = world.time
				var/obj/anomaly/A = pick(anomalies_in_view)
				var/blowout_effect = 0
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(H.blowout_effects["eyes"])
						blowout_effect = 1
				var/roll = 0
				if(!(A in anomalies_in_look) && !(A in anomalies_no_look))
					roll = rolld(dice6(3), int - A.int_reduce + artefacts_effects["kirpich"] + blowout_effect, 0)
					if(roll)
						anomalies_in_look[A] = roll - 1
						spawn(6000)
							anomalies_in_look.Remove(A)
					else
						anomalies_no_look[A] = roll
						spawn(6000)
							anomalies_no_look.Remove(A)

				if(A in anomalies_in_look)
					for(var/image/AR in client.images)
						if(AR.reference == A)
							client.images.Remove(AR)
							qdel(AR)
					roll = anomalies_in_look[A]
					var/image/I
					if(!A.range)
						var/turf/stalker/T = get_turf(A)
						if(!(T in spotted_turfs))
							var/unknown_icon = 0
							if(roll < 2)
								unknown_icon = 1
							else if(T.triggers)
								for(var/obj/anomaly/AN in T.triggers - A)
									if(AN.can_be_spotted && AN in anomalies_in_look)
										unknown_icon = 1
										break
							if(unknown_icon)
								I = image('icons/stalker/effects/anomaly_detect.dmi', T, "unknown", layer = 10)
							else
								I = image('icons/stalker/effects/anomaly_detect.dmi', T, A.anomaly_type, layer = 10)
							I.reference = A
							I.name = "Danger"
							spotted_turfs.Add(T)
							client.images.Add(I)
							animate(I, alpha = 0, 600)
							spawn(600)
								if(I)
									client.images.Remove(I)
									qdel(I)
					else
						for(var/turf/stalker/T in range(A.range, A))
							if(!(T in spotted_turfs))
								var/unknown_icon = 0
								if(roll < 2)
									unknown_icon = 1
								else if(T.triggers)
									for(var/obj/anomaly/AN in T.triggers - A)
										if(AN.can_be_spotted && AN in anomalies_in_look)
											unknown_icon = 1
											break
								if(unknown_icon)
									I = image('icons/stalker/effects/anomaly_detect.dmi', T, "unknown", layer = 10)
								else
									I = image('icons/stalker/effects/anomaly_detect.dmi', T, A.anomaly_type, layer = 10)
								I.reference = A
								I.name = "Danger"
								spotted_turfs.Add(T)

								client.images.Add(I)
								animate(I, alpha = 0, 600)
								spawn(600)
									if(I && client)
										client.images.Remove(I)
										qdel(I)
				anomalies_in_view.Remove(A)
		sleep(sleep_timer)

	qdel(progbar)

//	spawn(look_cooldown)
	look_incooldown = 0

/obj/anomaly
	name = "Anomaly"
	icon = 'icons/stalker/anomalies.dmi'
//	unacidable = 1
	anchored = 1
	pass_flags = PASSTABLE | PASSGRILLE
	layer = 4

	var/active = 0
	var/damage_amount = 0 				//Сколько дамажит
	var/damage_type = DMG_TYPE_ENERGY	//Тип дамага
	var/cooldown = 1					//Кулдаун в секундах
	var/anim_time						//Длительность анимации в секундах
	var/incooldown = 0
	var/list/trapped = list()
	var/idle_luminosity = 0
	var/activated_luminosity = 0
	var/sound = null
	var/delay = 0
	var/active_icon_state = null
	var/inactive_icon_state = null
	var/range = 0
	var/int_reduce = 0
	var/can_be_spotted = 1
	var/exp_give = 25
	var/anomaly_type = "unknown"

	var/list/artefacts = list()

/obj/anomaly/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/anomaly/LateInitialize()
	GLOB.anomalies.Add(src)
	if(inactive_icon_state)
		icon_state = inactive_icon_state
	name = ""
	if(idle_luminosity)
		set_light(idle_luminosity)
	for(var/turf/stalker/T in range(range, src))
		if(!T.triggers)
			T.triggers = list()
		T.triggers.Add(src)
		referenced_in(T, "triggers")
	spawn_artefact()

/obj/anomaly/Destroy()
	GLOB.anomalies.Remove(src)
	if(trapped.len)
		trapped.Cut()

	return ..()

/obj/anomaly/examine(mob/user)
	var/word = pick("Это", "А это", "Перед тобой")

	if(desc_ru)
		user << user.client.select_lang("\icon[src]  [word] Аномалия. [desc_ru]","\icon[src] That's an Anomaly [desc]")
	else
		user << user.client.select_lang("\icon[src]  [word] Аномалия. [desc]","\icon[src] That's an Anomaly [desc]")

/*
/obj/anomaly/Crossed(atom/A)
	..()
	if (istype(A,/obj/item/weapon/stalker/bolt) || istype(A,/mob/living))
		src.trapped.Add(A)
		if(src.trapped.len && !incooldown)
			src.Think()

/obj/anomaly/Uncrossed(atom/A)
	..()
	src.trapped.Remove(A)
*/

/obj/anomaly/proc/give_exp()
	for(var/mob/living/carbon/human/H in view(7, src))
		H.give_exp(exp_give, "[initial(name)]_activation", 3)


/obj/anomaly/proc/spawn_artefact()
	if(!artefacts.len)
		return 1

	var/list/turfs = list()
	for(var/turf/T in range(range, src))
		turfs += T

	if(!turfs.len)
		return 1

	for(var/A in artefacts)
		if(prob(artefacts[A]))
			new A(pick(turfs))



/obj/anomaly/proc/Think()
	playsound(src.loc, src.sound, 50, 0, 0, 1, channel = "regular", time = anim_time*10)
	src.set_light(src.activated_luminosity)
	for(var/mob/living/M in src.trapped)
		if(M.stat == DEAD)
			trapped.Remove(M)
			src.Destroy_body(M, 1, 1)
		else
			DealDamage(M)
	src.set_light(src.activated_luminosity)
	flick(active_icon_state, src)
	sleep(src.anim_time * 10)
	src.incooldown = 1
	src.set_light(src.idle_luminosity)
	sleep(src.cooldown*10)
	src.incooldown = 0
	if(src.trapped.len > 0)
		for(var/A in src.trapped)
			if (isnull(A))
				trapped.Remove(A)
		src.Think()
	return


/obj/anomaly/proc/Destroy_body(var/mob/living/M, var/no_brain, var/no_organs, var/no_bodyparts)
	switch(src.damage_type)
		if(DMG_TYPE_ENERGY)
			M.dust()
			return
		if(DMG_TYPE_BIO)
			qdel(M)
			return
		if(DMG_TYPE_BRUTE)
			return
		if(DMG_TYPE_RADIATION)
			return
		if(DMG_TYPE_GIB)
			M.gib(no_brain,no_organs,no_bodyparts)
			return
		if(DMG_TYPE_IGNITION)
			M.fire_act()
			spawn(src.cooldown * 10)
				M.dust()
			return
	return

/obj/anomaly/proc/AffectItem(var/obj/item/I)
	if(I.unacidable != 0)
		return

	I.throw_impact(get_turf(I))
	I.throwing = 0

	sleep(5)

	var/turf/T = get_turf(I)
	var/obj/effect/decal/cleanable/molten_item/Q = new/obj/effect/decal/cleanable/molten_item(T)
	Q.pixel_x = rand(-16,16)
	Q.pixel_y = rand(-16,16)
	Q.desc = "Looks like this was \an [I] some time ago."

	if(istype(I,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = I
		S.do_quick_empty()

	qdel(I)

/obj/anomaly/proc/DealDamage(var/mob/living/M)

	switch(src.damage_type)
		if(DMG_TYPE_ENERGY)
			if(M.wet)
				M.apply_damage(src.damage_amount, BURN*2, null, M.get_newarmor(null, "electro"))
			else
				M.apply_damage(src.damage_amount, BURN, null, M.get_newarmor(null, "electro"))
		if(DMG_TYPE_BIO)
			M.apply_damage(src.damage_amount, BURN, null, M.get_newarmor(null, "bio"))
		if(DMG_TYPE_BRUTE)
			M.apply_damage(src.damage_amount, BRUTE, null, M.get_newarmor(null, "crush"))
		if(DMG_TYPE_RADIATION)
			M.rad_act(damage_amount)
		if(DMG_TYPE_GIB)
			if(M in src.trapped)
				trapped.Remove(M)
				M.gib(1,1)
		if(DMG_TYPE_IGNITION)
			if(!M.wet)
				M.fire_act()
			else
				M.wet = 0

	return

/obj/anomaly/proc/Activate(atom/A)
	return

/obj/anomaly/proc/Deactivate(atom/A)
	return



/obj/anomaly/proc/affect_bolt(obj/item/I)
	return


/*
/obj/anomaly/natural/fire/jarka/AffectItem(var/obj/item/I)
	incooldown = 0

	if(I.unacidable != 0)
		return

	I.throw_impact(get_turf(I))
	I.throwing = 0

	sleep(5)

	var/turf/T = get_turf(I)
	var/obj/effect/decal/cleanable/molten_item/Q = PoolOrNew(/obj/effect/decal/cleanable/molten_item ,T)
	Q.pixel_x = rand(-16,16)
	Q.pixel_y = rand(-16,16)
	Q.desc = "Looks like this was \an [I] some time ago."

	if(istype(I,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = I
		S.do_quick_empty()

	qdel(I)

/obj/anomaly/natural/holodec
	name = ""
	cooldown = 2
	anim_time = 2
	idle_luminosity = 3
	activated_luminosity = 4
	sound = 'sound/stalker/anomalies/buzz_hit.ogg'
	damage_type = DMG_TYPE_BIO
	damage_amount = 30
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = "holodec"
	active_icon_state = "holodec" //needs activation icon
	light_color = rgb(30,160,0)

*/