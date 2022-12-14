/mob/living/carbon/human/can_equip(obj/item/I, slot, disable_warning = 0)
	return dna.species.can_equip(I, slot, disable_warning, src)


/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/I, list/slots, qdel_on_fail = 1)
	for(var/slot in slots)
		if(equip_to_slot_if_possible(I, slots[slot], qdel_on_fail = 0))
			return slot
	if(qdel_on_fail)
		qdel(I)
	return null


// Return the item currently in the slot ID
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(slot_back)
			return back
		if(slot_back2)
			return back2
		if(slot_wear_mask)
			return wear_mask
		if(slot_handcuffed)
			return handcuffed
		if(slot_legcuffed)
			return legcuffed
		if(slot_belt)
			return belt
		if(slot_wear_id)
			return wear_id
		if(slot_ears)
			return
		if(slot_glasses)
			return glasses
		if(slot_gloves)
			return gloves
		if(slot_head)
			return head
		if(slot_shoes)
			return shoes
		if(slot_wear_suit)
			return wear_suit
		if(slot_wear_suit_hard)
			return wear_suit_hard
		if(slot_head_hard)
			return head_hard
		if(slot_w_uniform)
			return w_uniform
		if(slot_l_store)
			return l_store
		if(slot_r_store)
			return r_store
		if(slot_s_store)
			return
	return null

/mob/living/carbon/human/proc/get_all_slots()
	. = get_head_slots() | get_body_slots()

/mob/living/carbon/human/proc/get_armor_slots()
	return list(
				wear_suit,
				wear_suit_hard,
				head,
				head_hard
				)

/mob/living/carbon/human/proc/get_body_slots()
	return list(
		back,
		handcuffed,
		legcuffed,
		wear_suit,
		wear_suit_hard,
		gloves,
		shoes,
		belt,
		wear_id,
		l_store,
		r_store,
		w_uniform,
		back2
		)

/mob/living/carbon/human/proc/get_head_slots()
	return list(
		head,
		head_hard,
		wear_mask,
		glasses
		)

/mob/living/carbon/human/proc/get_storage_slots()
	return list(
		back,
		belt,
		l_store,
		r_store,
		back2
		)

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/human/equip_to_slot(obj/item/I, slot)
	if(!..()) //a check failed or the item has already found its slot
		return

	var/not_handled = FALSE //Added in case we make this type path deeper one day
	switch(slot)
		if(slot_belt)
			belt = I
			update_inv_belt()
		if(slot_wear_id)
			wear_id = I
//			sec_hud_set_ID()
			update_inv_wear_id()
//		if(slot_ears)
//			ears = I
//			update_inv_ears()
		if(slot_glasses)
			glasses = I
			var/obj/item/clothing/glasses/G = I
			if(G.glass_colour_type)
				update_glasses_color(G, 1)
//			if(G.tint)
//				update_tint()
//			if(G.vision_correction)
//				clear_fullscreen("nearsighted")
			if(G.vision_flags || G.darkness_view || G.invis_override || G.invis_view)
				update_sight()
			update_inv_glasses()
		if(slot_gloves)
			gloves = I
			update_inv_gloves()
		if(slot_shoes)
			shoes = I
			update_inv_shoes()
		if(slot_wear_suit)
			wear_suit = I
			if(I.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform()
//			if(wear_suit.breakouttime) //when equipping a straightjacket
//				stop_pulling() //can't pull if restrained
//				update_action_buttons_icon() //certain action buttons will no longer be usable.
			update_inv_wear_suit()
		if(slot_wear_suit_hard)
			if(!I.additional_slot)
				wear_suit_hard = I
				update_inv_wear_suit_hard()
			else
				return
		if(slot_head_hard)
			if(!I.additional_slot)
				head_hard = I
				head_update(I)
				update_inv_head_hard()
			else
				return
		if(slot_w_uniform)
			w_uniform = I
//			update_suit_sensors()
			update_inv_w_uniform()
		if(slot_l_store)
			l_store = I
			update_inv_pockets()
		if(slot_r_store)
			r_store = I
			update_inv_pockets()
//		if(slot_s_store)
//			s_store = I
//			update_inv_s_store()
		else
			src << "<span class='danger'>You are trying to equip this item to an unsupported inventory slot. Report this to a coder!</span>"

	//Item is handled and in slot, valid to call callback, for this proc should always be true
	if(!not_handled)
		I.equipped(src, slot)

	return not_handled //For future deeper overrides

/mob/living/carbon/human/unEquip(obj/item/I, force, delay = 1)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(!. || !I)
		return

	if(I == wear_suit)
//		if(s_store)
//			unEquip(s_store, 1) //It makes no sense for your suit storage to stay on you if you drop your suit.
//		if(wear_suit.breakouttime) //when unequipping a straightjacket
//			update_action_buttons_icon() //certain action buttons may be usable again.
		wear_suit = null
		if(I.flags_inv & HIDEJUMPSUIT)
			update_inv_w_uniform()
		update_inv_wear_suit()
	else if(I == wear_suit_hard)
		wear_suit_hard = null
		update_inv_wear_suit_hard()
	else if(I == w_uniform)
		if(r_store)
			unEquip(r_store, 1) //Again, makes sense for pockets to drop.
		if(l_store)
			unEquip(l_store, 1)
		if(wear_id)
			unEquip(wear_id)
		if(belt)
			unEquip(belt)
		w_uniform = null
//		update_suit_sensors()
		update_inv_w_uniform()
	else if(I == gloves)
		gloves = null
		update_inv_gloves()
	else if(I == glasses)
		glasses = null
		var/obj/item/clothing/glasses/G = I
		if(G.glass_colour_type)
			update_glasses_color(G, 0)
//		if(G.tint)
//			update_tint()
//		if(G.vision_correction)
//			if(disabilities & NEARSIGHT)
//				overlay_fullscreen("nearsighted", /obj/screen/fullscreen/impaired, 1)
		if(G.vision_flags || G.darkness_view || G.invis_override || G.invis_view)
			update_sight()
		update_inv_glasses()
	else if(I == head_hard)
		head_hard = null
		head_update(I)
		update_inv_head_hard()
	else if(I == shoes)
		shoes = null
		update_inv_shoes()
	else if(I == belt)
		belt = null
		update_inv_belt()
	else if(I == wear_id)
		wear_id = null
//		sec_hud_set_ID()
		update_inv_wear_id()
	else if(I == r_store)
		r_store = null
		update_inv_pockets()
	else if(I == l_store)
		l_store = null
		update_inv_pockets()

/mob/living/carbon/human/wear_mask_update(obj/item/clothing/C, toggle_off = 1)
	if((C.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || (initial(C.flags_inv) & (HIDEHAIR|HIDEFACIALHAIR)))
		update_hair()
	if(toggle_off && internal && !getorganslot("breathing_tube"))
//		update_internals_hud_icon(0)
		internal = null
	if(C.flags_inv & HIDEEYES)
		update_inv_glasses()
//	sec_hud_set_security_status()
	..()

/mob/living/carbon/human/head_update(obj/item/I, forced)
	if((I.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || forced)
		update_hair()
	if(I.flags_inv & HIDEEYES || forced)
		update_inv_glasses()
	if(I.flags_inv & HIDEEARS || forced)
		update_body()
//	sec_hud_set_security_status()
	..()

/mob/living/carbon/human/proc/equipOutfit(outfit, visualsOnly = FALSE)
	var/datum/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return 0
	if(!O)
		return 0

	return O.equip(src, visualsOnly)
