/mob/living/carbon/human/proc/get_weight()
	. = 0
	var/list/items = get_all_slots()
	for(var/obj/item/I in items + held_items)
		if(istype(I, /obj/item/weapon) && (I == back || I == back2))
			. += I.get_weight(0.5)
		else
			. += I.get_weight()
	if(pulling)
		if(ishuman(pulling))
			var/mob/living/carbon/human/H = pulling
			. += H.get_weight()/2
		else if(istype(pulling, /obj/item))
			var/obj/item/I = pulling
			. += I.get_weight(0.5)

	if(artefacts_effects.len)
		if(artefacts_effects["weight"])
			. += artefacts_effects["weight"]

	. = max(. , 0)

/mob/living/carbon/human/proc/get_max_weight(var/coef = 1)
	. = max_weight * coef
	var/list/items = get_body_slots()
	for(var/obj/item/I in items)
		. += I.get_add_weight()

/mob/living/carbon/human/proc/get_items_wet()
	var/list/items = get_all_slots()
	for(var/obj/item/I in items)
		I.get_wet()

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
//	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
//		return 1
	return 0

/mob/living/carbon/human/canBeHandcuffed()
	return 1

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "Stalker")
	return if_no_job
/*
	var/obj/item/weapon/card/id/id = get_idcard()
	if(id)
		. = id.assignment
	else
		var/obj/item/device/pda/pda = wear_id
		if(istype(pda))
			. = pda.ownjob
		else
			return if_no_id
	if(!.)
		return if_no_job
*/
//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	return real_name
	/*
	var/obj/item/weapon/card/id/id = get_idcard()
	if(id)
		return id.registered_name
	var/obj/item/device/pda/pda = wear_id
	if(istype(pda))
		return pda.owner
	return if_no_id
	*/

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/get_visible_name()
	return "Unknown"
	/*
	var/face_name = get_face_name("")
	var/id_name = get_id_name("")
	if(name_override)
		return name_override
	if(face_name)
		if(id_name && (id_name != face_name))
			return "[face_name] (as [id_name])"
		return face_name
	if(id_name)
		return id_name
	return "Unknown"
	*/

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when Fluacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name(if_no_face="Unknown")
	return real_name
	/*
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return if_no_face
	if( head && (head.flags_inv&HIDEFACE) )
		return if_no_face		//Likewise for hats
	var/obj/item/organ/limb/O = get_organ("head")
	if( !O || (status_flags&DISFIGURED) || (O.brutestate+O.burnstate)>2 || cloneloss>50 || !real_name )	//disfigured. use id-name if possible
		return if_no_face
	return real_name
	*/

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	return if_no_id
/*
	var/obj/item/weapon/storage/wallet/wallet = wear_id
	var/obj/item/device/pda/pda = wear_id
	var/obj/item/weapon/card/id/id = wear_id
	if(istype(wallet))		id = wallet.front_id
	if(istype(id))			. = id.registered_name
	else if(istype(pda))	. = pda.owner
	if(!.) 					. = if_no_id	//to prevent null-names making the mob unclickable
	return
*/
//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

///checkeyeprot()
///Returns a number between -1 to 2
/mob/living/carbon/human/check_eye_prot()
	var/number = ..()
	if(istype(src.head, /obj/item/clothing/head))			//are they wearing something on their head
		var/obj/item/clothing/head/HFP = src.head			//if yes gets the flash protection value from that item
		number += HFP.flash_protect
	if(istype(src.glasses, /obj/item/clothing/glasses))		//glasses
		var/obj/item/clothing/glasses/GFP = src.glasses
		number += GFP.flash_protect
	if(istype(src.wear_mask, /obj/item/clothing/mask))		//mask
		var/obj/item/clothing/mask/MFP = src.wear_mask
		number += MFP.flash_protect
	return number

/mob/living/carbon/human/check_ear_prot()
	if((ears && (ears.flags & EARBANGPROTECT)) || (head && (head.flags & HEADBANGPROTECT)))
		return 1

