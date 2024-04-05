var/list/trash_tier_sidormatitems = list()
var/list/low_tier_sidormatitems = list()
var/list/medium_tier_sidormatitems = list()
var/list/high_tier_sidormatitems = list()

var/list/sidorRooms = list()
var/obj/sidor_enter/sidorEnter = null

/obj/sidor_enter
	var/roomtype = "sidor"
	invisibility = 101

/obj/sidor_enter/New()
	sidorEnter = src

/obj/sidor_enter/Crossed(atom/movable/A)
	SendToEmptyRoom(A)

/obj/sidor_enter/proc/SendToEmptyRoom(atom/movable/A)
	var/obj/sidor_exit/Room = GetEmptyRoom()
	if(Room)
		A.loc = Room.loc
		if(istype(A,/mob/living/carbon/human))
			Room.occupant = A

/obj/sidor_enter/proc/GetEmptyRoom()
	for(var/obj/sidor_exit/R in sidorRooms)
		if(R.roomtype != roomtype)
			continue
		if(!R.occupant)
			return R
		else if(R.occupant.stat == DEAD)
			return R
	world << "<b>Матрица Сидоровичей дала сбой: Недостаточно комнат!</b>"
	return


/obj/sidor_exit
	var/roomtype = "sidor"
	var/mob/living/carbon/human/occupant = null
	invisibility = 101

/obj/sidor_exit/New()
	sidorRooms.Add(src)

/obj/sidor_exit/Crossed(atom/movable/A)
	A.loc = sidorEnter.loc
	if(istype(A,/mob/living/carbon/human))
		occupant = null
		A << sound(null)
/*
/obj/effect/step_trigger/sound_effect/sidor_enter //Сидор приветствует и прощается с игроком, путем проигрывания аудиозаписей
	sound = "sidor_enter"
	var/sound1 = "sidor_exit"
	var/sound2 = 'sound/stalker/mobs/sidor/sidor_music.ogg'
	volume = 90
	freq_vary = 0
	extra_range = 0
	triggerer_only = 1
	mobs_only = TRUE
	var/triggered = 0
	var/triggmusic = 0


/obj/effect/step_trigger/sound_effect/sidor_enter/Trigger(mob/M)
	var/turf/T = get_turf(M)

	if(!T)
		return

	if(triggered)
		return

//	world << "[M.dir]"
	if(M.dir == NORTH)
		if(!triggmusic)
			M.playsound_local(T, sound2, 70, freq_vary)
			triggmusic = 1

	if(M.dir == NORTH)
		M.playsound_local(T, sound, volume, freq_vary)
		triggered = 1
		spawn(30)
			triggered = 0
	else
		if(M.dir == SOUTH)
			M.playsound_local(T, sound1, volume, freq_vary)
			triggmusic = 0
			triggered = 1
			spawn(30)
				triggered = 0
*/
/*	if(triggerer_only)
		M.playsound_local(T, sound, volume, freq_vary)
	else
		playsound(T, sound, volume, freq_vary, extra_range)

	if(happens_once)
		qdel(src)*/

