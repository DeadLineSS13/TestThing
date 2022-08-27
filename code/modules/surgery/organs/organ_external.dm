/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC


//Old Datum Limbs:
// code/modules/unused/limbs.dm


/obj/item/organ/limb
	name = "limb"
	var/body_part = null
	var/brutestate = 0
	var/burnstate = 0
	var/crush_dam = 0
	var/cut_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/bleeding = 0
	var/crippled = 0
	var/list/embedded_objects = list()
	var/list/toxic_effects = list()



/obj/item/organ/limb/chest
	name = "chest"
	name_ru = "тело"
	desc = "why is it detached..."
	icon_state = "chest"
	max_damage = 200
	body_part = CHEST

/*
/obj/item/organ/limb/groin
	name = "groin"
	name_ru = "пах"
	desc = "why is it detached..."
	icon_state = "chest"
	max_damage = 200
	body_part = GROIN
*/

/obj/item/organ/limb/head
	name = "head"
	name_ru = "голову"
	desc = "what a way to get a head in life..."
	icon_state = "head"
	max_damage = 200
	body_part = HEAD


/obj/item/organ/limb/l_arm
	name = "l_arm"
	name_ru = "левую руку"
	desc = "why is it detached..."
	icon_state = "l_arm"
	max_damage = 20
	body_part = ARM_LEFT


/obj/item/organ/limb/l_leg
	name = "l_leg"
	name_ru = "левую ногу"
	desc = "why is it detached..."
	icon_state = "l_leg"
	max_damage = 20
	body_part = LEG_LEFT


/obj/item/organ/limb/r_arm
	name = "r_arm"
	name_ru = "правую руку"
	desc = "why is it detached..."
	icon_state = "r_arm"
	max_damage = 20
	body_part = ARM_RIGHT


/obj/item/organ/limb/r_leg
	name = "r_leg"
	name_ru = "правую ногу"
	desc = "why is it detached..."
	icon_state = "r_leg"
	max_damage = 20
	body_part = LEG_RIGHT

/obj/item/organ/severedtail
	name = "tail"
	desc = "A severed tail."
	icon_state = "severedtail"
	color = "#161"
	var/markings = "Smooth"

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/organ/limb/proc/take_damage(crush, cut, burn)
	if(owner && (owner.status_flags & GODMODE))	return 0	//godmode
	crush	= max(crush, 0)
	cut		= max(cut,0)
	burn	= max(burn-owner.artefacts_effects["burn_armor"],0)

	if(owner.artefacts_effects["korsar"])
		if(crush || cut)
			if(dice6(1) == 6)
				owner.fire_act()

	if(owner.artefacts_effects["krot"])
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/range = 3
			var/dice_lim = 6
			if(H.artefacts_effects["krot"] > 1)
				range = 5
				dice_lim -= H.artefacts_effects["krot"] - 1
			if(dice6(1) >= dice_lim)
				var/obj/effect/particle_effect/smoke/S = new(get_turf(H))
				S.color = "#a14318"
				S.amount = range
				S.lifetime = 30
				S.anomaly_reagent = "rustpuddle"
				S.spread_smoke()
				if(dice_lim <= 5)
					for(var/obj/item/artefact/organic/krot/K in H.get_artefacts())
						qdel(K)

	if(cut)
		bleeding = 1
		if(owner.artefacts_effects["bleeding_close"])
			spawn(owner.artefacts_effects["bleeding_close"])
				bleeding = 0

	var/all_dmg = crush_dam + cut_dam + burn_dam
	var/allin_dmg = crush + cut + burn

	if(max_damage == owner.str_const*2)
		if(all_dmg < max_damage)
			if(allin_dmg < max_damage)
				if(cut > owner.str_const/2)
					cut = round(owner.str_const/2)
				if(max_damage-all_dmg > allin_dmg)
					crush_dam += crush
					cut_dam += cut
					burn_dam += burn
				else
					if(crush > 0)
						crush_dam = max_damage-cut_dam-burn_dam
					if(cut > 0)
						cut_dam = max_damage-crush_dam-burn_dam
					if(burn > 0)
						burn_dam = max_damage-crush_dam-cut_dam
			else
				if(crush > 0)
					crush_dam = max_damage-cut_dam-burn_dam
				if(cut > 0)
					cut_dam = max_damage-crush_dam-burn_dam
				if(burn > 0)
					burn_dam = max_damage-crush_dam-cut_dam

			if(all_dmg + allin_dmg >= max_damage)
				make_crippled()
			else if(all_dmg + allin_dmg >= owner.str_const)
				if(!owner.rolld(dice6(3), owner.hlt))
					make_crippled()
		else
			make_crippled()
			return 0
	else
		var/can_inflict = max_damage - (crush_dam + cut_dam + burn_dam)
		if(!can_inflict)
			return 0

		if((crush + cut + burn) < can_inflict)
			crush_dam	+= crush
			cut_dam		+= cut
			burn_dam	+= burn
		else
			if(crush > 0)
				crush_dam = max_damage-cut_dam-burn_dam
			if(cut > 0)
				cut_dam = max_damage-crush_dam-burn_dam
			if(burn > 0)
				burn_dam = max_damage-crush_dam-cut_dam