///tintcheck()
///Checks eye covering items for visually impairing tinting, such as welding masks
///Checked in life.dm. 0 & 1 = no impairment, 2 = welding mask overlay, 3 = You can see jack, but you can't see shit.
/mob/living/carbon/human/tintcheck()
	var/tinted = 0
	if(istype(src.head, /obj/item/clothing/head))
		var/obj/item/clothing/head/HT = src.head
		tinted += HT.tint
	if(istype(src.glasses, /obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/GT = src.glasses
		tinted += GT.tint
	if(istype(src.wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/MT = src.wear_mask
		tinted += MT.tint
	return tinted

/mob/living/carbon/human/abiotic(full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.flags&ABSTRACT )) || (src.r_hand && !( src.r_hand.flags&ABSTRACT )) || (src.back || src.back2 || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.ears || src.gloves)))
		return 1

	if( (src.l_hand && !(src.l_hand.flags&ABSTRACT)) || (src.r_hand && !(src.r_hand.flags&ABSTRACT)) )
		return 1

	return 0

/mob/living/carbon/human/IsAdvancedToolUser()
	return 1//Humans can use guns and such

/mob/living/carbon/human/InCritical()
	return (health <= HEALTH_THRESHOLD_CRIT && stat == UNCONSCIOUS)

/mob/living/carbon/human/reagent_check(datum/reagent/R)
	return dna.species.handle_chemicals(R,src)
	// if it returns 0, it will run the usual on_mob_life for that reagent. otherwise, it will stop after running handle_chemicals for the species.


/mob/living/carbon/human/can_track(mob/living/user)
//	if(wear_id && istype(wear_id.GetID(), /obj/item/weapon/card/id/syndicate))
//		return 0
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = head
		if(hat.blockTracking)
			return 0

	return ..()

/mob/living/carbon/human/get_permeability_protection()
	var/list/prot = list("hands"=0, "chest"=0, /*"groin"=0,*/ "legs"=0, "feet"=0, "arms"=0, "head"=0)
	for(var/obj/item/I in get_equipped_items())
		if(I.body_parts_covered & HANDS)
			prot["hands"] = max(1 - I.permeability_coefficient, prot["hands"])
		if(I.body_parts_covered & CHEST)
			prot["chest"] = max(1 - I.permeability_coefficient, prot["chest"])
//		if(I.body_parts_covered & GROIN)
//			prot["groin"] = max(1 - I.permeability_coefficient, prot["groin"])
		if(I.body_parts_covered & LEGS)
			prot["legs"] = max(1 - I.permeability_coefficient, prot["legs"])
		if(I.body_parts_covered & FEET)
			prot["feet"] = max(1 - I.permeability_coefficient, prot["feet"])
		if(I.body_parts_covered & ARMS)
			prot["arms"] = max(1 - I.permeability_coefficient, prot["arms"])
		if(I.body_parts_covered & HEAD)
			prot["head"] = max(1 - I.permeability_coefficient, prot["head"])
	var/protection = (prot["head"] + prot["arms"] + prot["feet"] + prot["legs"] + /*prot["groin"] + */prot["chest"] + prot["hands"])/7
	return protection

/mob/living/carbon/human/proc/update_traits()
	if(education)
		var/datum/traits/education/E
		E = GLOB.education_list[education]
		str += E.str
		hlt += E.hlt
		agi += E.agi
		int += E.int
		for(var/S in gun_skills)
			switch(S)
				if("longarm")
					gun_skills[S] += E.longarm_skill
				if("smallarm")
					gun_skills[S] += E.smallarm_skill
				if("heavy")
					gun_skills[S] += E.heavy_skill
		for(var/S in skills)
			switch(S)
				if("melee")
					skills[S] += E.melee_skill
				if("medic")
					skills[S] += E.med_skill

	if(profession)
		var/datum/traits/profession/P
		P = GLOB.profession_list[profession]
		str += P.str
		hlt += P.hlt
		agi += P.agi
		int += P.int
		for(var/S in gun_skills)
			switch(S)
				if("longarm")
					gun_skills[S] += P.longarm_skill
				if("smallarm")
					gun_skills[S] += P.smallarm_skill
				if("heavy")
					gun_skills[S] += P.heavy_skill
		for(var/S in skills)
			switch(S)
				if("melee")
					skills[S] += P.melee_skill
				if("medic")
					skills[S] += P.med_skill

	if(lifestyle)
		var/datum/traits/lifestyle/L
		L = GLOB.lifestyle_list[lifestyle]
		str += L.str
		hlt += L.hlt
		agi += L.agi
		int += L.int
		for(var/S in gun_skills)
			switch(S)
				if("longarm")
					gun_skills[S] += L.longarm_skill
				if("smallarm")
					gun_skills[S] += L.smallarm_skill
				if("heavy")
					gun_skills[S] += L.heavy_skill
		for(var/S in skills)
			switch(S)
				if("melee")
					skills[S] += L.melee_skill
				if("medic")
					skills[S] += L.med_skill

	if(trait)
		var/datum/traits/trait/T
		T = GLOB.trait_list[trait]
		str += T.str
		hlt += T.hlt
		agi += T.agi
		int += T.int
		for(var/S in gun_skills)
			switch(S)
				if("longarm")
					gun_skills[S] += T.longarm_skill
				if("smallarm")
					gun_skills[S] += T.smallarm_skill
				if("heavy")
					gun_skills[S] += T.heavy_skill
		for(var/S in skills)
			switch(S)
				if("melee")
					skills[S] += T.melee_skill
				if("medic")
					skills[S] += T.med_skill

	maxHealth = str*6
	psyloss = int*2
	health = maxHealth

	str_const = str
	agi_const = agi
	int_const = int
	hlt_const = hlt

	max_weight = str*str/10
	enduranceloss = hlt*hlt*10

	clients_names[src] += real_name

	for(var/obj/item/organ/limb/O in organs)
		if(!istype(O, /obj/item/organ/limb/chest) && !istype(O, /obj/item/organ/limb/head)) //&& !istype(O, /obj/item/organ/limb/groin))
			O.max_damage = str*2

	if(int <= 10 && hlt <= 10)
		favourite_beer = "razin"
	else if(int >= 11 && hlt <= 10)
		favourite_beer = "gus"
	else if(int >= 11 && hlt >= 11)
		favourite_beer = "obolon"
	else
		favourite_beer = "ohota"

/mob/living/carbon/human/proc/get_uniq_name(var/lang)
	var/skipface = 0
	var/skiphair = 0
	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE
		skiphair |= wear_mask.flags_inv & HIDEHAIR
	if(head_hard)
		skipface |= head_hard.flags_inv & HIDEFACE
		skiphair |= head_hard.flags_inv & HIDEHAIR
	if(head)
		skipface |= head.flags_inv & HIDEFACE
		skiphair |= head.flags_inv & HIDEHAIR

	var/nickname = ""
	var/nickname_en = ""

	switch(str_const)
		if(1 to 7)
			nickname += "[gender == MALE ? "Хилый" : "Хилая"]"
			nickname_en += "a frail"
		if(8 to 9)
			nickname += "[gender == MALE ? "Слабый" : "Слабая"]"
			nickname_en += "a weak"
		if(10)
			nickname += "[gender == MALE ? "Невыделяющийся" : "Невыделяющаяся"]"
			nickname_en += "an average"
		if(11 to 12)
			nickname += "[gender == MALE ? "Крепкий" : "Крепкая"]"
			nickname_en += "a fit"
		if(13 to 14)
			nickname = "[gender == MALE ? "Атлетичный" : "Атлетичная"]"
			nickname_en += "an athletic"
		if(15 to 16)
			nickname += "[gender == MALE ? "Амбалистый" : "Амбалистая"]"
			nickname_en += "a muscular"
		if(17 to INFINITY)
			nickname += "[gender == MALE ? "Перекаченный" : "Перекаченная"]"
			nickname_en += "an overly buff"

	if(!skiphair)
		var/datum/hair_color/HC = GLOB.hair_colors_list[hair_color]
		if(HC)
			nickname += " [HC.desc_ru]оволос[gender == MALE ? "ый" : "ая"]"
			nickname_en += " [HC.desc]"

	if(!skipface)
		switch(age)
			if(0 to 30)
				nickname += " [gender == MALE ? "парень" : "девушка"]"
				nickname_en += " young"
			if(31 to 60)
				nickname += " [gender == MALE ? "мужчина" : "женщина"]"
				nickname_en += " middle-aged"
//			if(46 to 60)
//				nickname += " [gender == MALE ? "немолодой" : "немолодая"]"
//				nickname_en += "n aging"
			if(61 to INFINITY)
				nickname += " [gender == MALE ? "старик" : "старуха"]"
				nickname_en += "n elderly"
	else
		nickname += " [gender == MALE ? "мужчина" : "женщина"]"
		nickname_en += " middle-aged"

	switch(lang)
		if("EN")
			return nickname_en
		if("RU")
			return nickname


/mob/living/carbon/human/proc/blowout_occupation()
	if(!client || !isblowout)
		return

	blowout_effects = list("guns" = 0, "trainings" = 0, "eyes" = 0)
	if(client.language == "Russian")
		switch(input(src, "Выбери занятие на время выброса") in list("Отдохнуть и залечить раны", "Приноровиться к оружию", "Размяться и потренироваться", "Обдумать приметы аномалий"))
			if("Отдохнуть и залечить раны")
				heal_overall_damage(str_const)
				return
			if("Приноровиться к оружию")
				blowout_effects["guns"] = 1
				return
			if("Размяться и потренироваться")
				blowout_effects["trainings"] = 1
				return
			if("Обдумать приметы аномалий")
				blowout_effects["eyes"] = 1
				return
	else
		switch(input(src, "Take an occupation untill blowout end") in list("Relax and heal wounds", "Get used to weapons", "Stretch and practice", "Ponder the signs of anomalies"))
			if("Relax and heal wounds")
				heal_overall_damage(str_const)
				return
			if("Get used to weapons")
				blowout_effects["guns"] = 1
				return
			if("Stretch and practice")
				blowout_effects["trainings"] = 1
				return
			if("Ponder the signs of anomalies")
				blowout_effects["eyes"] = 1
				return