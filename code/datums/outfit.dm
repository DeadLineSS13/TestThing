/datum/outfit
	var/name = "Naked"

	var/uniform = null
	var/suit = null
	var/suit_hard = null
	var/back = null
	var/back2 = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/head_hard = null
	var/mask = null
	var/ears = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/faction_s = null

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for customization depending on client prefs,species etc
	return

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for toggling internals, id binding, access etc
	return

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	pre_equip(H, visualsOnly)

		//Start with uniform,suit,backpack for additional slots
	if(H.client && H.client.loadout.uniform)
		if(faction_s == "Army")
			H.equip_to_slot_or_del(new uniform(H), slot_w_uniform, 0)
			H.str_const = 16
			H.agi_const = 14
			H.hlt_const = 16
			H.int_const = 8
			H.maxHealth = H.str_const*6
			H.psyloss = H.int_const*2
			H.health = H.maxHealth

			H.max_weight = H.str_const*H.str_const/10
			H.enduranceloss = H.hlt_const*H.hlt_const*10
			H.gun_skills = list("smallarm" = 4, "longarm" = 4, "heavy" = 4)
			H.skills = list("melee" = 8, "medic" = 2)
		else
			H.equip_to_slot_or_del(new H.client.loadout.uniform.type(H), slot_w_uniform, 0)
//		world.log << H.client.loadout.uniform.weight
	else if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform, 0)

	if(H.client)
		var/list/loadout_equipment = H.client.loadout.loadout_equipment
		for(var/datum/loadout_equip/LE in loadout_equipment)
			if(LE.item_path)
				var/obj/O = new LE.item_path(H)
				for(var/i = 1 to LE.amount)
					if(i > 1)
						O = new LE.item_path(H)
					if(!H.equip_to_appropriate_slot(O))
						backpack_contents += list(LE.item_path = 1)

				if(istype(O, /obj/item/weapon/gun/projectile))
					var/obj/item/weapon/gun/projectile/G = O
					if(G.mag_type && !ispath(G.mag_type, /obj/item/ammo_box/magazine/internal))
						backpack_contents += list(G.mag_type = 3)
					else if(istype(G, /obj/item/weapon/gun/projectile/automatic/sks))
						backpack_contents += list(LE.ammo_type = 3)
					else if(LE.ammo_type)
						backpack_contents += list(LE.ammo_type = 1)
/*
		var/datum/donation/D = H.client.get_donation("Custom Item")
		if(D && D.items)
			for(var/item_path in D.items)
				var/obj/O = new item_path(H)
				if(!H.equip_to_appropriate_slot(O))
					backpack_contents += list(O.type = 1)
					qdel(O)
*/
		var/datum/donation/D = H.client.get_donation("Custom Beer")
		if(D)
			switch(H.favourite_beer)
				if("razin")
					backpack_contents += list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/razin = 1)
				if("gus")
					backpack_contents += list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/gus = 1)
				if("obolon")
					backpack_contents += list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/obolon = 1)
				if("ohota")
					backpack_contents += list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/ohota = 1)


	if(SSticker && SSticker.mode && SSticker.mode.name == "Battle Royale")
		id = /obj/item/device/battle_royale
	else
		id = /obj/item/weapon/storage/wallet

	if(suit)
		H.equip_to_slot_or_del(new suit(H),slot_wear_suit, 0)
	if(suit_hard)
		H.equip_to_slot_or_del(new suit_hard(H),slot_wear_suit_hard, 0)

	if(H.client && H.client.loadout.backpack)
		switch(H.client.loadout.backpack)
			if("backpack")
				back = /obj/item/weapon/storage/backpack/stalker
			if("satchel")
				back = /obj/item/weapon/storage/backpack/satchel
	if(back)
		H.equip_to_slot_or_del(new back(H),slot_back, 0)
	if(back2)
		H.equip_to_slot_or_del(new back2(H),slot_back2, 0)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),slot_belt, 0)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),slot_gloves, 0)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),slot_shoes, 0)
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head, 0)
	if(head_hard)
		H.equip_to_slot_or_del(new head_hard(H),slot_head_hard, 0)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask, 0)
	if(ears)
		H.equip_to_slot_or_del(new ears(H),slot_ears, 0)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),slot_glasses, 0)
	if(id)
		var/obj/O = new id(H)
		if(istype(O, /obj/item/device/pager) && H.client)
			var/obj/item/device/pager/P = O
			P.money += H.client.loadout.points * 5000
		else if(H.client)
			H.money = H.client.loadout.points * 5000
		H.equip_to_slot_or_del(O,slot_wear_id, 0)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),slot_l_store, 0)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),slot_r_store, 0)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),slot_s_store, 0)

	if(l_hand)
		H.put_in_l_hand(new l_hand(H))
	if(r_hand)
		H.put_in_r_hand(new r_hand(H))

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H),slot_in_backpack, 0)

	H.faction_s = src.faction_s
	switch(H.faction_s)
		if("UA")
			var/image/ua = image('icons/stalker/donbass.dmi', "ua", layer = 18)
			H.add_overlay(ua)
		if("RU")
			var/image/ru = image('icons/stalker/donbass.dmi', "ru", layer = 18)
			H.add_overlay(ru)

//	var/obj/item/device/pager/PG = H.wear_id
//	PG.owner = H
	//var/obj/item/device/stalker_pda/C = H.wear_id
	//if(istype(C))
		//var/datum/job/J = SSjob.GetJob(H.job) // Not sure the best idea
		//C.access = J.get_access()
		//C.registered_name = H.real_name
		//C.faction_s = src.faction_s
		//C.rank = H.rank
		//C.owner = H

	post_equip(H, visualsOnly)


	return 1