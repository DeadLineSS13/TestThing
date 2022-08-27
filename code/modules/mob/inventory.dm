//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_held_item()
	return get_item_for_held_index(active_hand_index)


//Finds the opposite limb for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_held_item()
	return get_item_for_held_index(get_inactive_hand_index())


//Finds the opposite index for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_hand_index()
	var/other_hand = 0
	if(!(active_hand_index % 2))
		other_hand = active_hand_index-1 //finding the matching "left" limb
	else
		other_hand = active_hand_index+1 //finding the matching "right" limb
	if(other_hand < 0 || other_hand > held_items.len)
		other_hand = 0
	return other_hand


/mob/proc/get_item_for_held_index(i)
	if(i > 0 && i <= held_items.len)
		return held_items[i]
	return FALSE


//Odd = left(1). Even = right(2)
/mob/proc/held_index_to_dir(i)
	if(!(i % 2))
		return "r"
	return "l"


//Check we have an organ for this hand slot (Dismemberment), Only relevant for humans
/mob/proc/has_hand_for_held_index(i)
	return TRUE

/mob/living/carbon/human/has_hand_for_held_index(i)
	if(held_index_to_dir(i) == "r")
		for(var/obj/item/organ/limb/r_arm/R in organs)
			if(R.crippled)
				return FALSE
	else
		for(var/obj/item/organ/limb/l_arm/L in organs)
			if(L.crippled)
				return FALSE

	return TRUE


//Check we have an organ for our active hand slot (Dismemberment),Only relevant for humans
/mob/proc/has_active_hand()
	return has_hand_for_held_index(active_hand_index)


//Finds the first available (null) index OR all available (null) indexes in held_items based on a side.
//Lefts: 1, 3, 5, 7...
//Rights:2, 4, 6, 8...
/mob/proc/get_empty_held_index_for_side(side = "left", all = FALSE)
	var/start = 0
	var/static/list/lefts = list("l" = TRUE,"L" = TRUE,"LEFT" = TRUE,"left" = TRUE)
	var/static/list/rights = list("r" = TRUE,"R" = TRUE,"RIGHT" = TRUE,"right" = TRUE) //"to remain silent"
	if(lefts[side])
		start = 1
	else if(rights[side])
		start = 2
	if(!start)
		return FALSE
	var/list/empty_indexes
	for(var/i in start to held_items.len step 2)
		if(!held_items[i])
			if(!all)
				return i
			if(!empty_indexes)
				empty_indexes = list()
			empty_indexes += i
	return empty_indexes


//Same as the above, but returns the first or ALL held *ITEMS* for the side
/mob/proc/get_held_items_for_side(side = "left", all = FALSE)
	var/start = 0
	var/static/list/lefts = list("l" = TRUE,"L" = TRUE,"LEFT" = TRUE,"left" = TRUE)
	var/static/list/rights = list("r" = TRUE,"R" = TRUE,"RIGHT" = TRUE,"right" = TRUE) //"to remain silent"
	if(lefts[side])
		start = 1
	else if(rights[side])
		start = 2
	if(!start)
		return FALSE
	var/list/holding_items
	for(var/i in start to held_items.len step 2)
		var/obj/item/I = held_items[i]
		if(I)
			if(!all)
				return I
			if(!holding_items)
				holding_items = list()
			holding_items += I
	return holding_items


/mob/proc/get_empty_held_indexes()
	var/list/L
	for(var/i in 1 to held_items.len)
		if(!held_items[i])
			if(!L)
				L = list()
			L += i
	return L

/mob/proc/get_held_index_of_item(obj/item/I)
	return held_items.Find(I)


//Sad that this will cause some overhead, but the alias seems necessary
//*I* may be happy with a million and one references to "indexes" but others won't be
/mob/proc/is_holding(obj/item/I)
	return get_held_index_of_item(I)


//Checks if we're holding an item of type: typepath
/mob/proc/is_holding_item_of_type(typepath)
	for(var/obj/item/I in held_items)
		if(istype(I, typepath))
			return I
	return FALSE