/*
/obj/machinery/stalker
	icon = 'icons/stalker/structure/decor.dmi'

/obj/machinery/stalker/sidormat
	name = "Sidormat"
	desc = "An equipment vendor for beginning stalkers."
	icon_state = "radio"
	density = 1
	anchored = 1
	var/itemloc = null
	var/itemloc2 = null
	var/balance = 0
	var/rating = 0
	var/switches = 0
	var/real_assorment = list()
	var/list/special_factions = list("Loners", "Bandits")
	var/path_ending = null
	//Faction Locker
	var/obj/item/device/assembly/control/door_device = null

/datum/data/stalker_equipment
	//var/name = "generic"
	var/name_ru = "generic"
	var/equipment_path = null
	var/cost = 0
	var/rating = 0
	var/faction = "Everyone"
	var/sale_price = 0
	var/assortment_level = 0

/datum/data/stalker_equipment/New(name, name_ru, path, cost, rating, faction = "Everyone", sale_price = 0, assortment_level = 0)
	src.name = name
	src.name_ru = name_ru
	src.equipment_path = path
	src.cost = cost
	src.rating = rating
	src.faction = faction
	if(sale_price)
		src.sale_price = sale_price
	else
		src.sale_price = cost/2
	src.assortment_level = assortment_level
	switch(cost)
		if(0 to TRASH_TIER_COST)
			trash_tier_sidormatitems += src

		if(0 to LOW_TIER_COST)
			low_tier_sidormatitems += src

		if(0 to MEDIUM_TIER_COST)
			medium_tier_sidormatitems += src

		if(LOW_TIER_COST to HIGH_TIER_COST)
			high_tier_sidormatitems += src
	real_sidormat_items += src

/obj/machinery/stalker/sidormat/New()
	itemloc = locate(x - 1, y, z)
	itemloc2 = locate(x + 1, y, z)

	sleep(10)

	if(path_ending && !door_device)
		door_device = new /obj/item/device/assembly/control(src)
		door_device.id = path_ending

/obj/machinery/stalker/sidormat/attack_hand(mob/user)
	balance = 0
	if(..())
		return

	if(!ishuman(user))
		say("You are not a human.")
		return

	var/mob/living/carbon/human/H = user

	interact(H)


/obj/machinery/stalker/sidormat/interact(mob/living/carbon/human/H)

//	if(!istype(H.wear_id, /obj/item/device/stalker_pda))
	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
		say("Put on your money card or pager.","Put on your money card or pager.")
		return

	//find_record("sid", H.sid, data_core.stalkers)
//	var/obj/item/device/stalker_pda/KPK = H.wear_id
//	var/datum/data/record/sk = KPK.profile

//	if(!sk || !KPK.owner)
//		say("Activate your KPK profile.")
//		return

//	if(KPK.owner != H)
//		say("No access.")
//		return

	H.set_machine(src)

	if(istype(H.wear_id, /obj/item/device/pager))
		var/obj/item/device/pager/P = H.wear_id
		balance = P.money

	if(istype(H.wear_id, /obj/item/money_card))
		var/obj/item/money_card/P = H.wear_id
		balance = P.money
//	balance = sk.fields["money"]
//	rating = sk.fields["rating"]

	var/dat
	switch(H.client.language)
		if("English")

	///////////////////////////////////////////////////////////АНГЛИЙСКИЙ СИДОРОМАТ///////////////////////////////////////////////////////////////////////

			dat +="<div class='statusDisplay'>"
			dat += "Balance: [num2text(balance, 8)] RU<br>"
			dat += "<br><br>INSTRUCTION: Put habar for sale on the <b>left</b> table.<br>" // Забирать деньги и купленные вещи - на <b>правом</b>.
			if(!(switches & SHOW_FACTION_EQUIPMENT))
				dat +="<A href='?src=\ref[src];choice=take'><b>Sell habar</b></A><br>"
//			if(door_device && sk.fields["degree"])
//				dat +="<A href='?src=\ref[src];basement_toggle=1'><b>Toggle basement door</b></A><br>"
			dat += "</div>"
			dat += "<div class='lenta_scroll'>"
			dat += "<BR><table border='0' width='400'>" //<b>Item list:</b>
			for(var/L in global_sidormat_list)
				if(L == "Unbuyable" && !(switches & SELL_UNBUYABLE))
					continue
				dat += "<tr><td><center><big><b>[L]</b></big></center></td><td></td><td></td></tr>"
				for(var/datum/data/stalker_equipment/prize in global_sidormat_list[L])
//					if((KPK.faction_s == prize.faction && (KPK.faction_s in special_factions || (switches & SHOW_FACTION_EQUIPMENT))) || prize.faction == "Everyone")
						//if(rating >= prize.rating)
					if(get_assortment_level(H) >= prize.assortment_level)
						dat += "<tr><td>[prize.name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Buy</A></td></tr>"

			dat += "</table>"
			dat += "</div>"

		if("Russian")
		///////////////////////////////////////////////////////////РУССКИЙ СИДОРОМАТ///////////////////////////////////////////////////////////////////////

			dat +="<div class='statusDisplay'>"
			dat += "На счету: [num2text(balance, 8)] RU<br>"
			dat += "<br><br>ИНСТРУКЦИЯ: Хабар складывать - на <b>левом</b> столе.<br>" //Забирать деньги и купленные вещи - на <b>правом</b>.
			if(!(switches & SHOW_FACTION_EQUIPMENT))
				dat +="<A href='?src=\ref[src];choice=take'><b>Сбыть хабар</b></A><br>"
//			if(door_device && sk.fields["degree"])
//				dat +="<A href='?src=\ref[src];basement_toggle=1'><b>Открыть/Закрыть хранилище</b></A><br>"
			dat += "</div>"
			dat += "<div class='lenta_scroll'>"
			dat += "<BR><table border='0' width='400'>" //<b>Список предметов:</b>
			for(var/L in global_sidormat_list)
				if(L == "Unbuyable" && !(switches & SELL_UNBUYABLE))
					continue
				dat += "<tr><td><center><b>[L]</b></center></td><td></td><td></td></tr>"
				for(var/datum/data/stalker_equipment/prize in global_sidormat_list[L])
//					if((KPK.faction_s == prize.faction && (KPK.faction_s in special_factions || (switches & SHOW_FACTION_EQUIPMENT))) || prize.faction == "Everyone")
						//if(rating >= prize.rating)
					if(get_assortment_level(H) >= prize.assortment_level)
						dat += "<tr><td>[prize.name_ru]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Купить</A></td></tr>"
			dat += "</table>"
			dat += "</div>"

	var/datum/browser/popup = new(H, "miningvendor", "SIDORMAT 3000", 500, 700)
	popup.set_content(dat)
	popup.open()
	return
*/
/proc/get_assortment_level(var/mob/living/carbon/human/owner)
	return 1000
