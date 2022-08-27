/obj/item/weapon/kitchen/knife/tourist
	damtype = "cut"

/obj/item/weapon/kitchen/knife/tourist/RightClick(mob/user)
	..()
	if(!Adjacent(user))
		return
	switch(damtype)
		if("imp")
			damtype = "cut"
			dmgvalue = "amplitude"
			add_dmg = -2
			attack_verb_ru = list("резанул", "рубанул", "полоснул")
			attack_verb = list("slashed", "sliced", "torn", "cut")
			user << user.client.select_lang("<span class='notice'>“ы будешь наносить режущий удар.</span>","<span class='notice'>Now you are cutting.</span>")
		if("cut")
			damtype = "imp"
			dmgvalue = "straight"
			attack_verb_ru = list("ткнул", "кольнул")
			attack_verb = list("stabbed", "ripped", "diced")
			user << user.client.select_lang("<span class='notice'>“ы будешь наносить колющий удар.</span>","<span class='notice'>Now you are stabbing.</span>")


/obj/item/weapon/kitchen/knife/tourist
	name_ru = "нож дл€ выживани€"
	name = "survival knife"
	desc_ru = "—ойдет, наверное."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "knife"
	icon_ground = "knife_ground"
	item_state = "knife"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	dmgvalue = "amplitude"
	force = 25
	throwforce = 5
	w_class = 2
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP_ACCURATE
	butcher_speed = 1
	weight = 0.35
	ismetal = 1

/obj/item/weapon/kitchen/knife/vykid
	name = "switchblade"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "vykid0"
	item_state = null
	desc = "ќстрый ножик дл€ взрослых детей."
	flags = CONDUCT
	damtype = "crush"
	dmgvalue = "straight"
	add_dmg = -2
	force = 5
	w_class = 2
	throwforce = 5
	throw_speed = 3
	throw_range = 6
	materials = list(MAT_METAL=12000)
	origin_tech = "materials=1"
	hitsound = 'sound/weapons/Genhit.ogg'
	attack_verb = list("ударил")
	var/extended = 0

/obj/item/weapon/kitchen/knife/vykid/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1, channel = "regular", time = 10)
	if(extended)
		force = 25
		w_class = 3
		throwforce = 15
		damtype = "imp"
		dmgvalue = "straight"
		add_dmg = -1
		icon = 'icons/obj/weapons.dmi'
		item_state = "knife"
		icon_state = "vykid1"
		icon_hands = icon_state
		attack_verb_ru = list("ткнул", "кольнул")
		attack_verb = list("stabbed", "ripped", "diced")
		hitsound = 'sound/weapons/bladeslice.ogg'
	else
		force = 5
		w_class = 2
		throwforce = 5
		damtype = "crush"
		dmgvalue = "straight"
		add_dmg = -2
		icon = 'icons/obj/weapons.dmi'
		icon_state = "vykid0"
		icon_hands = icon_state
		attack_verb_ru = list("ударил")
		attack_verb = list("hit")
		item_state = null
		hitsound = 'sound/weapons/Genhit.ogg'
		if(user.flags & IN_PROGRESS)
			user.flags &= ~IN_PROGRESS
			user.stunned = 1
			spawn(1)
				user.stunned = 0

/obj/item/weapon/kitchen/knife/bayonet
	name = "bayonet"
	desc_ru = "ќпасный, но плохой в разделке туш мутантов штык-нож."
	desc = "Dangerous, but bad at butchering mutants bayonet."
	icon = 'icons/stalker/weapons.dmi'
	icon_state = "bayonet"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 37
	throwforce = 20
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_ru = list("ткнул", "кольнул")
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE
	butcher_speed = 1.25
	weight = 0.35

/obj/item/weapon/woodaxe
	name_ru = "лесорубный топор"
	name = "wood axe"
	desc_ru = "“€желый..."
	desc = "Heavy..."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "woodaxe"
	icon_ground = "woodaxe_ground"
	item_state = "woodaxe"
	flags = CONDUCT | TWOHANDED
	dmgvalue = "amplitude"
	damtype = "cut"
//	str_need = 12
	add_dmg = 2
	force = 25
	throwforce = 15
	w_class = 3
	hitsound = 'sound/weapons/chop.ogg'
	attack_verb_ru = list("резанул", "рубанул", "полоснул")
	attack_verb = list("slashed", "sliced", "torn", "cut")
	sharpness = IS_SHARP_ACCURATE
	weight = 4
/*
/obj/item/weapon/woodaxe/attack_self()
	switch(damtype)
		if("imp")
			damtype = "cut"
			dmgvalue = "amplitude"
			add_dmg = 2
			usr << usr.client.select_lang("<span class='notice'>“ы будешь наносить режущий удар.</span>","<span class='notice'>Now you are cutting.</span>")
		if("cut")
			damtype = "crush"
			dmgvalue = "amplitude"
			add_dmg = 1
			usr << usr.client.select_lang("<span class='notice'>“ы будешь бить обухом.</span>","<span class='notice'>Now you are stabbing.</span>")
*/

/obj/item/weapon/shovel
	name = "shovel"
	name_ru = "лопата"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 3
	throwforce = 1
	item_state = "shovel"
	w_class = 3
	origin_tech = "materials=2;engineering=2"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharpness = IS_SHARP

/obj/item/weapon/shovel/attack_self(mob/living/carbon/user)
	if(flags & IN_PROGRESS)
		return
	if(istype(get_turf(user.loc), /turf/stalker/floor/digable))
		for(var/atom/A in user.loc)
			if(istype(A, /obj/structure/closet/grave) || istype(A, /mob/living/carbon/human/guard))
				return
		flags += IN_PROGRESS
		user.direct_visible_message("<span class='notice'>DOER started to dig a grave...</span>",
									"<span class='notice'>You started to dig a grave...</span>",
									"<span class='notice'>DOER начал копать могилу...</span>",
									"<span class='notice'>¬ы начали копать могилу...</span>",
									"notice", user)
		if(!do_after(user, 300, 1, get_turf(loc)))
			flags &= ~IN_PROGRESS
			return
		new /obj/structure/closet/grave(get_turf(loc))
		user.direct_visible_message("<span class='notice'>[user] выкопал могилу.</span>", "<span class='notice'>¬ы выкопали могилу.</span>")
		flags &= ~IN_PROGRESS
	else
		user << user.client.select_lang("<span class='warning'>¬ы не можете здесь копать!</span>","<span class='warning'>You can't dig here!</span>")