//To appropriately fluff things like "they are holding [I] in their [get_held_index_name(get_held_index_of_item(I))]"
//Can be overriden to pass off the fluff to something else (eg: science allowing people to add extra robotic limbs, and having this proc react to that
// with say "they are holding [I] in their Nanotrasen Brand Utility Arm - Right Edition" or w/e
/mob/proc/get_held_index_name(i)
	var/list/hand = list()
	if(i > 2)
		hand += "upper "
	var/num = 0
	if(!(i % 2))
		num = i-2
		hand += "right hand"
	else
		num = i-1
		hand += "left hand"
	num -= (num*0.5)
	if(num > 1) //"upper left hand #1" seems weird, but "upper left hand #2" is A-ok
		hand += " #[num]"
	return hand.Join()

/mob/proc/get_held_index_name_ru(i)
	var/list/hand = list()
	if(i > 2)
		hand += "upper "
	var/num = 0
	if(!(i % 2))
		num = i-2
		hand += "правой руке"
	else
		num = i-1
		hand += "левой руке"
	num -= (num*0.5)
	if(num > 1) //"upper left hand #1" seems weird, but "upper left hand #2" is A-ok
		hand += " #[num]"
	return hand.Join()


//Returns if a certain item can be equipped to a certain slot.
// Currently invalid for two-handed items - call obj/item/mob_can_equip() instead.
/mob/proc/can_equip(obj/item/I, slot, disable_warning = 0)
	return FALSE


/mob/proc/put_in_hand(obj/item/I, hand_index)
	if(!put_in_hand_check(I))
		return FALSE
	if(!has_hand_for_held_index(hand_index))
		return FALSE
	var/obj/item/curr = held_items[hand_index]
	if(!curr)
		var/turf/stalker/T = get_turf(I)
		if(istype(T, /turf/stalker))
			if(T && T.triggers && T.triggers.len)
				for(var/obj/anomaly/A in T.triggers)
					if(istype(A, /obj/anomaly/natural/gravy/mosquito_net))
						var/obj/anomaly/natural/gravy/mosquito_net/N = A
						if(!(src in N.trapped) && I in N.trapped)
							N.Deactivate(I)
					if(I.ismetal && istype(A, /obj/anomaly/natural/magnetise))
						I.equipped(src, slot_hands)
						src << client.select_lang("<span class='warning'>Что-то не дает тебе сделать это!</span>","<span class='warning'>Somthing is blocking it!</span>")
						return
			T = get_turf(src)
			if(istype(T, /turf/stalker))
				if(T && T.triggers && T.triggers.len)
					for(var/obj/anomaly/A in T.triggers)
						if(istype(A, /obj/anomaly/natural/gravy/mosquito_net))
							var/obj/anomaly/natural/gravy/mosquito_net/N = A
							if(!(I in N.affected_items))
								N.Activate(I)
		I.loc = src
		held_items[hand_index] = I
		I.layer = ABOVE_HUD_LAYER
		I.plane = ABOVE_HUD_PLANE
		I.equipped(src, slot_hands)
		if(I.pulledby)
			I.pulledby.stop_pulling()
		update_inv_hands()
		I.pixel_x = initial(I.pixel_x)
		I.pixel_y = initial(I.pixel_y)
		if(I.stackable)
			I.show_count()
		return hand_index || TRUE
	return FALSE


//Puts the item into the first available left hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side("l"))


//Puts the item into the first available right hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side("r"))


/mob/proc/put_in_hand_check(obj/item/I)
	if(I.flags&ABSTRACT && !I.flags&TWOHANDED)
		return FALSE
	if(!istype(I))
		return FALSE
	return TRUE


//Puts the item into our active hand if possible. returns TRUE on success.
/mob/proc/put_in_active_hand(obj/item/I)
	return put_in_hand(I, active_hand_index)