/*	var/datum/data/record/sk = find_record("sid", owner.sid, data_core.stalkers)
	var/assortment_level = 0


	for(var/obj/machinery/stalker/sidorpoint/cp in cps)
		if(cp.controlled_by == sk.fields["faction_s"] && cp.control_percent == 100)
			assortment_level++

	return assortment_level
*
/obj/machinery/stalker/sidormat/Topic(href, href_list)
	if(..())
		return

	var/mob/living/carbon/human/H = usr

//	if(!istype(H.wear_id, /obj/item/device/stalker_pda))
	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
		say("Put on your money card or pager.","Put on your money card or pager.")
		updateUsrDialog()
		return

//	var/datum/data/record/sk = find_record("sid", H.sid, data_core.stalkers)
//	var/obj/item/device/stalker_pda/KPK = H.wear_id


//	if(!sk)
//		say("Activate your KPK profile.")
//		updateUsrDialog()
//		return

//	if(!KPK.owner || (KPK.owner != H))
//		say("No access.")
//		updateUsrDialog()
//		return

	if(href_list["choice"])
		if(href_list["choice"] == "take")
			SellItems()

	if(href_list["purchase"])
		var/datum/data/stalker_equipment/prize = locate(href_list["purchase"])

		if (!prize)
			updateUsrDialog()
			return

		if(istype(H.wear_id, /obj/item/device/pager))
			var/obj/item/device/pager/P = H.wear_id

			if(prize.cost > P.money)
				say("You don't have enough money to buy [prize.name].","You don't have enough money to buy [prize.name].")
				updateUsrDialog()
				return

			P.money -= prize.cost
			balance = P.money
			//PoolOrNew(prize.equipment_path, itemloc2)
			new prize.equipment_path(itemloc2)

		if(istype(H.wear_id, /obj/item/money_card))
			var/obj/item/money_card/P = H.wear_id

			if(prize.cost > P.money)
				say("You don't have enough money to buy [prize.name].","You don't have enough money to buy [prize.name].")
				updateUsrDialog()
				return

			P.money -= prize.cost
			balance = P.money
			//PoolOrNew(prize.equipment_path, itemloc2)
			new prize.equipment_path(itemloc2)

//	if(href_list["basement_toggle"])
//		door_device.pulsed()

	//updateUsrDialog()
	return


/obj/machinery/stalker/sidormat/proc/SellItems()
	var/mob/living/carbon/human/H = usr
//	if(!istype(H.wear_id, /obj/item/device/stalker_pda))
	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
		say("Put on your money card or pager.","Put on your money card or pager.")
		return

//	var/datum/data/record/sk = find_record("sid", H.sid, data_core.stalkers)
//	var/obj/item/device/stalker_pda/KPK = H.wear_id

//	if(!sk)
//		say("Activate your profile in KPK.")
//		return

//	if(KPK.sid != H.sid)
//		say("No access.")
//		return

	if(istype(H.wear_id, /obj/item/money_card))
		var/obj/item/money_card/P = H.wear_id
		balance = P.money

	var/list/ontable = GetItemsOnTable()
	var/total_cost = GetOnTableCost(ontable)


	if(total_cost < 100)
		say("Habar was not sold.","Habar was not sold.")

	for(var/atom/movable/I in ontable)
		if(I.loc != itemloc)
			continue

		if(istype(H.wear_id, /obj/item/device/pager))
			var/obj/item/device/pager/P = H.wear_id
			P.money += GetCost(I.type)
			balance = P.money

		if(istype(H.wear_id, /obj/item/money_card))
			var/obj/item/money_card/P = H.wear_id
			P.money += GetCost(I.type)
			balance = P.money

		say("[I] was sold for [GetCost(I.type)].","[I] was sold for [GetCost(I.type)].")

		PlaceInPool(I)
		CHECK_TICK

	if(total_cost)
		say("<b>Habar was successfully sold for [total_cost].</b>","<b>Habar was successfully sold for [total_cost].</b>")

	updateUsrDialog()
	return

/obj/machinery/stalker/sidormat/proc/GetItemsOnTable()
	var/list/ontable = list()
	for(var/atom/movable/AM in itemloc)
		if(!GetCost(AM.type))
			continue

		if(istype(AM, /obj/item/clothing))
			var/obj/item/clothing/C = AM
			if((C.durability / initial(C.durability)) * 100 < 80)
				say("[AM] is too broken for sale.","[AM] is too broken for sale.")
				continue

		if(istype(AM, /obj/item/weapon/storage/backpack) && AM.contents.len)
			say("Empty [AM] before selling.","Empty [AM] before selling.")
			continue

		if(istype(AM, /obj/item/ammo_box))
			var/obj/item/ammo_box/AB = AM
			if(AB.stored_ammo.len < AB.max_ammo)
				say("Fill [AB] before selling.","Fill [AB] before selling.")
				continue

		//if(istype(AM, /obj/item/weapon/reagent_containers))
		//	say("[AM] can't be sold!")
		//	continue

		ontable += AM

	return ontable

/obj/machinery/stalker/sidormat/proc/GetOnTableCost(var/list/ontable)
	//var/list/ontable = GetItemsOnTable()
	var/total_cost = 0

	for(var/atom/item_on_table in ontable)
		var/cost = GetCost(item_on_table.type)
		if(cost)
			total_cost += cost
	return total_cost

/obj/machinery/stalker/sidormat/proc/GetCost(itemtype)
	for(var/datum/data/stalker_equipment/se in real_sidormat_items)
		if(itemtype == se.equipment_path)
			return se.sale_price
	return 0

/obj/machinery/stalker/sidormat/ex_act(severity, target)
	return
*/