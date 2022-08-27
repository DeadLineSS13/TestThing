//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/hooded
	var/obj/item/clothing/head/hood
	var/hoodtype = /obj/item/clothing/head/winterhood //so the chaplain hoodie or other hoodies can override this

/obj/item/clothing/suit/hooded/New()
	MakeHood()
	..()

/obj/item/clothing/suit/hooded/Destroy()
	qdel(hood)
	return ..()

/obj/item/clothing/suit/hooded/proc/MakeHood()
	if(!hood)
		var/obj/item/clothing/head/W = new hoodtype(src)
		hood = W

/obj/item/clothing/suit/hooded/RightClick(mob/user)
	..()
	ToggleHood()

/obj/item/clothing/suit/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/hooded/proc/RemoveHood()
	if(icon_state == "[initial(icon_state)]_t_c")
		icon_state = "[initial(icon_state)]_c"
	else
		icon_state = "[initial(icon_state)]"
	suittoggled = 0
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1, 0)
		H.update_inv_wear_suit()
	/*
	if(CCBS)
		var/obj/item/clothing/head/winterhood/stalker/nightvision/nighthood = hood
		if(nighthood.active)
			nighthood.attack_self()
	*/
	hood.loc = src

/obj/item/clothing/suit/hooded/dropped()
	. = ..()
	RemoveHood()

/obj/item/clothing/suit/hooded/proc/ToggleHood()
	if(!suittoggled)
		if(ishuman(src.loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				H << "<span class='warning'>You must be wearing [src] to put up the hood!</span>"
				return
			if(H.head)
				H << "<span class='warning'>You're already wearing something on your head!</span>"
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1,0)
				suittoggled = 1
				if(icon_state =="[initial(icon_state)]_c")
					icon_state = "[initial(icon_state)]_t_c"
				else
					icon_state = "[initial(icon_state)]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()

//Toggle exosuits for different aesthetic styles (hoodies, suit jacket buttons, etc)

/obj/item/clothing/suit/toggle/AltClick(mob/user)
	..()
	if(!user.canUseTopic(user))
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		suit_toggle(user)

/obj/item/clothing/suit/toggle/ui_action_click()
	suit_toggle()

/obj/item/clothing/suit/toggle/proc/suit_toggle()
	set src in usr

	if(!can_use(usr))
		return 0

	usr << "<span class='notice'>You toggle [src]'s [togglename].</span>"
	if(src.suittoggled)
		src.icon_state = "[initial(icon_state)]"
		src.suittoggled = 0
	else if(!src.suittoggled)
		src.icon_state = "[initial(icon_state)]_t"
		src.suittoggled = 1
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/toggle/examine(mob/user)
	..()
	user << "Alt-click on [src] to toggle the [togglename]."
