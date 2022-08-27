var/obj/item/device/pager/pagers = list()

/obj/item/device/pager
	name = "pager"
	desc = "A portable device, used to communicate with other stalkers."
	icon = 'icons/stalker/device_new.dmi'
	icon_state = "kpk_off"
	item_state = "kpk"
	w_class = 1
	slot_flags = SLOT_ID

	var/money = 0
	var/obj/item/money_card/mc = null
	var/mob/living/carbon/human/owner = null
	var/made_photo = 0

/obj/item/device/pager/New()
	..()
	pagers += src
	mc = new /obj/item/money_card()

/obj/item/device/pager/examine(mob/user)
	..()
	var/msg
	msg += "<span class='info'>Money: [money]</span>"
	user << msg

/obj/item/money_card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	icon_state = "data"
	icon_ground = "data_ground"
	w_class = 1
	slot_flags = SLOT_ID

	var/money = 0

/obj/item/money_card/examine(mob/user)
	..()
	user << "<span class='info'>Money: [money]</span>"

/obj/item/device/pager/attack_hand(mob/living/carbon/human/user)
	if(!istype(user.wear_id, src) && !user.is_holding(src))
		return MouseDrop(user)
	var/t = sanitize_russian(stripped_input(user, "Please enter the message", name, null), 0)
	if(!t)
		return
	send_message(t, user)

/obj/item/device/pager/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		var/mob/living/carbon/human/H = M
		if(src != H.wear_id)
			if(M.unEquip(src))
				M.put_in_hands(src)

	else if(istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(!remove_item_from_storage(M))
			if(!M.unEquip(src))
				return
		M.put_in_hand(src, H.held_index)

	add_fingerprint(M)

/obj/item/device/pager/proc/send_message(var/message, mob/living/user)
	for(var/obj/item/device/pager/P in pagers)
		var/mob/living/M
		if(isliving(P.loc))
			M = P.loc

			if(user.faction_s == M.faction_s)
				if(user != M)
					M << sound('sound/stalker/pda/sms.ogg', volume = 30, channel = SSchannels.get_channel(5))
				M << "<b><font color = \"#ff7733\">\[[user.name]\]</font></b>: <font color=\"#006699\">[message]</font>"

/obj/item/device/pager/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/money_card))
		return ..()

	var/obj/item/money_card/It = user.get_active_held_item()
	if(!mc)
		if(istype(It, /obj/item/money_card))
			if(!user.unEquip(I))
				return 0
			I.loc = src
			mc = I
			money += mc.money
			mc.money = 0
	else
		if(istype(It, /obj/item/money_card) && It.money)
			money += It.money
			It.money = 0
			user << "<span class='notice'>You've transfered money to your pager</span>"
		else
			user << "<span class='warning'>There's already something inside!</span>"

/obj/item/device/pager/attack_self(mob/living/user)
	if(mc)
		mc.money = money
		money = 0
		user.put_in_hands(mc)
		usr << "<span class='notice'>You remove the card from the [name].</span>"
		mc = null
	else
		user.attack_hand()
		return