//	world << "Cut dam: [cut_dam]"
//	world << "Crush dam: [crush_dam]"
//	world << "Brute: [cut_dam + crush_dam]"
	return update_organ_icon()

/obj/item/organ/limb/proc/make_crippled()
	if(!crippled)
		crippled = 1
		owner << "Твоя [parse_zone_ru2(name)] обвисает плетью!"
	if(istype(src, /obj/item/organ/limb/l_arm))
		var/obj/item/I = owner.get_item_for_held_index(1)
		owner.unEquip(I)
		if(owner.get_inactive_hand_index() != 1)
			owner.swap_hand()
	else if(istype(src, /obj/item/organ/limb/r_arm))
		var/obj/item/I = owner.get_item_for_held_index(2)
		owner.unEquip(I)
		if(owner.get_inactive_hand_index() != 2)
			owner.swap_hand()
	else
		owner.crippled_leg += 1
	for(var/obj/screen/inventory/hand/S in owner.hud_used.static_inventory)
		S.update_icon()

//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/organ/limb/proc/heal_damage(crush, cut, burn)
	if(crush_dam)
		crush_dam	= max(crush_dam - crush, 0)
	if(crush_dam < crush)
		cut_dam = max(cut_dam - (crush - crush_dam), 0)
	else if(!crush_dam)
		cut_dam = max(cut_dam - cut, 0)
	burn_dam	= max(burn_dam - burn, 0)
	if(!cut_dam && bleeding)
		bleeding = 0
	return update_organ_icon()


//Returns total damage...kinda pointless really
/obj/item/organ/limb/proc/get_damage()
	return crush_dam + cut_dam + burn_dam


//Updates an organ's brute/burn states for use by update_damage_overlays()
//Returns 1 if we need to update overlays. 0 otherwise.
/obj/item/organ/limb/proc/update_organ_icon()
	if(status == ORGAN_ORGANIC) //Robotic limbs show no damage - RR
		var/tbrute	= round( ((crush_dam+cut_dam)/max_damage)*3, 1 )
		var/tburn	= round( (burn_dam/max_damage)*3, 1 )
		if((tbrute != brutestate) || (tburn != burnstate))
			brutestate = tbrute
			burnstate = tburn
			return 1
		return 0

//Returns a display name for the organ
/obj/item/organ/limb/proc/getDisplayName() //Added "Chest" and "Head" just in case, this may not be needed
	switch(name)
		if("l_leg")		return "left leg"
		if("r_leg")		return "right leg"
		if("l_arm")		return "left arm"
		if("r_arm")		return "right arm"
		if("chest")     return "chest"
		if("head")		return "head"
//		if("groin")		return "groin"
		else			return name


//Remove all embedded objects from all limbs on the human mob
/mob/living/carbon/human/proc/remove_all_embedded_objects()
	var/turf/T = get_turf(src)

	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			L.embedded_objects -= I
			I.loc = T

	clear_alert("embeddedobject")

/mob/living/carbon/human/proc/has_embedded_objects()
	. = 0
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			return 1