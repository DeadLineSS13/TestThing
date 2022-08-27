/obj/anomaly/natural/toxic
	anomaly_type = "toxic"

/obj/anomaly/natural/toxic/rust_puddle
	name = "rust puddle"
	icon_state = "rustpuddle"
	inactive_icon_state = "rustpuddle"
	artefacts = list(/obj/item/artefact/organic/krot = 10)
	range = 3
	can_be_spotted = 0

/obj/anomaly/natural/toxic/rust_puddle/Activate(atom/A)
	if(incooldown)
		return
	incooldown = 1
	icon_state = "rustpuddle_trig"

	give_exp()
	SSstat.anomalies_triggered++

	spawn(10)
		var/obj/effect/particle_effect/smoke/S = new(loc)
		S.color = "#a14318"
		S.amount = 5
		S.lifetime = 30
		S.anomaly_reagent = "rustpuddle"
		S.spread_smoke()

		icon_state = "rustpuddle_end"

/datum/reagent/anomaly/rust_puddle_smoke
	name = "Rust puddle smoke"
	id = "rustpuddle"

/datum/reagent/anomaly/rust_puddle_smoke/on_mob_life(mob/living/M)
	if(current_cycle+600 <= world.time)
		current_cycle = world.time
		M.adjustToxLoss(1)
		M.emote("cough")
		holder.remove_reagent(src.id, 1)



/obj/anomaly/natural/toxic/vedmin_studen
	name = "Vedmin studen"
	icon_state = "holodec"
	inactive_icon_state = "holodec"
	exp_give = 40
	artefacts = list(/obj/item/artefact/others/emerald = 10)
	can_be_spotted = 0
	layer = 3.6

/obj/anomaly/natural/toxic/vedmin_studen/examine(mob/user)
	user.give_achievement("Display of power")
	..()

/obj/anomaly/natural/toxic/vedmin_studen/Crossed(atom/A)
	if(!istype(A, /obj/item/projectile) && !istype(A, /obj/item/artefact) && istype(A, /obj))
		playsound(src, 'sound/stalker/anomalies/buzz_hit.ogg', 50, 0, 0, 1, channel = "regular", time = 15)
		give_exp()
		qdel(A)

	else if(ishuman(A))
		var/mob/living/carbon/human/H = A

		var/obj/item/organ/limb/leg = H.get_organ("l_leg")
		leg.toxic_effects["vedminstuden"] = world.time - 150
		leg = H.get_organ("r_leg")
		leg.toxic_effects["vedminstuden"] = world.time - 150

		H << sanitize_russian(H.client.select_lang("<span class='warning'>Тебя забрызгало шипящей, бурлящей жидкостью!</span>", "<span class='warning'>You've been splattered with sizzling, bubbling liquid!</span>"))

		give_exp()
		SSstat.anomalies_triggered++
		playsound(src, 'sound/stalker/anomalies/buzz_hit.ogg', 50, 0, 0, 1, channel = "regular", time = 15)
	else
		return ..()

/obj/anomaly/natural/toxic/vedmin_studen/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user

	var/obj/item/organ/limb/arm = H.get_organ("[H.held_index_to_dir(H.active_hand_index)]_arm")
	arm.toxic_effects["vedminstuden"] = world.time - 150

	H << sanitize_russian(H.client.select_lang("<span class='warning'>Тебя забрызгало шипящей, бурлящей жидкостью!</span>", "<span class='warning'>You've been splattered with sizzling, bubbling liquid!</span>"))

	playsound(src, 'sound/stalker/anomalies/buzz_hit.ogg', 50, 0, 0, 1, channel = "regular", time = 15)
	give_exp()
	SSstat.anomalies_triggered++

/obj/anomaly/natural/toxic/vedmin_studen/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/artefact))
		playsound(src, 'sound/stalker/anomalies/buzz_hit.ogg', 50, 0, 0, 1, channel = "regular", time = 15)
		give_exp()
		SSstat.anomalies_triggered++
		qdel(I)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.rolld(dice6(3), H.agi))
			give_exp()
			SSstat.anomalies_triggered++
			var/obj/item/organ/limb/arm = H.get_organ("[H.held_index_to_dir(H.active_hand_index)]_arm")
			arm.toxic_effects["vedminstuden"] = world.time - 150
			H << sanitize_russian(H.client.select_lang("<span class='warning'>Тебя забрызгало шипящей, бурлящей жидкостью!</span>", "<span class='warning'>You've been splattered with sizzling, bubbling liquid!</span>"))

/obj/item/pickup(mob/user)
	if(locate(/obj/anomaly/natural/toxic/vedmin_studen) in src.loc)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.rolld(dice6(3), H.agi))
				var/obj/item/organ/limb/arm = H.get_organ("[H.held_index_to_dir(H.active_hand_index)]_arm")
				arm.toxic_effects["vedminstuden"] = world.time - 150
				H << sanitize_russian(H.client.select_lang("<span class='warning'>Тебя забрызгало шипящей, бурлящей жидкостью!</span>", "<span class='warning'>You've been splattered with sizzling, bubbling liquid!</span>"))
				playsound(src, 'sound/stalker/anomalies/buzz_hit.ogg', 50, 0, 0, 1, channel = "regular", time = 15)
				SSstat.anomalies_triggered++
	..()