//Puts the item into our inactive hand if possible, returns TRUE on success
/mob/proc/put_in_inactive_hand(obj/item/I)
	return put_in_hand(I, get_inactive_hand_index())


//Puts the item our active hand if possible. Failing that it tries other hands. Returns TRUE on success.
//If both fail it drops it on the floor and returns FALSE.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/I, del_on_fail = FALSE)
	if(!I)
		return FALSE
	if(put_in_active_hand(I))
		return TRUE
	var/hand = get_empty_held_index_for_side("l")
	if(!hand)
		hand = get_empty_held_index_for_side("r")
	if(hand)
		if(put_in_hand(I, hand))
			return TRUE
	if(del_on_fail)
		qdel(I)
		return FALSE
	I.forceMove(get_turf(src))
	I.layer = initial(I.layer)
	I.plane = initial(I.plane)
	I.dropped(src)
	return FALSE


/mob/proc/put_in_hands_or_del(obj/item/I)
	return put_in_hands(I, TRUE)


/mob/proc/drop_item_v()		//this is dumb.
	if(stat == CONSCIOUS && isturf(loc))
		return drop_item()
	return FALSE

/mob/proc/drop_all_held_items()
	if(!loc || !loc.allow_drop())
		return
	for(var/obj/item/Item in held_items)
		Item.remove_count()
		for(var/obj/item/I in loc)
			if(I.stackable)
				if(I.type == Item.type)
					if(I.current_stack < I.stackable)
						if(istype(I, /obj/item/ammo_casing))
							var/obj/item/ammo_casing/AC = I
							var/obj/item/ammo_casing/A = Item
							if(A.BB && AC.BB && A.BB.type != AC.BB.type)
								return unEquip(Item, 0, 0)
							else if((A.BB && !AC.BB) || (!A.BB && AC.BB))
								return unEquip(Item, 0, 0)
						if(I.current_stack <= I.stackable - Item.current_stack)
							I.current_stack += Item.current_stack
							I.weight += Item.weight
							held_items[get_held_index_of_item(Item)] = null
							qdel(Item)
							update_inv_hands()
							return
						else
							var/diff = I.stackable - Item.current_stack
							Item.current_stack = Item.current_stack - diff
							I.current_stack = I.stackable
							I.weight += initial(Item.weight) * diff
							Item.weight -= initial(Item.weight) * diff
							Item.remove_count()
						I.update_icon()
		unEquip(Item, 0, 0)

//Drops the item in our active hand.
/mob/proc/drop_item()
	if(!loc || !loc.allow_drop())
		return
	var/obj/item/held = get_active_held_item()
	if(held)
		held.remove_count()
		for(var/obj/item/I in loc)
			if(I.stackable)
				if(I.type == held.type)
					if(I.current_stack < I.stackable)
						if(istype(I, /obj/item/ammo_casing))
							var/obj/item/ammo_casing/AC = I
							var/obj/item/ammo_casing/A = held
							if(A.BB && AC.BB && A.BB.type != AC.BB.type)
								return unEquip(held, 0, 0)
							else if((A.BB && !AC.BB) || (!A.BB && AC.BB))
								return unEquip(held, 0, 0)
						if(I.current_stack <= I.stackable - held.current_stack)
							I.current_stack += held.current_stack
							I.weight += held.weight
							held_items[get_held_index_of_item(held)] = null
							qdel(held)
							update_inv_hands()
							return
						else
							var/diff = I.stackable - held.current_stack
							held.current_stack = held.current_stack - diff
							I.current_stack = I.stackable
							I.weight += initial(held.weight) * diff
							held.weight -= initial(held.weight) * diff
							held.remove_count()
						I.update_icon()
	return unEquip(held, 0, 0)


//Here lie drop_from_inventory and before_item_take, already forgotten and not missed.

/mob/proc/canUnEquip(obj/item/I, force)
	if(!I)
		return TRUE
	if((I.flags & NODROP) && !force)
		return FALSE
	return TRUE

