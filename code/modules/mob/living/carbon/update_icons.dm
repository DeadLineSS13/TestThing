//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	var/changed = 0
	if(lying != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev,lying)
		if(lying == 0) //Lying to standing
			final_pixel_y = get_standard_pixel_y_offset()
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y = get_standard_pixel_y_offset(lying)
				if(dir & (EAST|WEST)) //Facing east or west
					final_dir = pick(NORTH, SOUTH) //So you fall on your side rather than your face or ass

		lying_prev = lying	//so we don't try to animate until there's been another change.
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 0, pixel_y = final_pixel_y, dir = final_dir, easing = EASE_IN|EASE_OUT)
		floating = 0  // If we were without gravity, the bouncing animation got stopped, so we make sure we restart it in next life().


/mob/living/carbon/regenerate_icons()
	if(notransform)
		return 1
	update_inv_hands()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_fire()


/mob/living/carbon/update_inv_hands()
	remove_overlay(HANDS_LAYER)
	if (handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	for(var/obj/item/I in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			I.screen_loc = ui_hand_position(get_held_index_of_item(I))
			client.screen += I

		var/t_state = I.item_state
		if(!t_state)
			t_state = I.icon_state

		var/icon_file = I.lefthand_file
		if(get_held_index_of_item(I) % 2 == 0)
			icon_file = I.righthand_file

		var/image/standing = I.build_worn_icon(state = t_state, default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)
		hands += standing

	overlays_standing[HANDS_LAYER] = hands
	apply_overlay(HANDS_LAYER)


/mob/living/carbon/update_fire(var/fire_icon = "Generic_mob_burning")
	remove_overlay(FIRE_LAYER)
	if(on_fire)
		overlays_standing[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"= fire_icon, "layer"=-FIRE_LAYER)

	apply_overlay(FIRE_LAYER)


/mob/living/carbon/update_inv_wear_mask()
	remove_overlay(FACEMASK_LAYER)

//	if(!get_bodypart("head")) //Decapitated
//		return

	if(client && hud_used && hud_used.inv_slots[slot_wear_mask])
		var/obj/screen/inventory/inv = hud_used.inv_slots[slot_wear_mask]
		inv.update_icon()

	if(wear_mask)
		if(!(head && (head.flags_inv & HIDEMASK)))
			var/image/standing = wear_mask.build_worn_icon(state = wear_mask.icon_state, default_layer = FACEMASK_LAYER, default_icon_file = 'icons/mob/mask.dmi')
			overlays_standing[FACEMASK_LAYER] = standing
		update_hud_wear_mask(wear_mask)

	apply_overlay(FACEMASK_LAYER)

/mob/living/carbon/update_inv_back()
	remove_overlay(BACK_LAYER)
	remove_overlay(BACK_BEHIND_LAYER)

	if(client && hud_used && hud_used.inv_slots[slot_back])
		var/obj/screen/inventory/inv = hud_used.inv_slots[slot_back]
		inv.update_icon()

	if(back)
		var/image/standing = back.build_worn_icon(state = back.icon_state, default_layer = BACK_LAYER, default_icon_file = 'icons/mob/back.dmi')
		var/image/standing2 = back.build_worn_icon(state = "[back.icon_state]_b", default_layer = BACK_BEHIND_LAYER, default_icon_file = 'icons/mob/back.dmi')
		overlays_standing[BACK_LAYER] = standing
		overlays_standing[BACK_BEHIND_LAYER] = standing2
		update_hud_back(back)
	apply_overlay(BACK_LAYER)
	apply_overlay(BACK_BEHIND_LAYER)

/mob/living/carbon/update_inv_back2()
	remove_overlay(BACK2_LAYER)
	remove_overlay(BACK2_BEHIND_LAYER)

	if(client && hud_used && hud_used.inv_slots[slot_back2])
		var/obj/screen/inventory/inv = hud_used.inv_slots[slot_back2]
		inv.update_icon()

	if(back2)
		var/image/standing = back2.build_worn_icon(state = back2.icon_state, default_layer = BACK2_LAYER, default_icon_file = 'icons/stalker/mob/back2.dmi')
		var/image/standing2 = back2.build_worn_icon(state = "[back2.icon_state]_b", default_layer = BACK2_BEHIND_LAYER, default_icon_file = 'icons/stalker/mob/back2.dmi')
		overlays_standing[BACK2_LAYER] = standing
		overlays_standing[BACK2_BEHIND_LAYER] = standing2
		update_hud_back2(back2)

	apply_overlay(BACK2_LAYER)
	apply_overlay(BACK2_BEHIND_LAYER)

/mob/living/carbon/update_inv_head()
	remove_overlay(HEAD_LAYER)

//	if(!get_bodypart("head")) //Decapitated
//		return

	if(client && hud_used && hud_used.inv_slots[slot_back])
		var/obj/screen/inventory/inv = hud_used.inv_slots[slot_head]
		inv.update_icon()

	if(client && hud_used && hud_used.inv_slots[slot_back2])
		var/obj/screen/inventory/inv = hud_used.inv_slots[slot_head]
		inv.update_icon()

	if(head)
		var/image/standing = head.build_worn_icon(state = head.icon_state, default_layer = HEAD_LAYER, default_icon_file = 'icons/mob/head.dmi')
		overlays_standing[HEAD_LAYER] = standing
		update_hud_head(head)

	apply_overlay(HEAD_LAYER)


/mob/living/carbon/update_inv_handcuffed()
	remove_overlay(HANDCUFF_LAYER)
	if(handcuffed)
		overlays_standing[HANDCUFF_LAYER] = image("icon"='icons/mob/mob.dmi', "icon_state"="handcuff1", "layer"=-HANDCUFF_LAYER)
		apply_overlay(HANDCUFF_LAYER)


//mob HUD updates for items in our inventory

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/obj/screen/inventory/hand/H = hud_used.hand_slots[hand]
			if(H)
				H.update_icon()

//update whether our head item appears on our hud.
/mob/living/carbon/proc/update_hud_head(obj/item/I)
	return

//update whether our mask item appears on our hud.
/mob/living/carbon/proc/update_hud_wear_mask(obj/item/I)
	return

//update whether our neck item appears on our hud.
/mob/living/carbon/proc/update_hud_neck(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_back(obj/item/I)
	return

/mob/living/carbon/proc/update_hud_back2(obj/item/I)
	return




//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
/obj/item/proc/worn_overlays(isinhands = FALSE)
	. = list()


/mob/living/carbon/update_body()
	return
/*
	update_body_parts()

/mob/living/carbon/proc/update_body_parts()
	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	icon_render_key = generate_icon_render_key()
	if(oldkey == icon_render_key)
		return

	remove_overlay(BODYPARTS_LAYER)

	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		BP.update_limb()

	//LOAD ICONS
	if(limb_icon_cache[icon_render_key])
		load_limb_from_cache()
		return

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		var/image/temp = BP.get_limb_icon()
		if(temp)
			new_limbs += temp
	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()



/////////////////////
// Limb Icon Cache //
/////////////////////

	Called from update_body_parts() these procs handle the limb icon cache.
	the limb icon cache adds an icon_render_key to a human mob, it represents:
	- skin_tone (if applicable)
	- gender
	- limbs (stores as the limb name and whether it is removed/fine, organic/robotic)
	These procs only store limbs as to increase the number of matching icon_render_keys
	This cache exists because drawing 6/7 icons for humans constantly is quite a waste
	See RemieRichards on irc.rizon.net #coderbus


var/global/list/limb_icon_cache = list()

/mob/living/carbon
	var/icon_render_key = ""


//produces a key based on the mob's limbs

/mob/living/carbon/proc/generate_icon_render_key()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		. += "-[BP.body_zone]"
		if(BP.use_digitigrade)
			. += "-digitigrade[BP.use_digitigrade]"
		if(BP.animal_origin)
			. += "-[BP.animal_origin]"
		if(BP.status == BODYPART_ORGANIC)
			. += "-organic"
		else
			. += "-robotic"

	if(disabilities & HUSK)
		. += "-husk"


//change the mob's icon to the one matching its key
/mob/living/carbon/proc/load_limb_from_cache()
	if(limb_icon_cache[icon_render_key])
		remove_overlay(BODYPARTS_LAYER)
		overlays_standing[BODYPARTS_LAYER] = limb_icon_cache[icon_render_key]
		apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()
*/