/mob/proc/unEquip(obj/item/I, force, delay = 1) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!I) //If there's nothing to drop, the drop is automatically succesfull. If(unEquip) should generally be used to check for NODROP.
		return TRUE
	if((I.flags & NODROP) && !force)
		return FALSE
	if(I.equip_delay && delay && !is_holding(I))
		if(I.flags & IN_PROGRESS)
			return FALSE

		I.flags += IN_PROGRESS
		if(!do_after(src, I.equip_delay/2, 1, I))
			I.flags &= ~IN_PROGRESS
			return FALSE
		I.flags &= ~IN_PROGRESS
	if(istype(I, /obj/item/clothing/suit))
		var/obj/item/clothing/suit/S = I
		if(S.plates)
			unEquip(S.plates, 1, 0)
			S.plates.loc = S
			S.weight = initial(S.weight)
	var/hand_index = get_held_index_of_item(I)
	if(hand_index)
		held_items[hand_index] = null
		update_inv_hands()
	if(I)
		if(client)
			client.screen -= I
		I.layer = initial(I.layer)
		I.plane = initial(I.plane)
		I.appearance_flags &= ~NO_CLIENT_COLOR
		I.forceMove(loc)
		I.dropped(src)

	return TRUE


//Attemps to remove an object on a mob.  Will not move it to another area or such, just removes from the mob.
/mob/proc/remove_from_mob(var/obj/item/I)
	unEquip(I)
	I.screen_loc = null
	return TRUE


//Outdated but still in use apparently. This should at least be a human proc.
//Daily reminder to murder this - Remie.
/mob/living/proc/get_equipped_items()
	return

/mob/living/carbon/get_equipped_items()
	var/list/items = list()
	if(back)
		items += back
	if(back2)
		items += back2
	if(head)
		items += head
	if(wear_mask)
		items += wear_mask
	return items

/mob/living/carbon/human/get_equipped_items()
	var/list/items = ..()
	if(belt)
		items += belt
	if(ears)
		items += ears
	if(glasses)
		items += glasses
	if(gloves)
		items += gloves
	if(shoes)
		items += shoes
	if(wear_id)
		items += wear_id
	if(wear_suit)
		items += wear_suit
	if(w_uniform)
		items += w_uniform
	return items



/obj/item/proc/equip_to_best_slot(var/mob/M)
	if(src != M.get_active_held_item())
		M << "<span class='warning'>You are not holding anything to equip!</span>"
		return FALSE

	if(M.equip_to_appropriate_slot(src, 1))
		M.update_inv_hands()
		return TRUE

	if(M.s_active && M.s_active.can_be_inserted(src,1))	//if storage active insert there
		M.s_active.handle_item_insertion(src)
		return TRUE

	var/obj/item/weapon/storage/S = M.get_inactive_held_item()
	if(istype(S) && S.can_be_inserted(src,1))	//see if we have box in other hand
		S.handle_item_insertion(src)
		return TRUE

	S = M.get_item_by_slot(slot_belt)
	if(istype(S) && S.can_be_inserted(src,1))		//else we put in belt
		S.handle_item_insertion(src)
		return TRUE

//	S = M.get_item_by_slot(slot_generic_dextrous_storage)	//else we put in whatever is in drone storage
//	if(istype(S) && S.can_be_inserted(src,1))
//		S.handle_item_insertion(src)

	S = M.get_item_by_slot(slot_back)	//else we put in backpack
	if(istype(S) && S.can_be_inserted(src,1))
		S.handle_item_insertion(src)
		playsound(src.loc, "rustle", 50, 1, -5, channel = "regular", time = 5)
		return TRUE

	M << "<span class='warning'>You are unable to equip that!</span>"
	return FALSE


/mob/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	var/obj/item/I = get_active_held_item()
	if (I)
		I.equip_to_best_slot(src)

//used in code for items usable by both carbon and drones, this gives the proper back slot for each mob.(defibrillator, backpack watertank, ...)
/mob/proc/getBackSlot()
	return slot_back

/mob/proc/getBeltSlot()
	return slot_belt